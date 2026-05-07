# Fat Percentage Machine (Body Composition Device) Integration Guide

## Complete Technical Integration Steps for Another Flutter App

This guide provides step-by-step instructions to integrate the ICDeviceManager Flutter plugin (fat percentage/body composition machine) into another Flutter application. The plugin folder has already been copied to your new app's directory.

---

## 📋 Prerequisites

- Flutter SDK installed (>=3.0.0)
- Android Studio or Xcode for native platform development
- The `plugins/icdevicemanager_flutter` folder already copied to your new app's root directory
- Basic knowledge of Flutter, Android (Kotlin/Java), and iOS (Swift/Objective-C)

---

## 🔧 PART 1: PUBSPEC.YAML CONFIGURATION

### Step 1.1: Add Plugin Dependency

Open your app's `pubspec.yaml` file and add the following under the `dependencies:` section:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Add the ICDeviceManager plugin
  icdevicemanager_flutter:
    path: plugins/icdevicemanager_flutter
  
  # Required supporting dependencies
  permission_handler: ^12.0.1
  shared_preferences: ^2.2.2
  provider: ^6.1.1  # Optional: for state management
```

### Step 1.2: Run Flutter Pub Get

```bash
flutter pub get
```

---

## 🤖 PART 2: ANDROID CONFIGURATION

### Step 2.1: Update Main App's `build.gradle.kts` (Project Level)

File: `android/build.gradle.kts`

Ensure you have:

```kotlin
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
```

### Step 2.2: Update App-Level `build.gradle.kts`

File: `android/app/build.gradle.kts`

Set minimum SDK and compile SDK versions:

```kotlin
android {
    namespace = "com.yourcompany.yourapp"  // Your app's package name
    compileSdk = 36  // or at least 31+
    
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }
    
    defaultConfig {
        applicationId = "com.yourcompany.yourapp"
        minSdk = 23  // IMPORTANT: Minimum SDK 21 for plugin, 23 recommended
        targetSdk = 36
        versionCode = 1
        versionName = "1.0.0"
    }
}
```

### Step 2.3: Add Bluetooth & Location Permissions

File: `android/app/src/main/AndroidManifest.xml`

Add these permissions inside the `<manifest>` tag (before `<application>`):

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.yourcompany.yourapp">

    <!-- Bluetooth permissions for BLE device connection -->
    <uses-permission android:name="android.permission.BLUETOOTH" />
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
    <uses-permission android:name="android.permission.BLUETOOTH_SCAN" 
                     android:usesPermissionFlags="neverForLocation" />
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
    
    <!-- Location permissions (required for BLE scanning on Android) -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    
    <!-- Internet for any cloud features -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

    <application
        android:label="Your App Name"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        
        <!-- Your activities and other components -->
        
    </application>
</manifest>
```

### Step 2.4: Create MainActivity with Method Channels

File: `android/app/src/main/kotlin/com/yourcompany/yourapp/MainActivity.kt`

**IMPORTANT:** Replace `com.yourcompany.yourapp` with your actual package name.

```kotlin
package com.yourcompany.yourapp

import android.content.Context
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "flutter.native/helper"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isBluetoothEnabled" -> {
                        try {
                            val isEnabled = isBluetoothEnabled()
                            result.success(isEnabled)
                        } catch (e: Exception) {
                            result.error("UNAVAILABLE", "Failed to check Bluetooth", null)
                        }
                    }
                    "isLocationEnabled" -> {
                        try {
                            val isEnabled = isLocationEnabled()
                            result.success(isEnabled)
                        } catch (e: Exception) {
                            result.error("UNAVAILABLE", "Failed to check Location", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun isBluetoothEnabled(): Boolean {
        return try {
            val bluetoothAdapter = android.bluetooth.BluetoothAdapter.getDefaultAdapter()
            bluetoothAdapter?.isEnabled ?: false
        } catch (e: Exception) {
            false
        }
    }

    private fun isLocationEnabled(): Boolean {
        return try {
            val locationManager = getSystemService(Context.LOCATION_SERVICE) 
                as android.location.LocationManager
            val isGpsEnabled = locationManager.isProviderEnabled(
                android.location.LocationManager.GPS_PROVIDER
            )
            val isNetworkEnabled = locationManager.isProviderEnabled(
                android.location.LocationManager.NETWORK_PROVIDER
            )
            isGpsEnabled || isNetworkEnabled
        } catch (e: Exception) {
            false
        }
    }
}
```

### Step 2.5: Verify Plugin's Android Configuration

The plugin already has these files configured:
- `plugins/icdevicemanager_flutter/android/build.gradle` - Contains plugin dependencies
- `plugins/icdevicemanager_flutter/android/libs/` - Contains required JAR files:
  - `ICBleProtocol.jar`
  - `ICBodyFatAlgorithms.jar`
  - `icdevicemanager.jar`
  - `ICLogger.jar`

**No changes needed** in the plugin folder if you copied it as-is.

---

## 🍎 PART 3: iOS CONFIGURATION

### Step 3.1: Update Podfile

File: `ios/Podfile`

Ensure minimum iOS version is set:

```ruby
# Uncomment this line to define a global platform for your project
platform :ios, '14.0'  # Minimum iOS 9.0 for plugin, 14.0 recommended

# ... rest of your Podfile
target 'Runner' do
  use_frameworks!
  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
  end
end
```

### Step 3.2: Add Bluetooth Permissions to Info.plist

File: `ios/Runner/Info.plist`

Add these keys inside the `<dict>` tag:

```xml
<dict>
    <!-- Existing keys... -->
    
    <!-- Bluetooth permissions for body composition device -->
    <key>NSBluetoothAlwaysUsageDescription</key>
    <string>This app uses Bluetooth to connect to body composition devices for health monitoring and fitness tracking.</string>
    
    <key>NSBluetoothPeripheralUsageDescription</key>
    <string>This app uses Bluetooth to connect to body composition devices for health monitoring and fitness tracking.</string>
    
    <!-- Optional: Location permission (if needed for BLE) -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>This app uses location services to provide more accurate device connectivity.</string>
    
</dict>
```

### Step 3.3: Install iOS Dependencies

```bash
cd ios
pod install
cd ..
```

### Step 3.4: Verify Plugin's iOS Configuration

The plugin already has these configured:
- `plugins/icdevicemanager_flutter/ios/icdevicemanager_flutter.podspec` - CocoaPods spec
- `plugins/icdevicemanager_flutter/ios/Classes/` - Native iOS implementation files
- `plugins/icdevicemanager_flutter/ios/Assets/` - Placeholder for native frameworks

**Note:** The plugin currently uses stub implementations for iOS. If you need the actual ICDeviceManager framework, you'll need to obtain it from the device manufacturer and place it in `plugins/icdevicemanager_flutter/ios/Assets/`.

---

## 📱 PART 4: FLUTTER/DART IMPLEMENTATION

### Step 4.1: Import the Plugin

In your Dart files where you want to use the body composition features:

```dart
import 'package:icdevicemanager_flutter/icdevicemanager_flutter.dart';
import 'package:icdevicemanager_flutter/ic_bluetooth_sdk.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
```

### Step 4.2: Create a Body Composition Screen/Widget

Here's a complete example implementation:

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icdevicemanager_flutter/icdevicemanager_flutter.dart';
import 'package:icdevicemanager_flutter/ic_bluetooth_sdk.dart';
import 'package:permission_handler/permission_handler.dart';

class BodyCompositionScreen extends StatefulWidget {
  const BodyCompositionScreen({Key? key}) : super(key: key);

  @override
  State<BodyCompositionScreen> createState() => _BodyCompositionScreenState();
}

class _BodyCompositionScreenState extends State<BodyCompositionScreen>
    implements ICDeviceManagerDelegate, ICScanDeviceDelegate {
  
  List<ICDevice> devices = [];
  bool isScanning = false;
  bool isConnected = false;
  ICWeightData? lastData;
  
  // User profile for accurate calculations
  ICUserInfo? userInfo;
  
  @override
  void initState() {
    super.initState();
    _checkServicesAndInitialize();
  }

  // STEP 1: Check Bluetooth and Location services
  Future<void> _checkServicesAndInitialize() async {
    bool bluetoothEnabled = await _isBluetoothEnabled();
    bool locationEnabled = await _isLocationEnabled();
    
    if (!bluetoothEnabled || !locationEnabled) {
      _showServicesDialog(bluetoothEnabled, locationEnabled);
    } else {
      await _requestPermissions();
      _initializeSDK();
    }
  }

  // STEP 2: Check Bluetooth status via platform channel
  Future<bool> _isBluetoothEnabled() async {
    try {
      const platform = MethodChannel('flutter.native/helper');
      final result = await platform.invokeMethod('isBluetoothEnabled');
      return result as bool;
    } catch (e) {
      print('Error checking Bluetooth: $e');
      return false;
    }
  }

  // STEP 3: Check Location status via platform channel
  Future<bool> _isLocationEnabled() async {
    try {
      const platform = MethodChannel('flutter.native/helper');
      final result = await platform.invokeMethod('isLocationEnabled');
      return result as bool;
    } catch (e) {
      print('Error checking Location: $e');
      return false;
    }
  }

  // STEP 4: Request runtime permissions
  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
      Permission.locationWhenInUse,
    ].request();
    
    print('Permissions status: $statuses');
  }

  // STEP 5: Initialize the ICDeviceManager SDK
  void _initializeSDK() {
    try {
      final config = ICDeviceManagerConfig();
      ICBluetoothSDK.shared().initMgr(config);
      ICBluetoothSDK.shared().delegate = this;
      print('SDK initialized successfully');
    } catch (e) {
      print('Error initializing SDK: $e');
    }
  }

  // STEP 6: Start scanning for devices
  void _startScanning() {
    try {
      setState(() {
        isScanning = true;
        devices.clear();
      });
      
      ICBluetoothSDK.shared().scanDeviceDelegate = this;
      ICBluetoothSDK.shared().scanDevice();
      
      // Auto-stop scanning after 30 seconds
      Timer(Duration(seconds: 30), () {
        if (isScanning) _stopScanning();
      });
    } catch (e) {
      print('Error starting scan: $e');
      setState(() => isScanning = false);
    }
  }

  // STEP 7: Stop scanning
  void _stopScanning() {
    try {
      ICBluetoothSDK.shared().scanDeviceDelegate = null;
      setState(() => isScanning = false);
      print('Scanning stopped');
    } catch (e) {
      print('Error stopping scan: $e');
    }
  }

  // STEP 8: Connect to a device
  Future<void> _connectToDevice(ICDevice device) async {
    try {
      _stopScanning();
      
      // Create user profile for accurate body composition
      userInfo = ICUserInfo()
        ..userHeight = 175 // cm
        ..userWeight = 70  // kg
        ..userAge = 25
        ..userSex = ICSexType.ICSexTypeMale;
      
      bool success = await ICBluetoothSDK.shared().addDevice(
        device,
        userInfo!,
        ICAddDeviceCallBack(
          onInitUserInfo: (ICUserInfo user, ICDeviceInfo deviceInfo) {
            print('User info initialized');
          },
          onAddDeviceResult: (ICDevice device, ICAddDeviceCallBackCode code) {
            if (code == ICAddDeviceCallBackCode.ICAddDeviceCallBackCodeSuccess) {
              setState(() => isConnected = true);
              print('Device connected successfully');
            } else {
              print('Failed to add device: $code');
            }
          },
        ),
      );
    } catch (e) {
      print('Error connecting to device: $e');
    }
  }

  // STEP 9: Disconnect from device
  void _disconnectDevice() {
    try {
      // Implement disconnect logic
      setState(() => isConnected = false);
    } catch (e) {
      print('Error disconnecting: $e');
    }
  }

  // Show dialog when services are disabled
  void _showServicesDialog(bool bluetoothEnabled, bool locationEnabled) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Services Required'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Please enable:'),
            if (!bluetoothEnabled) Text('• Bluetooth'),
            if (!locationEnabled) Text('• Location Services'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _checkServicesAndInitialize();
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  // ========== ICDeviceManagerDelegate Methods ==========
  
  @override
  void onInitCompleted(bool bSuccess) {
    print('SDK initialization completed: $bSuccess');
  }

  @override
  void onBleState(ICBleState state) {
    print('BLE state changed: $state');
  }

  @override
  void onDeviceConnectionChanged(ICDevice device, ICDeviceConnectState state) {
    print('Device connection changed: $state');
    if (state == ICDeviceConnectState.ICDeviceConnectStateConnected) {
      setState(() => isConnected = true);
    } else {
      setState(() => isConnected = false);
    }
  }

  @override
  void onReceiveWeightData(ICDevice device, ICWeightData data) {
    print('Received weight data: ${data.weight_kg}kg');
    setState(() {
      lastData = data;
    });
  }

  // ========== ICScanDeviceDelegate Methods ==========
  
  @override
  void onScanResult(ICScanDeviceInfo deviceInfo) {
    print('Device found: ${deviceInfo.deviceName}');
    
    ICDevice device = ICDevice()
      ..macAddr = deviceInfo.macAddr
      ..deviceName = deviceInfo.deviceName;
    
    setState(() {
      // Add device if not already in list
      if (!devices.any((d) => d.macAddr == device.macAddr)) {
        devices.add(device);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Body Composition'),
        actions: [
          if (isConnected)
            IconButton(
              icon: Icon(Icons.bluetooth_disabled),
              onPressed: _disconnectDevice,
              tooltip: 'Disconnect',
            ),
        ],
      ),
      body: Column(
        children: [
          // Device List
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return ListTile(
                  leading: Icon(Icons.bluetooth),
                  title: Text(device.deviceName ?? 'Unknown'),
                  subtitle: Text(device.macAddr ?? ''),
                  onTap: () => _connectToDevice(device),
                );
              },
            ),
          ),
          
          // Scan Button
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: isScanning ? _stopScanning : _startScanning,
              icon: Icon(isScanning ? Icons.stop : Icons.search),
              label: Text(isScanning ? 'Stop Scanning' : 'Scan for Devices'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ),
          
          // Display weight data
          if (lastData != null)
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Weight: ${lastData!.weight_kg} kg'),
                  Text('BMI: ${lastData!.bmi}'),
                  Text('Body Fat: ${lastData!.bodyFatPercent}%'),
                  // Add more data fields as needed
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _stopScanning();
    super.dispose();
  }
}
```

### Step 4.3: Add Screen to Your App Navigation

In your main app file (`main.dart` or wherever you define routes):

```dart
import 'package:your_app/screens/body_composition_screen.dart';

// In your routes or navigation:
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => BodyCompositionScreen()),
);
```

---

## 🔄 PART 5: TESTING AND VERIFICATION

### Step 5.1: Clean and Rebuild

```bash
# Clean the project
flutter clean

# Get dependencies
flutter pub get

# For Android
cd android
./gradlew clean
cd ..

# For iOS
cd ios
pod deintegrate
pod install
cd ..

# Build the app
flutter build apk  # For Android
flutter build ios  # For iOS (on macOS)
```

### Step 5.2: Test Checklist

✅ **Permissions:**
- [ ] Bluetooth permission requested and granted
- [ ] Location permission requested and granted
- [ ] Native method channels working (Bluetooth/Location status checks)

✅ **Device Scanning:**
- [ ] Can start scanning for devices
- [ ] Devices appear in the list
- [ ] Can stop scanning

✅ **Device Connection:**
- [ ] Can connect to a device
- [ ] Connection status updates correctly
- [ ] Can disconnect from device

✅ **Data Reception:**
- [ ] Receives weight data from device
- [ ] Body composition data calculated correctly
- [ ] UI updates with new data

---

## 🐛 PART 6: TROUBLESHOOTING

### Issue 1: "Plugin not found" error
**Solution:** Ensure the plugin path in `pubspec.yaml` is correct:
```yaml
icdevicemanager_flutter:
  path: plugins/icdevicemanager_flutter  # Must match actual folder location
```

### Issue 2: Android build fails with "Unresolved reference"
**Solution:** 
- Check `android/app/build.gradle.kts` has `minSdk = 23`
- Verify `MainActivity.kt` package name matches your app's package
- Run `flutter clean` and rebuild

### Issue 3: iOS build fails
**Solution:**
- Run `pod install` in the `ios` directory
- Check iOS deployment target is at least 9.0 (14.0 recommended)
- Ensure Info.plist has Bluetooth permission keys

### Issue 4: Devices not found during scanning
**Solution:**
- Verify Bluetooth is enabled on the device
- Check Location services are enabled (required on Android for BLE)
- Ensure all runtime permissions are granted
- Make sure the body composition device is powered on and in pairing mode

### Issue 5: MethodChannel not working
**Solution:**
- Verify channel name matches exactly: `"flutter.native/helper"`
- Ensure MainActivity properly overrides `configureFlutterEngine`
- Check for typos in method names

### Issue 6: "MissingPluginException" at runtime
**Solution:**
- Hot restart the app (don't use hot reload)
- Completely rebuild: `flutter clean && flutter pub get && flutter run`

---

## 📝 PART 7: IMPORTANT NOTES

### Android Specific Notes:
1. **BLE requires Location:** Android requires location permission and enabled location services for BLE scanning (even though location isn't actually used)
2. **Runtime Permissions:** Request permissions at runtime, not just in manifest
3. **JAR Files:** The plugin includes native Android JAR libraries in `plugins/icdevicemanager_flutter/android/libs/`:
   - ICBleProtocol.jar (Bluetooth protocol)
   - ICBodyFatAlgorithms.jar (Body fat calculation algorithms)
   - icdevicemanager.jar (Main device manager)
   - ICLogger.jar (Logging utilities)

### iOS Specific Notes:
1. **Framework Required:** The plugin currently uses stub implementations. For production, you need the actual `ICDeviceManager.framework` from the device manufacturer
2. **Background Modes:** Add background modes in Info.plist if you need background BLE connectivity
3. **Simulator Limitations:** BLE functionality won't work on iOS Simulator, test on real devices

### User Profile Importance:
Body composition calculations (body fat %, muscle mass, etc.) require accurate user profile data:
- **Height** (in cm or inches)
- **Weight** (current weight)
- **Age**
- **Sex** (Male/Female)

Without this data, the device can only provide raw weight measurements.

---

## 📦 PART 8: COMPLETE FILE CHECKLIST

Ensure you have all these files configured:

**Root Level:**
- [ ] `pubspec.yaml` - Plugin dependency added
- [ ] `plugins/icdevicemanager_flutter/` - Plugin folder copied

**Android:**
- [ ] `android/build.gradle.kts` - Repositories configured
- [ ] `android/app/build.gradle.kts` - Min SDK, dependencies
- [ ] `android/app/src/main/AndroidManifest.xml` - Permissions added
- [ ] `android/app/src/main/kotlin/[package]/MainActivity.kt` - Method channels

**iOS:**
- [ ] `ios/Podfile` - Minimum iOS version set
- [ ] `ios/Runner/Info.plist` - Bluetooth permissions added
- [ ] Run `pod install` completed

**Flutter:**
- [ ] Screen/widget implementing ICDeviceManagerDelegate
- [ ] Screen/widget implementing ICScanDeviceDelegate
- [ ] Permission request logic
- [ ] Service check logic (Bluetooth/Location)

---

## 🎯 QUICK START COMMAND SEQUENCE

Once all files are configured, run these commands in order:

```bash
# 1. Get Flutter dependencies
flutter pub get

# 2. Clean project
flutter clean

# 3. For Android: Clean Gradle cache
cd android
./gradlew clean
cd ..

# 4. For iOS: Install pods (macOS only)
cd ios
pod deintegrate
pod install
cd ..

# 5. Run the app
flutter run

# OR build for specific platform
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

---

## 📞 SUPPORT

If you encounter issues:
1. Check the plugin's original documentation: `plugins/icdevicemanager_flutter/INTEGRATION_GUIDE.md`
2. Verify all file paths and package names are correct
3. Ensure native dependencies (JARs, frameworks) are in place
4. Test on real devices (not simulators) for Bluetooth functionality

---

## ✅ INTEGRATION COMPLETE

After following all these steps, you should have:
- ✅ Plugin integrated into your app
- ✅ Android permissions and native code configured
- ✅ iOS permissions and pod dependencies set up
- ✅ Flutter UI for scanning and connecting to devices
- ✅ Data reception and display working

Your app can now connect to body composition devices and receive weight and body fat data!

---

**Version:** 1.0  
**Last Updated:** January 2026  
**Plugin Version:** icdevicemanager_flutter 0.0.1