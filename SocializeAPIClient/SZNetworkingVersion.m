#import "SZNetworkingVersion.h"

NSString *const SZNetworkingVersionIdentifierString = @"SZ_NETWORKING_VERSION: " SZ_NETWORKING_VERSION_STRING;

@interface SZNetworkingVersion : NSObject
@end

@implementation SZNetworkingVersion

+ (void)load {
    NSLog(@"Initialized Socialize API Client Version %@", SZ_NETWORKING_VERSION_STRING);
}

@end