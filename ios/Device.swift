//
//  Device.swift
//
//  Created by Michael Schwartz on 12/22/15.
//

import Foundation
import UIKit

extension AppDelegate {
    private func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        return Device._orientationMask
    }
}

@objc(Device)
class Device: NSObject {
    var bridge: RCTBridge!

    static var _orientationMask = UIInterfaceOrientationMask.All

    static func orientationMaskString(orientation: UIInterfaceOrientationMask) -> String {
        switch orientation {
        case UIInterfaceOrientationMask.Portrait:
            return "Portrait"
        case UIInterfaceOrientationMask.Landscape:
            return "Landscape"
        case UIInterfaceOrientationMask.LandscapeLeft:
            return "LandscapeLeft"
        case UIInterfaceOrientationMask.LandscapeRight:
            return "LandscapeRight"
        case UIInterfaceOrientationMask.PortraitUpsideDown:
            return "PortraitUpsideDown"
        case UIInterfaceOrientationMask.All:
            return "All"
        case UIInterfaceOrientationMask.AllButUpsideDown:
            return "AllButUpsideDown"
        default:
            return "Unknown"
        }
    }

    static func orientationString(orientation: UIDeviceOrientation) -> String {
        switch orientation {
        case .Portrait:
            return "Portrait"
        case .PortraitUpsideDown:
            return "PortraitUpsideDown"
        case .LandscapeLeft:
            return "LandscapeLeft"
        case .LandscapeRight:
            return "LandscapeRight"
        case .FaceUp:
            return "FaceUp"
        case .FaceDown:
            return "FaceDown"
        default:
            return "Unknown"
        }
    }

    static func userInterfaceIdiom(idiom: UIUserInterfaceIdiom) -> String {
        switch idiom {
        case .Phone:
            return "Phone"
        case .Pad:
            return "Tablet"
        case .TV:
            return "TV"
        default:
            return "Unknown"
        }
    }

    @objc func info(callback: (NSObject) -> ()) -> Void {
        let d = UIDevice.currentDevice()

        var systemInfo = utsname()
        uname(&systemInfo)

        let machine = systemInfo.machine
        let mirror = Mirror(reflecting: machine)
        var identifier = ""

        for child in mirror.children {
            if let value = child.value as? Int8 where value != 0 {
                identifier.append(UnicodeScalar(UInt8(value)))
            }
        }

        switch (identifier) {
        case "iPod5,1":
            identifier = "iPod Touch 5"
        case "iPod7,1":
            identifier = "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":
            identifier = "iPhone 4"
        case "iPhone4,1":
            identifier = "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":
            identifier = "iPhone 5"
        case "iPhone5,3", "iPhone5,4":
            identifier = "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":
            identifier = "iPhone 5s"
        case "iPhone7,2":
            identifier = "iPhone 6"
        case "iPhone7,1":
            identifier = "iPhone 6 Plus"
        case "iPhone8,1":
            identifier = "iPhone 6s"
        case "iPhone8,2":
            identifier = "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
            identifier = "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":
            identifier = "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":
            identifier = "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":
            identifier = "iPad Air"
        case "iPad5,3", "iPad5,4":
            identifier = "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":
            identifier = "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":
            identifier = "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":
            identifier = "iPad Mini 3"
        case "iPad5,1", "iPad5,2":
            identifier = "iPad Mini 4"
        case "iPad6,7", "iPad6,8":
            identifier = "iPad Pro"
        case "AppleTV5,3":
            identifier = "Apple TV"
        case "i386", "x86_64":
            identifier = "Simulator"
        default:
            break
        }
        if #available(iOS 8.0, *) {
            callback([[
                          "identifier": identifier,
                          "name": d.name,
                          "model": d.model,
                          "localizedModel": d.localizedModel,
                          "systemName": d.systemName,
                          "systemVersion": d.systemVersion,
                          "userInterfaceIdiom": Device.userInterfaceIdiom(d.userInterfaceIdiom),
                          "orientation": Device.orientationString(d.orientation),
                          "orientationMask": Device.orientationMaskString(Device._orientationMask),
                          "width": self.width(),
                          "height": self.height()
                      ]])
        }
        else {
            callback([[
                          "name": d.name,
                          "model": d.model,
                          "localizedModel": d.localizedModel,
                          "systemName": d.systemName,
                          "systemVersion": d.systemVersion,
                          "userInterfaceIdiom": Device.userInterfaceIdiom(d.userInterfaceIdiom),
                          "orientation": Device.orientationString(d.orientation),
                          "orientationMask": Device.orientationMaskString(Device._orientationMask),
                          "width": 0,
                          "height": 0
                      ]])
        }
    }

    @objc func lockOrientation(orientation: String) {
        switch orientation.lowercaseString {
        case "portrait":
            Device._orientationMask = .Portrait
        case "landscape":
            Device._orientationMask = .Landscape
        case "landscapeleft":
            Device._orientationMask = .LandscapeLeft
        case "landscaperight":
            Device._orientationMask = .LandscapeRight
        case "PortraitUpsideDown":
            Device._orientationMask = .PortraitUpsideDown
        default:
            Device._orientationMask = .All
        }
    }

    @objc func unlockOrientation() {
        Device._orientationMask = .All
    }

    @available(iOS 8.0, *)
    func width() -> CGFloat {
        switch UIDevice.currentDevice().orientation {
        case .Portrait:
            return UIScreen.mainScreen().fixedCoordinateSpace.bounds.width
        case .PortraitUpsideDown:
            return UIScreen.mainScreen().fixedCoordinateSpace.bounds.width
        case .LandscapeLeft:
            return UIScreen.mainScreen().fixedCoordinateSpace.bounds.height
        case .LandscapeRight:
            return UIScreen.mainScreen().fixedCoordinateSpace.bounds.height
        default:
            return UIScreen.mainScreen().fixedCoordinateSpace.bounds.width
        }
    }

    @available(iOS 8.0, *)
    func height() -> CGFloat {
        switch UIDevice.currentDevice().orientation {
        case .Portrait:
            return UIScreen.mainScreen().fixedCoordinateSpace.bounds.height
        case .PortraitUpsideDown:
            return UIScreen.mainScreen().fixedCoordinateSpace.bounds.height
        case .LandscapeLeft:
            return UIScreen.mainScreen().fixedCoordinateSpace.bounds.width
        case .LandscapeRight:
            return UIScreen.mainScreen().fixedCoordinateSpace.bounds.width
        default:
            return UIScreen.mainScreen().fixedCoordinateSpace.bounds.height
        }
    }

    override internal init() {
        super.init()
        NSLog("init Device")
        // listen for orientation change events
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: UIDeviceOrientationDidChangeNotification, object: nil);
        // listen for pause and resume events
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("suspend:"), name:UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("resume:"), name:UIApplicationDidBecomeActiveNotification, object: nil)

    }

    @objc private func orientationChanged(notification: NSNotification) {
        NSLog("fire")
        self.bridge.eventDispatcher.sendAppEventWithName("orientationchange", body: nil)
    }

    @objc private func suspend(notification: NSNotification) {
        NSLog("fire")
        self.bridge.eventDispatcher.sendAppEventWithName("suspend", body: nil)
    }

    @objc private func resume(notification: NSNotification) {
        NSLog("fire")
        self.bridge.eventDispatcher.sendAppEventWithName("resume", body: nil)
    }
}
