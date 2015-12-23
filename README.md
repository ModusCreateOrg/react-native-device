# React Native Device Module

Orientation methods & events plus device information.

Note: Currently for iOS only.

## Introduction

The purpose of this module is to provide some basic but important features for React Native, that are not provided by React Native proper, in a neat package.  The module is inspired the Device singleton in the browser/JavaScript.  It provides events for orientation change, suspend/resume, as well as methods for locking the display orientation (e.g. Portrait only) and for obtaining information about the device (screen width & height, curent orientation, device model, etc.).

Why implement suspend and resume when React Native already provides a similar facility?  If you use this module's facility, your code will be portable between Android and iOS.  React Native's implementaiton is via AppStateIOS, or specific to IOS.  See: https://facebook.github.io/react-native/docs/appstateios.html

## Installation

In Xcode, right click on your project sources and select "Add files..."  In the open file dialog, add three files from react-native-device:

* Device-Bridging-Header.h
* Device.swift
* DeviceBridge.m

## Use

```javascript
import React from 'react-native'
let Device = React.NativeModules.Device

// to listen to app suspend and resume events:
React.NativeAppEventEmitter.addListener('suspend', () => { console.log('suspend')});
React.NativeAppEventEmitter.addListener('resume', () => { console.log('resume')});

// to listen for orientation change events:
React.NativeAppEventEmitter.addListener('orientationchange', () => {
	console.log('Orientation Changed')
});

// (you might listen for orientationchange in your componentDidMount method)

// to force the application to render to a specific orientation:

Device.lockOrientation(orientation)

// orientation may be one of the following strings:
// "Portrait" or "Landscape" or "Landscape" or "LandscapeLeft" or "LandscapeRight" 
// or "PortraitUpsideDown"

// to allow the application to render any orientation:

Device.unlockOrientation()

// Device provides a single asynchronous method to query for information about the device:

Device.info(callback: function(info: object));

// The returned info object contains information about the device.  An example info object:
//
// height: 414
// identifier: "Simulator"  (might be iPhone 4, iPad Mini 2, etc.)
// localizedModel: "iPhone"
// model: "iPhone"
// name: "iPhone Simulator"
// orientation: "LandscapeLeft"
// orientationMask: "All"
// systemName: "iPhone OS"
// systemVersion: "9.2"
// userInterfaceIdiom: "Phone"
// width: 736 
```

See the DeviceDemo application in the ios/example directory.

## License

This module is free to use under the MIT license.  See LICENSE in this git repository for the actual license terms.

## Credits

* Mike Schwartz - @ModusSchwartz


