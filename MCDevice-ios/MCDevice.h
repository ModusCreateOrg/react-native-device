#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RCTBridgeModule.h"
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "AppDelegate.h"

@interface MCDevice : NSObject <RCTBridgeModule>

+(void)setOrientationMask:(NSUInteger)orientation;
+(void)setOrientationMaskFromString:(NSString*)orientation;
+(NSUInteger)getOrientationMask;
+(NSString*)getOrientationMaskAsString;


@end

@interface AppDelegate (Orientation)

@end
