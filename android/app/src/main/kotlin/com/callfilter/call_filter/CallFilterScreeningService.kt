package com.callfilter.call_filter

import android.os.SystemClock
import android.telecom.Call
import android.telecom.CallScreeningService
import java.util.UUID
import java.util.concurrent.ExecutionException
import java.util.concurrent.Executors
import java.util.concurrent.RejectedExecutionException
import java.util.concurrent.TimeUnit
import java.util.concurrent.TimeoutException

/**
 * Android call screening entry point.
 *
 * The service fails open on missing caller names, stale/corrupt snapshots,
 * matcher timeouts and unexpected errors. A rejected call is only possible
 * when the current snapshot has filtering enabled, the number is not
 * whitelisted, and an active rule matches the supplied caller display name.
 */
class CallFilterScreeningService : CallScreeningService() {
    override fun onScreenCall(callDetails: Call.Details) {
        val operationId = UUID.randomUUID().toString().take(8)
        val startedAt = SystemClock.elapsedRealtime()
        var responseAttempted = false

        try {
            val snapshot = CallFilterPreferences.load(this)
            val rawPhone = callDetails.handle?.schemeSpecificPart.orEmpty()
            val displayName = callDetails.callerDisplayName
            CallFilterScreeningLog.event(
                operationId,
                "callback_received",
                mapOf(
                    "snapshot" to snapshot.schemaVersion,
                    "rules" to snapshot.rules.size,
                    "whitelist" to snapshot.whitelistNumbers.size,
                    "filtering" to snapshot.filteringEnabled,
                    "name_present" to !displayName.isNullOrBlank(),
                    "phone_hash" to CallFilterScreeningLog.phoneHash(rawPhone),
                ),
            )

            val decision = evaluateWithTimeout(snapshot, rawPhone, displayName)
            CallFilterScreeningLog.event(
                operationId,
                "decision",
                mapOf(
                    "snapshot" to snapshot.schemaVersion,
                    "block" to decision.shouldBlock,
                    "reason" to decision.reason.wireName,
                    "whitelisted" to decision.whitelisted,
                    "name_present" to decision.callerNameAvailable,
                    "rule_id" to decision.matchedRuleId,
                    "duration_ms" to (SystemClock.elapsedRealtime() - startedAt),
                ),
            )

            responseAttempted = true
            respondToCall(callDetails, responseFor(decision.shouldBlock))
            CallFilterScreeningLog.event(
                operationId,
                "responded",
                mapOf(
                    "disallow" to decision.shouldBlock,
                    "duration_ms" to (SystemClock.elapsedRealtime() - startedAt),
                ),
            )
        } catch (error: Exception) {
            CallFilterScreeningLog.event(
                operationId,
                "error",
                mapOf(
                    "type" to error.javaClass.simpleName,
                    "duration_ms" to (SystemClock.elapsedRealtime() - startedAt),
                ),
            )
            if (!responseAttempted) {
                respondAllowSafely(operationId, callDetails)
            }
        }
    }

    private fun evaluateWithTimeout(
        snapshot: NativeFilterSnapshot,
        phoneNumber: String,
        displayName: String?,
    ): NativeDecision {
        val future = try {
            matcherExecutor.submit<NativeDecision> {
                NativeDecisionEngine.decide(snapshot, phoneNumber, displayName)
            }
        } catch (_: RejectedExecutionException) {
            return NativeDecision.allow(NativeDecisionReason.EvaluationError)
        }
        return try {
            future.get(DECISION_TIMEOUT_MS, TimeUnit.MILLISECONDS)
        } catch (_: TimeoutException) {
            future.cancel(true)
            NativeDecision.allow(NativeDecisionReason.EvaluationTimeout)
        } catch (_: InterruptedException) {
            Thread.currentThread().interrupt()
            future.cancel(true)
            NativeDecision.allow(NativeDecisionReason.EvaluationError)
        } catch (_: ExecutionException) {
            NativeDecision.allow(NativeDecisionReason.EvaluationError)
        }
    }

    private fun respondAllowSafely(
        operationId: String,
        callDetails: Call.Details,
    ) {
        try {
            respondToCall(callDetails, responseFor(block = false))
            CallFilterScreeningLog.event(operationId, "fallback_responded")
        } catch (error: Exception) {
            CallFilterScreeningLog.event(
                operationId,
                "fallback_failed",
                mapOf("type" to error.javaClass.simpleName),
            )
        }
    }

    private fun responseFor(block: Boolean): CallResponse {
        return CallResponse.Builder()
            .setDisallowCall(block)
            .setRejectCall(false)
            .setSkipCallLog(false)
            .setSkipNotification(block)
            .build()
    }

    private companion object {
        const val DECISION_TIMEOUT_MS = 1_500L
        val matcherExecutor = Executors.newSingleThreadExecutor { runnable ->
            Thread(runnable, "call-filter-matcher").apply { isDaemon = true }
        }
    }
}
