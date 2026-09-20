package com.omni.search

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import rikka.shizuku.Shizuku
import java.io.BufferedReader
import java.io.InputStreamReader

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.omni.search/shizuku"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkShizukuPermission" -> {
                    if (Shizuku.isPreV11()) {
                        result.success(false)
                    } else {
                        try {
                            val isGranted = Shizuku.checkSelfPermission() == android.content.pm.PackageManager.PERMISSION_GRANTED
                            if (!isGranted) {
                                Shizuku.requestPermission(1001)
                            }
                            result.success(isGranted)
                        } catch (e: Exception) {
                            result.success(false)
                        }
                    }
                }
                "executeCommand" -> {
                    val command = call.argument<String>("command")
                    if (command != null) {
                        val output = executeShizukuShell(command)
                        result.success(output)
                    } else {
                        result.error("INVALID_CMD", "Command was null", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun executeShizukuShell(command: String): String {
        return try {
            val process = Shizuku.newProcess(arrayOf("sh", "-c", command), null, null)
            val reader = BufferedReader(InputStreamReader(process.inputStream))
            val output = StringBuilder()
            var line: String?

            while (reader.readLine().also { line = it } != null) {
                output.append(line).append("\n")
            }
            process.waitFor()
            output.toString()
        } catch (e: Exception) {
            "Error: ${e.message}"
        }
    }
}