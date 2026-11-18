package com.callfilter.call_filter

import android.app.Activity
import android.app.role.RoleManager
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class CallFilterChannel(
    private val activity: Activity,
    messenger: BinaryMessenger,
) : MethodChannel.MethodCallHandler {
    private val channel = MethodChannel(messenger, CHANNEL_NAME)

    fun register() {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getCapabilities" -> result.success(capabilities())
            "syncSnapshot" -> {
                val raw = call.arguments as? String
                if (raw == null) {
                    result.error("INVALID_ARGUMENT", "Snapshot must be a JSON string.", null)
                    return
                }
                result.success(CallFilterPreferences.saveRaw(activity, raw))
            }
            "openSystemSettings" -> {
                openSystemSettings()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun capabilities(): Map<String, Any?> {
        val roleHeld = isScreeningRoleHeld()
        return mapOf(
            "platform" to "Android ${Build.VERSION.RELEASE}",
            "callScreening" to if (roleHeld) "available" else "limited",
            "callerDisplayName" to "limited",
            "callDirectory" to "unavailable",
            "numberBlocking" to "limited",
            "details" to if (roleHeld) {
                "CallScreeningService is active. The caller display name is " +
                    "not guaranteed to be supplied."
            } else {
                "Grant the call screening role (Android 10+) in system " +
                    "settings. Until then CallFilter cannot screen calls."
            },
        )
    }

    private fun isScreeningRoleHeld(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            return true
        }
        val roleManager = activity.getSystemService(RoleManager::class.java)
            ?: return false
        return roleManager.isRoleHeld(RoleManager.ROLE_CALL_SCREENING)
    }

    private fun openSystemSettings() {
        val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val roleManager = activity.getSystemService(RoleManager::class.java)
            if (roleManager != null &&
                !roleManager.isRoleHeld(RoleManager.ROLE_CALL_SCREENING)
            ) {
                roleManager.createRequestRoleIntent(RoleManager.ROLE_CALL_SCREENING)
            } else {
                appDetailsIntent()
            }
        } else {
            appDetailsIntent()
        }
        activity.startActivity(intent)
    }

    private fun appDetailsIntent(): Intent {
        return Intent(
            Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
            Uri.fromParts("package", activity.packageName, null),
        )
    }

    private companion object {
        const val CHANNEL_NAME = "call_filter/platform"
    }
}
