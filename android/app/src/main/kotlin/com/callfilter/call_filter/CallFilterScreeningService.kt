package com.callfilter.call_filter

import android.telecom.Call
import android.telecom.CallScreeningService
import android.util.Log

/**
 * Android call screening entry point.
 *
 * This service only sees a caller if the user has granted the call screening
 * role. Android does not guarantee that a display name is present, so a
 * missing name always results in an allowed call. The behavior must be
 * validated on a physical device; it is not covered by JVM tests.
 */
class CallFilterScreeningService : CallScreeningService() {
    override fun onScreenCall(callDetails: Call.Details) {
        val snapshot = CallFilterPreferences.load(this)
        val phoneNumber = callDetails.handle?.schemeSpecificPart.orEmpty()
        val normalizedPhone = NativeFilterMatcher.normalizePhone(phoneNumber)
        val whitelisted = NativeFilterMatcher.isWhitelisted(
            phoneNumber,
            snapshot.whitelistNumbers,
        )

        var shouldBlock = false
        var matchedRuleName: String? = null
        val displayName = callDetails.callerDisplayName
        if (snapshot.filteringEnabled && !whitelisted) {
            val knownBlockedNumber = snapshot.directoryMappings.any { mapping ->
                mapping.shouldBlock &&
                    NativeFilterMatcher.normalizePhone(mapping.phoneNumber) ==
                    normalizedPhone
            }
            val matchedRule = if (displayName.isNullOrBlank()) {
                null
            } else {
                NativeFilterMatcher.findMatchingRule(displayName, snapshot.rules)
            }
            matchedRuleName = matchedRule?.name
            shouldBlock = knownBlockedNumber || matchedRule != null
        }
        if (BuildConfig.DEBUG) {
            Log.d(
                "CallFilterScreening",
                "filtering=${snapshot.filteringEnabled} " +
                    "name='${displayName.orEmpty().take(64)}' " +
                    "whitelisted=$whitelisted matchedRule=$matchedRuleName " +
                    "shouldBlock=$shouldBlock",
            )
        }

        respondToCall(
            callDetails,
            CallResponse.Builder()
                .setDisallowCall(shouldBlock)
                .setRejectCall(false)
                .setSkipCallLog(false)
                .setSkipNotification(shouldBlock)
                .build(),
        )
    }
}
