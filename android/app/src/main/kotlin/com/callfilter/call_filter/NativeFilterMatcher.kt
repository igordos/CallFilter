package com.callfilter.call_filter

import java.util.regex.Pattern

data class NativeRule(
    val id: String,
    val name: String,
    val pattern: String,
    val priority: Int,
)

/**
 * Pure Kotlin matching helpers used by the Android screening service.
 *
 * This is intentionally kept free of Android dependencies so it can be covered
 * by JVM unit tests. The Java regex engine has no timeout; patterns are length
 * limited and checked for nested quantifiers before compilation, but this is a
 * mitigation rather than a formal ReDoS guarantee.
 */
object NativeFilterMatcher {
    private const val MAX_PATTERN_LENGTH = 256
    private val invisibleCharacters = Regex(
        "[${Char(0x200B)}${Char(0x200C)}${Char(0x200D)}${Char(0xFEFF)}]",
    )
    private val whitespace = Regex("\\s+")
    private val nestedQuantifier = Regex(
        "\\((?:[^()\\\\]|\\\\.)*[+*](?:[^()\\\\]|\\\\.)*\\)\\s*(?:[+*]|\\{\\d+(?:,\\d*)?\\})",
    )
    private val nonDigits = Regex("\\D")

    fun normalizeName(value: String): String {
        return value
            .replace(invisibleCharacters, "")
            .replace(Char(0x00A0), ' ')
            .replace(whitespace, " ")
            .trim()
            .lowercase()
    }

    fun normalizePhone(value: String): String = value.replace(nonDigits, "")

    fun isWhitelisted(phoneNumber: String, whitelist: Set<String>): Boolean {
        val phone = normalizePhone(phoneNumber)
        if (phone.isEmpty()) {
            return false
        }
        return whitelist.any { normalizePhone(it) == phone }
    }

    fun findMatchingRule(
        displayName: String,
        rules: List<NativeRule>,
    ): NativeRule? {
        val normalized = normalizeName(displayName)
        if (normalized.isEmpty()) {
            return null
        }
        val sorted = rules.sortedWith(
            compareByDescending<NativeRule> { it.priority }.thenBy { it.name },
        )
        for (rule in sorted) {
            if (!isPatternSafe(rule.pattern)) {
                continue
            }
            try {
                val compiled = Pattern.compile(
                    rule.pattern,
                    Pattern.CASE_INSENSITIVE or Pattern.UNICODE_CASE,
                )
                if (compiled.matcher(normalized).find()) {
                    return rule
                }
            } catch (_: IllegalArgumentException) {
                // Invalid patterns are skipped. The Flutter editor prevents
                // saving them, but synced data still crosses a process boundary.
            }
        }
        return null
    }

    fun isPatternSafe(pattern: String): Boolean {
        if (pattern.isBlank() || pattern.length > MAX_PATTERN_LENGTH) {
            return false
        }
        if (pattern.any { it.code in 0x00..0x08 || it.code in 0x0E..0x1F }) {
            return false
        }
        return !nestedQuantifier.containsMatchIn(pattern)
    }
}
