package com.callfilter.call_filter

import android.util.Log
import java.security.MessageDigest

/**
 * Structured, PII-free diagnostics for one screened call.
 *
 * Never pass a phone number or caller name here. Use [phoneHash] for
 * correlation and presence flags for names.
 */
object CallFilterScreeningLog {
    private const val TAG = "CallFilterScreening"

    fun event(
        operationId: String,
        event: String,
        fields: Map<String, Any?> = emptyMap(),
    ) {
        val payload = fields.entries.joinToString(separator = " ") { (key, value) ->
            "$key=${safeValue(value)}"
        }
        Log.i(TAG, "op=$operationId event=$event $payload".trim())
    }

    fun phoneHash(phoneNumber: String): String {
        val digits = NativeFilterMatcher.normalizePhone(phoneNumber)
        if (digits.isEmpty()) {
            return "none"
        }
        val digest = MessageDigest.getInstance("SHA-256")
            .digest(digits.toByteArray(Charsets.UTF_8))
        return digest.take(6).joinToString(separator = "") { byte ->
            "%02x".format(byte)
        }
    }

    private fun safeValue(value: Any?): String {
        if (value == null) {
            return "null"
        }
        return value.toString()
            .replace('\n', '_')
            .replace('\r', '_')
            .take(160)
    }
}
