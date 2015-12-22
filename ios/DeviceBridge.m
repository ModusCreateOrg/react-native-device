#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(Device, NSObject)

RCT_EXTERN_METHOD(info:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(lockOrientation:(NSString *)orientation)
RCT_EXTERN_METHOD(unlockOrientation)

@end
