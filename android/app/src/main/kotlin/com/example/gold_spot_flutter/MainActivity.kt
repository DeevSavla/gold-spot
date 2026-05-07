package com.example.gold_spot_flutter

import android.bluetooth.BluetoothAdapter
import android.content.Context
import android.location.LocationManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val channel = "flutter.native/helper"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isBluetoothEnabled" -> result.success(isBluetoothEnabled())
                    "isLocationEnabled" -> result.success(isLocationEnabled())
                    else -> result.notImplemented()
                }
            }
    }

    private fun isBluetoothEnabled(): Boolean {
        return try {
            BluetoothAdapter.getDefaultAdapter()?.isEnabled ?: false
        } catch (_: Exception) {
            false
        }
    }

    private fun isLocationEnabled(): Boolean {
        return try {
            val locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager
            locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER) ||
                locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
        } catch (_: Exception) {
            false
        }
    }
}
