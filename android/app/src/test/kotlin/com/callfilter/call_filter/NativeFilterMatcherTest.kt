package com.callfilter.call_filter

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertSame
import org.junit.Assert.assertTrue
import org.junit.Test

class NativeFilterMatcherTest {
    @Test
    fun normalizesNameAndPhone() {
        assertEquals("ооо работа", NativeFilterMatcher.normalizeName("  ООО   РАБОТА "))
        assertEquals("77001234567", NativeFilterMatcher.normalizePhone("+7 (700) 123-45-67"))
    }

    @Test
    fun whitelistWinsByDigitsOnly() {
        val whitelist = setOf("+7 (700) 123-45-67")
        assertTrue(NativeFilterMatcher.isWhitelisted("77001234567", whitelist))
        assertFalse(NativeFilterMatcher.isWhitelisted("77009999999", whitelist))
    }

    @Test
    fun findsMatchingRuleCaseInsensitively() {
        val rule = NativeRule("1", "Работа", "ооо\\s+работа", 0)
        assertSame(
            rule,
            NativeFilterMatcher.findMatchingRule("ООО   РАБОТА", listOf(rule)),
        )
    }

    @Test
    fun respectsPriority() {
        val low = NativeRule("low", "Low", "работа", 1)
        val high = NativeRule("high", "High", "ооо\\s+работа", 10)
        val match = NativeFilterMatcher.findMatchingRule(
            "ООО Работа",
            listOf(low, high),
        )
        assertEquals("high", match?.id)
    }

    @Test
    fun skipsInvalidAndUnsafePatterns() {
        val invalid = NativeRule("invalid", "Invalid", "(", 0)
        val unsafe = NativeRule("unsafe", "Unsafe", "(a+)+$", 0)
        val valid = NativeRule("valid", "Valid", "работа", 0)
        val match = NativeFilterMatcher.findMatchingRule(
            "ООО Работа",
            listOf(invalid, unsafe, valid),
        )
        assertEquals("valid", match?.id)
    }

    @Test
    fun matchesShortOrganizationPatternAgainstCallerName() {
        val rule = NativeRule("o", "ООО", "ооо", 0)
        assertSame(
            rule,
            NativeFilterMatcher.findMatchingRule("ООО Работа", listOf(rule)),
        )
    }

    @Test
    fun doesNotMatchAnEmptyName() {
        val rule = NativeRule("1", "Работа", ".*", 0)
        assertNull(NativeFilterMatcher.findMatchingRule("   ", listOf(rule)))
    }
}
