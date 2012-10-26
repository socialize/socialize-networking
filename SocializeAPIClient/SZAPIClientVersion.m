#import "SZAPIClientVersion.h"

NSString *const SZAPIClientVersionIdentifierString = @"SZ_API_CLIENT_VERSION: " SZ_API_CLIENT_VERSION_STRING;

@interface SZAPIClientVersion
@end

@implementation SZAPIClientVersion

+ (void)load {
    NSLog(@"Initialized Socialize API Client Version %@", SZ_API_CLIENT_VERSION_STRING);
}

@end