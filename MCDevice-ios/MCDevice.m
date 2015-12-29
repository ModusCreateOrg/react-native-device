#import "MCDevice.h"
#include <sys/utsname.h>

//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

@implementation AppDelegate (MCDevice)

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
  NSLog(@"%d", [MCDevice getOrientationMask]);
    return [MCDevice getOrientationMask];
}

@end

//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

@implementation MCDevice

//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

@synthesize bridge = _bridge;

/**
 * Table to map UIInterfaceOrientationMask between NSString and NSUInteger
 */
static const struct {
    __unsafe_unretained NSString *maskName;
    NSUInteger maskValue;
} masks[] = {
    {@"Portrait", UIInterfaceOrientationMaskPortrait,},
    {@"PortraitUpsideDown", UIInterfaceOrientationMaskPortraitUpsideDown,},
    {@"LandscapeLeft", UIInterfaceOrientationMaskLandscapeLeft,},
    {@"LandscapeRight", UIInterfaceOrientationMaskLandscapeRight,},
    {@"Landscape", UIInterfaceOrientationMaskLandscape,},
    {@"All", UIInterfaceOrientationMaskAll,},
    {@"AllButUpsideDown", UIInterfaceOrientationMaskAllButUpsideDown,},
    {NULL, 0}
};

//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

/**
 * Table to map UIDeviceOrientation between number and NSString
 */
static const struct {
    UIDeviceOrientation orientationValue;
    __unsafe_unretained NSString *orientationName;
} orientations[] = {
    {UIDeviceOrientationPortrait, @"Portrait",},
    {UIDeviceOrientationPortraitUpsideDown, @"PortraitUpsideDown",},
    {UIDeviceOrientationLandscapeLeft, @"LandscapeLeft",},
    {UIDeviceOrientationLandscapeRight, @"LandscapeRight",},
    {0, NULL}
};

//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

/**
 * Table to map between platform strings and device name.
 */
static const struct {
    __unsafe_unretained  NSString *platform;
    __unsafe_unretained  NSString *identifier;
} platforms[] = {
    {@"iPod5,1", @"iPod Touch 5",},
    {@"iPod7,1", @"iPod Touch 6",},
    {@"iPhone3,1", @"iPhone 4",},
    {@"iPhone3,2", @"iPhone 4",},
    {@"iPhone3,3", @"iPhone 4",},
    {@"iPhone4,1", @"iPhone 4s",},
    {@"iPhone5,1", @"iPhone 5",},
    {@"iPhone5,2", @"iPhone 5",},
    {@"iPhone5,3", @"iPhone 5c",},
    {@"iPhone5,4", @"iPhone 5c",},
    {@"iPhone6,1", @"iPhone 5s",},
    {@"iPhone6,2", @"iPhone 5s",},
    {@"iPhone7,2", @"iPhone 6",},
    {@"iPhone7,1", @"iPhone 6 Plus",},
    {@"iPhone8,1", @"iPhone 6s",},
    {@"iPhone8,2", @"iPhone 6s Plus",},
    {@"iPad2,1", @"iPad 2",},
    {@"iPad2,1", @"iPad 2",},
    {@"iPad2,2", @"iPad 2",},
    {@"iPad2,3", @"iPad 2",},
    {@"iPad3,1", @"iPad 3",},
    {@"iPad3,1", @"iPad 3",},
    {@"iPad3,2", @"iPad 3",},
    {@"iPad3,4", @"iPad 4",},
    {@"iPad3,5", @"iPad 4",},
    {@"iPad3,6", @"iPad 4",},
    {@"iPad4,1", @"iPad Air",},
    {@"iPad4,2", @"iPad Air",},
    {@"iPad4,3", @"iPad Air",},
    {@"iPad5,3", @"iPad Air 2",},
    {@"iPad5,4", @"iPad Air 2",},
    {@"iPad2,5", @"iPad Mini",},
    {@"iPad2,6", @"iPad Mini",},
    {@"iPad2,7", @"iPad Mini",},
    {@"iPad4,4", @"iPad Mini 2",},
    {@"iPad4,5", @"iPad Mini 2",},
    {@"iPad4,6", @"iPad Mini 2",},
    {@"iPad4,7", @"iPad Mini 3",},
    {@"iPad4,8", @"iPad Mini 3",},
    {@"iPad4,9", @"iPad Mini 3",},
    {@"iPad5,1", @"iPad Mini 4",},
    {@"iPad5,2", @"iPad Mini 4",},
    {@"iPad6,7", @"iPad Pro",},
    {@"iPad6,8", @"iPad Pro",},
    {@"AppleTV5,3", @"Apple TV",},
    {@"i386", @"Simulator",},
    {@"x86_64", @"Simulator",},
    {NULL, NULL}
};

//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

/**
 * Table to map IOUserInterfaceIdiom to string
 */
static struct {
  UIUserInterfaceIdiom value;
  __unsafe_unretained  NSString *name;
} idioms[] = {
    { UIUserInterfaceIdiomUnspecified, @"Unspecified" },
    { UIUserInterfaceIdiomPhone, @"Phone" },
    { UIUserInterfaceIdiomPad, @"pad" },
    { UIUserInterfaceIdiomTV, @"TV" },
    {0, NULL}
};

//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

/**
 * Table to map UIDeviceBatteryState to string
 */
static struct {
  UIDeviceBatteryState value;
  __unsafe_unretained  NSString *name;
} batteryStates[] = {
    { UIDeviceBatteryStateUnknown, @"Unknown" },
    { UIDeviceBatteryStateUnplugged, @"Unplugged" },
    { UIDeviceBatteryStateCharging, @"Charging" },
    { UIDeviceBatteryStateFull, @"Full" },
    {0, NULL}
};

//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

/**
 * Current allowed device orientations (mask).  Used by the AppDelegate logic above.
 */
static NSUInteger _orientationMask = UIInterfaceOrientationMaskAllButUpsideDown;

//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

/**
 * Static set orientation mask as NSUInteger
 */
+ (void)setOrientationMask:(NSUInteger)orientation {
    _orientationMask = orientation;
}

//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

/**
 * Static set orientation mask from NSString
 */
+ (void)setOrientationMaskFromString:(NSString *)orientation {
    if (orientation) {      // not null
        for (int i = 0; masks[i].maskName; i++) {
            if ([masks[i].maskName caseInsensitiveCompare:orientation] == NSOrderedSame) {
              [MCDevice setOrientationMask:masks[i].maskValue];
                return;
            }
        }
    }
}

//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

/**
 * Static get orientation mask as NSUInteger
 */
+ (NSUInteger)getOrientationMask {
    return _orientationMask;
}

//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

/**
 * Static get orientation mask as NSString
 */
+ (NSString *)getOrientationMaskAsString {
    for (int i = 0; masks[i].maskName; i++) {
        if (_orientationMask == masks[i].maskValue) {
            return masks[i].maskName;
        }
    }
    return @"Unknown";
}

//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

/**
 * Static return NSString representation of a UIDeviceOrientation value.
 */
+ (NSString *)deviceOrientationAsString:(UIDeviceOrientation)orientation {
    for (int i = 0; orientations[i].orientationName; i++) {
        if (orientations[i].orientationValue == orientation) {
            return orientations[i].orientationName;
        }
    }
    return @"Unknown";
}

//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

/**
 * Static return NSString representation of a UIUserInterfaceIdiom value.
 */
+ (NSString *)userInterfaceIdiomAsString:(UIUserInterfaceIdiom)idiom {
    for (int i = 0; idioms[i].name; i++) {
        if (idioms[i].value == idiom) {
            return idioms[i].name;
        }
    }
    return @"Unknown";
}

//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

/**
 * Static return NSString representation of a UIDeviceBatteryState value.
 */
+ (NSString *)batteryStateAsString:(UIDeviceBatteryState)state {
    for (int i = 0; batteryStates[i].name; i++) {
        if (batteryStates[i].value == state) {
            return batteryStates[i].name;
        }
    }
    return @"Unknown";
}



//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

/**
 * Constructor
 */
- (instancetype)init {
    if ((self = [super init])) {
        // install listener for orientation change event
        [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(orientationChanged:)
                   name:@"UIDeviceOrientationDidChangeNotification"
                 object:nil
        ];
        // install listener for application suspend event
        [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(suspend:)
                   name:@"UIApplicationDidEnterBackgroundNotification"
                 object:nil
        ];
        // install listener for application resume event
        [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(resume:)
                   name:@"UIApplicationDidBecomeActiveNotification"
                 object:nil
        ];
    }
    return self;
}

//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

/**
 * Destructor
 */
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

/**
 * orientationchange event handler
 */
- (void)orientationChanged:(NSNotification *)notification {
    [_bridge.eventDispatcher sendDeviceEventWithName:@"orientationchange" body:NULL];
}

//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

/**
 * App suspended event handler
 */
-(void)suspend:(NSNotification *)notification {
    [_bridge.eventDispatcher sendDeviceEventWithName:@"suspend" body:NULL];
}

//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

/**
 * App resumed event handler
 */
-(void)resume:(NSNotification *)notification {
    [_bridge.eventDispatcher sendDeviceEventWithName:@"resume" body:NULL];
}

//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

/**
 * Export methods via React.NativeModules.MCDevice
 */
RCT_EXPORT_MODULE();

//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

/**
 * lockOrientation(orientation);
 *
 * Lock the display to the specified orientation.
 *
 * orientation values may be:
 *
 * - "Portrait"
 * - "PortraitUpsideDown"
 * - "LandscapeLeft"
 * - "LandscapeRight"
 * - "Landscape"
 * - "All"
 * - "AllButUpsideDown
 *
 * @param {String} orientation - allowed orientation mask (see string values above)
 */
RCT_EXPORT_METHOD(lockOrientation:(NSString *) orientation) {
    [MCDevice setOrientationMaskFromString:orientation];
}

//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

/**
 * unlockOrientation()
 *
 * Sets the allowed device orientations to "AllButUpsideDown"
 *
 */
RCT_EXPORT_METHOD(unlockOrientation) {
    [MCDevice setOrientationMask:UIInterfaceOrientationMaskAllButUpsideDown];
}

//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\

/**
 * info(callback)
 *
 * Gets information about the device, as a hash.
 *
 * The callback is called with the hash as its only argument.  The hash looks like this:
 *
 * - height: 414
 * - identifier: "Simulator"  (might be iPhone 4, iPad Mini 2, etc.)
 * - localizedModel: "iPhone"
 * - model: "iPhone"
 * - name: "iPhone Simulator"
 * - orientation: "LandscapeLeft"
 * - orientationMask: "All"
 * - systemName: "iPhone OS"
 * - systemVersion: "9.2"
 * - userInterfaceIdiom: "Phone"
 * - width: 736
 *
 */
RCT_EXPORT_METHOD(info:(RCTResponseSenderBlock) callback) {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *identifier = @"Unknown";

    for (int i = 0; platforms[i].platform; i++) {
        if ([platform caseInsensitiveCompare:platforms[i].platform] == NSOrderedSame) {
            platform = platforms[i].platform;
            identifier = platforms[i].identifier;
        }
    }

    UIDevice *d = [UIDevice currentDevice];

    callback(@[
        @{
            @"width" : @([[UIScreen mainScreen] bounds].size.width),
            @"height" : @([[UIScreen mainScreen] bounds].size.height),
            @"orientation" : [MCDevice deviceOrientationAsString:[[UIDevice currentDevice] orientation]],
            @"orientationMask" : [MCDevice getOrientationMaskAsString],
            @"platform" : platform,
            @"identifier" : identifier,
            @"name" : d.name,
            @"model" : d.model,
            @"localizedModel" : d.localizedModel,
            @"systemName" : d.systemName,
            @"systemVersion" : d.systemVersion,
            @"userInterfaceIdiom" : [MCDevice userInterfaceIdiomAsString:d.userInterfaceIdiom],
        }
    ]);
};

@end
