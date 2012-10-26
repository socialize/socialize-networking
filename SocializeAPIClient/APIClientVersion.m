#import "PerformanceAdsVersion.h"

NSString *const PerformanceAdsVersionIdentifierString = @"PERFORMANCE_ADS_VERSION: " PERFORMANCE_ADS_VERSION_STRING;

@interface PerformanceAdsVersion
@end

@implementation PerformanceAdsVersion

+ (void)load {
    NSLog(@"Initialized Socialize Performance Ads Version %@", PERFORMANCE_ADS_VERSION_STRING);
}

@end