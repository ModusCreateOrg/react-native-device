//
//  Device.swift
//
//  Created by Michael Schwartz on 12/22/15.
//

import Foundation
import UIKit

extension AppDelegate {
    private func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        return Device._orientation
    }
}

@objc(Device)
class Device : NSObject {
    var bridge: RCTBridge!
    
    static var _orientation = UIInterfaceOrientationMask.All

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
      
      // TODO in progress: determine specific device details (e.g. iPhone 5, iPad 2, etc.)
      var systemInfo = utsname()
      uname(&systemInfo)
      
      let machine = systemInfo.release
      let mirror = Mirror(reflecting: machine)
      var identifier = ""
      
      for child in mirror.children {
        if let value = child.value as? Int8 where value != 0 {
          identifier.append(UnicodeScalar(UInt8(value)))
        }
      }
      
        if #available(iOS 8.0, *) {
            callback([[
                "name": d.name,
                "model": d.model,
                "localizedModel": d.localizedModel,
                "systemName" : d.systemName,
                "systemVersion": d.systemVersion,
                "userInterfaceIdiom": Device.userInterfaceIdiom(d.userInterfaceIdiom),
                "orientation": Device.orientationString(d.orientation),
                "orientationMask": Device.orientationMaskString(Device._orientation),
                "width": self.width(),
                "height": self.height()
            ]])
        }
        else {
            callback([[
                "name": d.name,
                "model": d.model,
                "localizedModel": d.localizedModel,
                "systemName" : d.systemName,
                "systemVersion": d.systemVersion,
                "userInterfaceIdiom": Device.userInterfaceIdiom(d.userInterfaceIdiom),
                "orientation": Device.orientationString(d.orientation),
                "orientationMask": Device.orientationMaskString(Device._orientation),
                "width": 0,
                "height": 0
            ]])
        }
    }
    
    @objc func lockOrientation(orientation: String) {
        switch orientation.lowercaseString {
            case "portrait":
                Device._orientation = .Portrait
            case "landscape":
                Device._orientation = .Landscape
            case "landscapeleft":
                Device._orientation = .LandscapeLeft
            case "landscaperight":
                Device._orientation = .LandscapeRight
            case "PortraitUpsideDown":
                Device._orientation = .AllButUpsideDown
            default:
                Device._orientation = .All
        }
    }

    @objc func unlockOrientation() {
        Device._orientation = .All
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: UIDeviceOrientationDidChangeNotification, object: nil);
    }
    
    @objc private func orientationChanged(notification: NSNotification) {
        NSLog("fire")
        self.bridge.eventDispatcher.sendAppEventWithName("orientationchange", body: nil)
    }
}
