package com.callfilter.call_filter

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

class NativeDecisionEngineTest {
    private val rule = NativeRule("rule-1", "Работа", "ооо\\s+работа", 0)

    @Test
    fun whitelistWinsOverMatchingRule() {
        val decision = NativeDecisionEngine.decide(
            snapshot = snapshot(
                rules = listOf(rule),
                whitelist = setOf("+7 (700) 123-45-67"),
            ),
            phoneNumber = "77001234567",
            displayName = "ООО Работа",
        )

        assertFalse(decision.shouldBlock)
        assertEquals(NativeDecisionReason.Whitelisted, decision.reason)
        assertTrue(decision.whitelisted)
    }

    @Test
    fun blocksMatchingName() {
        val decision = NativeDecisionEngine.decide(
            snapshot = snapshot(rules = listOf(rule)),
            phoneNumber = "77001234567",
            displayName = "ООО Работа",
        )

        assertTrue(decision.shouldBlock)
        assertEquals(NativeDecisionReason.MatchedRule, decision.reason)
        assertEquals("rule-1", decision.matchedRuleId)
        assertTrue(decision.callerNameAvailable)
    }

    @Test
    fun missingNameFailsOpen() {
        val decision = NativeDecisionEngine.decide(
            snapshot = snapshot(rules = listOf(rule)),
            phoneNumber = "77001234567",
            displayName = null,
        )

        assertFalse(decision.shouldBlock)
        assertEquals(NativeDecisionReason.CallerNameUnavailable, decision.reason)
        assertNull(decision.matchedRuleId)
    }

    @Test
    fun disabledFilteringFailsOpen() {
        val decision = NativeDecisionEngine.decide(
            snapshot = snapshot(
                filteringEnabled = false,
                rules = listOf(rule),
            ),
            phoneNumber = "77001234567",
            displayName = "ООО Работа",
        )

        assertFalse(decision.shouldBlock)
        assertEquals(NativeDecisionReason.FilteringDisabled, decision.reason)
    }

    @Test
    fun historyDirectoryMappingCannotKeepBlockingAfterRuleRemoval() {
        val decision = NativeDecisionEngine.decide(
            snapshot = snapshot(
                rules = emptyList(),
                directoryMappings = listOf(
                    NativeDirectoryMapping(
                        phoneNumber = "77001234567",
                        label = "Old blocked call",
                        shouldBlock = true,
                    ),
                ),
            ),
            phoneNumber = "77001234567",
            displayName = "Acme Support",
        )

        assertFalse(decision.shouldBlock)
        assertEquals(NativeDecisionReason.NoMatchingRule, decision.reason)
    }

    @Test
    fun noMatchFailsOpen() {
        val decision = NativeDecisionEngine.decide(
            snapshot = snapshot(rules = listOf(rule)),
            phoneNumber = "+7 700 999-99-99",
            displayName = "ООО Ромашка",
        )

        assertFalse(decision.shouldBlock)
        assertEquals(NativeDecisionReason.NoMatchingRule, decision.reason)
    }

    private fun snapshot(
        filteringEnabled: Boolean = true,
        rules: List<NativeRule> = emptyList(),
        whitelist: Set<String> = emptySet(),
        directoryMappings: List<NativeDirectoryMapping> = emptyList(),
    ): NativeFilterSnapshot {
        return NativeFilterSnapshot(
            schemaVersion = 1,
            filteringEnabled = filteringEnabled,
            rules = rules,
            whitelistNumbers = whitelist,
            directoryMappings = directoryMappings,
        )
    }
}
