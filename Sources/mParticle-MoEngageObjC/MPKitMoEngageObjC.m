//
//  MPKitMoEngageObjC.m
//
//
//  Created by Soumya Ranjan Mahunt on 04/09/24.
//

#import "MPKitMoEngageObjC.h"
#ifdef COCOAPODS
#import "mParticle_MoEngage/mParticle_MoEngage-Swift.h"
#elif SWIFT_PACKAGE
@import mParticle_MoEngage;
#else
#error "Package manager not supported"
#endif

@import mParticle_Apple_SDK;

@implementation MPKitMoEngageObjC

+ (void)load {
    NSString* className = NSStringFromClass([MPKitMoEngage class]);
    MPKitRegister *kitRegister = [[MPKitRegister alloc] initWithName:@"MoEngageSDK" className:className];
    [MParticle registerExtension:kitRegister];
}

@end
