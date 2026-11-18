package com.callfilter.call_filter

enum class NativeDecisionReason(val wireName: String) {
    FilteringDisabled("filtering_disabled"),
    Whitelisted("whitelisted"),
    CallerNameUnavailable("caller_name_unavailable"),
    MatchedRule("matched_rule"),
    NoMatchingRule("no_matching_rule"),
    EvaluationTimeout("evaluation_timeout"),
    EvaluationError("evaluation_error"),
}

data class NativeDecision(
    val shouldBlock: Boolean,
    val reason: NativeDecisionReason,
    val whitelisted: Boolean = false,
    val callerNameAvailable: Boolean = false,
    val matchedRuleId: String? = null,
) {
    companion object {
        fun allow(reason: NativeDecisionReason): NativeDecision {
            return NativeDecision(shouldBlock = false, reason = reason)
        }
    }
}

/**
 * Pure decision logic for one screened call.
 *
 * Directory mappings are intentionally not consulted here. They are prepared
 * for iOS Call Directory and are derived from the blocked-call history; using
 * that history as an Android block list would keep blocking a number after its
 * rule was deleted or disabled. Android always decides from the current
 * snapshot rules, whitelist and filtering setting.
 */
object NativeDecisionEngine {
    fun decide(
        snapshot: NativeFilterSnapshot,
        phoneNumber: String,
        displayName: String?,
    ): NativeDecision {
        if (!snapshot.filteringEnabled) {
            return NativeDecision.allow(NativeDecisionReason.FilteringDisabled)
        }

        val whitelisted = NativeFilterMatcher.isWhitelisted(
            phoneNumber,
            snapshot.whitelistNumbers,
        )
        if (whitelisted) {
            return NativeDecision(
                shouldBlock = false,
                reason = NativeDecisionReason.Whitelisted,
                whitelisted = true,
            )
        }

        if (displayName.isNullOrBlank()) {
            return NativeDecision.allow(NativeDecisionReason.CallerNameUnavailable)
        }

        val matchedRule = NativeFilterMatcher.findMatchingRule(
            displayName,
            snapshot.rules,
        ) ?: return NativeDecision(
            shouldBlock = false,
            reason = NativeDecisionReason.NoMatchingRule,
            callerNameAvailable = true,
        )

        return NativeDecision(
            shouldBlock = true,
            reason = NativeDecisionReason.MatchedRule,
            callerNameAvailable = true,
            matchedRuleId = matchedRule.id,
        )
    }
}
