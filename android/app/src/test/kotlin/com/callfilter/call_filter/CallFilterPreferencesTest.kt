package com.callfilter.call_filter

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

class CallFilterPreferencesTest {
    @Test
    fun parsesVersionedSnapshot() {
        val snapshot = CallFilterPreferences.parse(
            """
            {
              "schemaVersion": 1,
              "filteringEnabled": true,
              "rules": [
                {"id": "r1", "name": "Работа", "pattern": "работа", "priority": 5}
              ],
              "whitelistNumbers": ["77001234567"],
              "directoryMappings": [],
              "generatedAt": "2026-01-01T00:00:00.000Z"
            }
            """.trimIndent(),
        )

        assertNotNull(snapshot)
        assertEquals(1, snapshot?.schemaVersion)
        assertTrue(snapshot?.filteringEnabled == true)
        assertEquals(1, snapshot?.rules?.size)
        assertEquals("77001234567", snapshot?.whitelistNumbers?.single())
    }

    @Test
    fun acceptsLegacySnapshotWithoutVersion() {
        val snapshot = CallFilterPreferences.parse(
            """
            {
              "filteringEnabled": true,
              "rules": [],
              "whitelistNumbers": [],
              "directoryMappings": []
            }
            """.trimIndent(),
        )

        assertNotNull(snapshot)
        assertEquals(0, snapshot?.schemaVersion)
    }

    @Test
    fun rejectsMalformedOrPartialSnapshot() {
        assertNull(CallFilterPreferences.parse("not json"))
        assertNull(CallFilterPreferences.parse("""{"filteringEnabled":true}"""))
        assertNull(
            CallFilterPreferences.parse(
                """{"schemaVersion":2,"filteringEnabled":true,"rules":[],"whitelistNumbers":[],"directoryMappings":[]}""",
            ),
        )
    }

    @Test
    fun invalidSnapshotLoadsFailOpenDefault() {
        val snapshot = CallFilterPreferences.parse("broken")

        assertNull(snapshot)
        val fallback = NativeFilterSnapshot()
        assertFalse(fallback.filteringEnabled)
        assertTrue(fallback.rules.isEmpty())
        assertTrue(fallback.whitelistNumbers.isEmpty())
    }
}
