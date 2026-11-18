package com.callfilter.call_filter

import android.content.Context
import org.json.JSONObject

data class NativeDirectoryMapping(
    val phoneNumber: String,
    val label: String,
    val shouldBlock: Boolean,
)

data class NativeFilterSnapshot(
    val filteringEnabled: Boolean = true,
    val rules: List<NativeRule> = emptyList(),
    val whitelistNumbers: Set<String> = emptySet(),
    val directoryMappings: List<NativeDirectoryMapping> = emptyList(),
)

object CallFilterPreferences {
    private const val PREFS_NAME = "call_filter_native"
    private const val KEY_SNAPSHOT = "filter_snapshot"

    fun saveRaw(context: Context, raw: String): Boolean {
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
        return parse(raw)
    }

    fun parse(raw: String?): NativeFilterSnapshot {
        if (raw.isNullOrBlank()) {
            return NativeFilterSnapshot()
        }
        return try {
            val root = JSONObject(raw)
            val rules = mutableListOf<NativeRule>()
            root.optJSONArray("rules")?.let { array ->
                for (index in 0 until array.length()) {
                    val item = array.optJSONObject(index) ?: continue
                    rules.add(
                        NativeRule(
                            id = item.optString("id"),
                            name = item.optString("name"),
                            pattern = item.optString("pattern"),
                            priority = item.optInt("priority"),
                        ),
                    )
                }
            }

            val whitelist = mutableSetOf<String>()
            root.optJSONArray("whitelistNumbers")?.let { array ->
                for (index in 0 until array.length()) {
                    val value = array.optString(index)
                    if (value.isNotBlank()) {
                        whitelist.add(value)
                    }
                }
            }

            val mappings = mutableListOf<NativeDirectoryMapping>()
            root.optJSONArray("directoryMappings")?.let { array ->
                for (index in 0 until array.length()) {
                    val item = array.optJSONObject(index) ?: continue
                    mappings.add(
                        NativeDirectoryMapping(
                            phoneNumber = item.optString("phoneNumber"),
                            label = item.optString("label"),
                            shouldBlock = item.optBoolean("shouldBlock", false),
                        ),
                    )
                }
            }

            NativeFilterSnapshot(
                filteringEnabled = root.optBoolean("filteringEnabled", true),
                rules = rules,
                whitelistNumbers = whitelist,
                directoryMappings = mappings,
            )
        } catch (_: Exception) {
            NativeFilterSnapshot()
        }
    }
}
