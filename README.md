# Reading NFC tags for React Native (Android and iOS)

This project has the goal of making it easy (or easier) to scan NFC tags and read the NDEF records they contain. This is forked from the project [react-native-rfid-nfc](https://github.com/SMARTRACTECHNOLOGY/react-native-rfid-nfc) by [SMARTRACTECHNOLOGY](https://github.com/SMARTRACTECHNOLOGY).

To read the NDEF data it makes use of the library **[ndef-tools-for-android](https://github.com/skjolber/ndef-tools-for-android)**.

## Requirements
This library is compatible and was tested with React Native projects with version >= 0.40.0


## Installation

Install the plugin via NPM:
```
$ npm install react-native-rfid-nfc-scanner --save

```

and then link it:

```
$ react-native link react-native-rfid-nfc-scanner
```

## iOS Configuration

### info.plist
add the following to info.plist
```xml
<key>NFCReaderUsageDescription</key>
<string>NFC NDEF Reading.</string>
```

### YourAppName.entitlements
The following entry should be created automatically in your `YourAppName.entitlements` file once you enable NFC capability
in your app but if not add the following to `YourAppName.entitlements`
```xml
<dict>
    <key>com.apple.developer.nfc.readersession.formats</key>
    <array>
        <string>NDEF</string>
    </array>
</dict>
```

#### Note: If you are having issues getting this to run and you don't have any swift files in your project, just create a new one as simple as this to get the application building with the swift packages (weird bug found while developing)

```swift
//
//  SwiftFile.swift
//  MyAppName
//
//  Created by User on Date.
//  Copyright © 2018 Facebook. All rights reserved.

import Foundation

```

## Android Configuration

Take a moment to read [this Android documentation](https://developer.android.com/guide/topics/connectivity/nfc/nfc.html) about NFC Basics, especially
the *[How NFC Tags are Dispatched to Applications](https://developer.android.com/guide/topics/connectivity/nfc/nfc.html#dispatching)* section.

The NFC scanner runs in the foreground for in app scanning.

### Edit the file AndroidManifest.xml

Add the permission to read NFC data:

```xml
<uses-permission android:name="android.permission.NFC" />
```

Add the following attribute to your `<activity>` section to ensure that all NFC intents are delivered to the same activity.

```
android:launchMode="singleTask"
```

### Example AndroidManifest.xml For Foreground Scanning (In App Scanning)
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
          package="com.reactnativenfcdemo"
          android:versionCode="1"
          android:versionName="1.0">
    <uses-permission android:name="android.permission.NFC" />
    <uses-sdk
            android:minSdkVersion="16"
            android:targetSdkVersion="22" />
    <application
            android:name=".MainApplication"
            android:allowBackup="true"
            android:label="@string/app_name"
            android:icon="@mipmap/ic_launcher"
            android:theme="@style/AppTheme">
        <activity
                android:name=".MainActivity"
                android:screenOrientation="portrait"
                android:label="@string/app_name"
                android:launchMode="singleTask"
                android:configChanges="keyboard|keyboardHidden|orientation|screenSize"
                android:windowSoftInputMode="adjustResize">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
            <meta-data android:name="android.nfc.action.TECH_DISCOVERED" android:resource="@xml/nfc_tech_filter" />
        </activity>
    </application>
</manifest>
```

## Usage

There are 2 ways to use this component. You can use the controller or the underlying scanner object.

### The NdefRfidScanner class ###

To use the NfcRfidScanner class import and create one:

```javascript
import {NfcRfidScanner} from "react-native-rfid-nfc-scanner";

const scanner = new NfcRfidScanner();

scanner.addListener(
    name:String, listenerCallback:Function, errorCallback:Function)
```

This will register a method and error handler to run when an RFID card is scanned

### Scanner API (Using scanner created above) ###

```javascript
scanner.init()
```

- starts the scanner

```javascript
scanner.isEnabled()
```

- tells you if the device can use an RFID scanner

```javascript
scanner.getStatus()
```

- tells you loading status of the device RFID scanner

```javascript
scanner.clearListeners()
```


### Accessing original NFC Object (Expanded and unified for use with Android and iOS) ###

The underlying object this was built on is still accessible with 

```javascript
import NFC from "react-native-rfid-nfc-scanner";
```

You can still access the NFC api which has also been expanded.
```javascript
NFC.initialize();
```
- Start the scanner (For both android and ios)

```javascript
NFC.stopScan();
```
- Stops the scanner (For android)

```javascript
NFC.isEnabled();
```
- tells you if the device can use an RFID scanner

```javascript
NFC.checkDeviceStatus();
```
- Gets the device status (Described below)

```javascript
NFC.addListener(name, callback, error);
```
- add a scan listener

```javascript
NFC.removeListener(name);
```
- Remove a specific user (Fixed in iOS)

```javascript
NFC.removeAllListeners();
```
- Remove all scan listeners


## Statuses ##
  >- waiting      - Attempting to start up the NFC scanner
  >- ready        - Scanner is ready to use
  >- missing      - The Scanner attempted to start but could not create a reading session
  >- unavailable  - The scanner is not available on this version of the OS

## Response ##
Upon a successful scan, the callback will recieve a payload in the following format:
```json
{
        "id": "[String] => scan ID",
        "type": "[String] => scan type from device",
        "origin": "[String] => 'ios' or 'android'",
        "scanned": "[String] => scanned data",
        "from_device": "[Object] => payload recieved from the device scan"
}
```

### IOS Response Sample ###

```json
{
    "id": "unavailable",
    "type": "NFC",
    "encoding": "UTF-8",
    "origin": "ios",
    "scanned": "2033085@MBtilk2XLGLvfxn3edK^qj3Xab/S4B9E92+",
    "from_device": {
        "origin": "ios",
        "data": [
            [
                {
                    "locale": "en",
                    "encoding": "UTF-8",
                    "type": "TEXT",
                    "data": "2033085@MBtilk2XLGLvfxn3edK^qj3Xab/S4B9E92+"
                }
            ]
        ],
        "id": "unavailable",
        "type": "NFC"
    }
}
```

### Android Response Sample ###

```json
{
    "id": "04E49EFA2E4480",
    "type": "NDEF",
    "encoding": "UTF-8",
    "origin": "android",
    "scanned": "2033085@MBtilk2XLGLvfxn3edK^qj3Xab/S4B9E92+",
    "from_device": {
        "origin": "android",
        "data": [
            [
                {
                    "locale": "en",
                    "encoding": "UTF-8",
                    "type": "TEXT",
                    "data": "2033085@MBtilk2XLGLvfxn3edK^qj3Xab/S4B9E92+"
                }
            ]
        ],
        "id": "04E49EFA2E4480",
        "type": "NDEF"
    }
}
```

### NFC-V/Other Tags on Android ###

```json
{
    "id": "AD10EA35500104E0",
    "type": "NfcV",
    "encoding": "UTF-8",
    "origin": "android",
    "scanned": "AD10EA35500104E0",
    "from_device": {
        "origin": "android",
        "data": [
            [
                {
                    "id": "AD10EA35500104E0",
                    "description": "TAG: Tech[android.nfc.tech.NfcV, android.nfc.tech.NdefFormatable]",
                    "techList": [
                        "android.nfc.tech.NfcV",
                        "android.nfc.tech.NdefFormatable"
                    ]
                }
            ]
        ],
        "id": "AD10EA35500104E0",
        "type": "TAG"
    }
}
```

### Error Response ###
If an error handler is provided the response will look like this:

```json
{ "error": "Some error message" }
```


## TODO

* Support more record types in iOS
* Support writing tags
* Advanced NFC operations
