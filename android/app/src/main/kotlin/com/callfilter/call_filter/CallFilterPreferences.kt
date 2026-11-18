package com.callfilter.call_filter

import android.content.Context
import org.json.JSONObject

data class NativeDirectoryMapping(
    val phoneNumber: String,
    val label: String,
    val shouldBlock: Boolean,
)

data class NativeFilterSnapshot(
    val schemaVersion: Int = 0,
    val filteringEnabled: Boolean = false,
    val rules: List<NativeRule> = emptyList(),
    val whitelistNumbers: Set<String> = emptySet(),
    val directoryMappings: List<NativeDirectoryMapping> = emptyList(),
)

object CallFilterPreferences {
    private const val PREFS_NAME = "call_filter_native"
    private const val KEY_SNAPSHOT = "filter_snapshot"
    const val SUPPORTED_SCHEMA_VERSION = 1

    /**
     * Validates and writes a complete snapshot with one SharedPreferences
     * commit. A partial/invalid snapshot is never installed.
     */
    fun saveRaw(context: Context, raw: String): Boolean {
        parse(raw) ?: return false
        return context.applicationContext
            .getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .edit()
            .putString(KEY_SNAPSHOT, raw)
            .commit()
    }

    fun load(context: Context): NativeFilterSnapshot {
        val raw = context.applicationContext
            .getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .getString(KEY_SNAPSHOT, null)
        // Missing or malformed data must fail open: an empty snapshot allows
        // the call rather than applying an unknown or partial rule set.
        return parse(raw) ?: NativeFilterSnapshot()
    }

    /**
     * Parses a native snapshot. Returns null for malformed, partial or newer
     * schema data. Legacy snapshots without a version are accepted as v0 so an
     * installed app does not lose its last known data before the next sync.
     */
    fun parse(raw: String?): NativeFilterSnapshot? {
        if (raw.isNullOrBlank()) {
            return null
        }
        return try {
            val root = JSONObject(raw)
            val version = root.optInt("schemaVersion", 0)
            if (version < 0 || version > SUPPORTED_SCHEMA_VERSION) {
                return null
            }
            if (!root.has("filteringEnabled") ||
                !root.has("rules") ||
                !root.has("whitelistNumbers") ||
                !root.has("directoryMappings")
            ) {
                return null
            }

            val rules = mutableListOf<NativeRule>()
            val rulesArray = root.optJSONArray("rules") ?: return null
            for (index in 0 until rulesArray.length()) {
                val item = rulesArray.optJSONObject(index) ?: continue
                val id = item.optString("id")
                val pattern = item.optString("pattern")
                if (id.isBlank() || pattern.isBlank()) {
                    continue
                }
                rules.add(
                    NativeRule(
                        id = id,
                        name = item.optString("name"),
                        pattern = pattern,
                        priority = item.optInt("priority"),
                    ),
                )
            }

            val whitelist = mutableSetOf<String>()
            val whitelistArray = root.optJSONArray("whitelistNumbers") ?: return null
            for (index in 0 until whitelistArray.length()) {
                val value = whitelistArray.optString(index)
                if (value.isNotBlank()) {
                    whitelist.add(value)
                }
            }

            val mappings = mutableListOf<NativeDirectoryMapping>()
            val mappingsArray = root.optJSONArray("directoryMappings") ?: return null
            for (index in 0 until mappingsArray.length()) {
                val item = mappingsArray.optJSONObject(index) ?: continue
                val number = item.optString("phoneNumber")
                if (number.isBlank()) {
                    continue
                }
                mappings.add(
                    NativeDirectoryMapping(
                        phoneNumber = number,
                        label = item.optString("label"),
                        shouldBlock = item.optBoolean("shouldBlock", false),
                    ),
                )
            }

            NativeFilterSnapshot(
                schemaVersion = version,
                filteringEnabled = root.optBoolean("filteringEnabled", false),
                rules = rules,
                whitelistNumbers = whitelist,
                directoryMappings = mappings,
            )
        } catch (_: Exception) {
            null
        }
    }
}
