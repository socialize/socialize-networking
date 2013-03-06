//
//  NSURLRequest+SocializeTests.m
//  SocializeAPIClient
//
//  Created by Nathaniel Griswold on 3/6/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "NSMutableURLRequest+SocializeTests.h"
#import "NSMutableURLRequest+Socialize.h"

@implementation NSMutableURLRequest_SocializeTests

+ (NSString*)consumerKey {
    return @"consumerKey";
}

+ (NSString*)consumerSecret {
    return @"consumerSecret";
}

+ (NSString*)accessToken {
    return @"accessToken";
}

+ (NSString*)accessTokenSecret {
    return @"accessTokenSecret";
}

+ (NSString*)host {
    return @"host";
}

- (void)testShorthandInitializer {
    NSDictionary *params = @{@"p1": @"v1"};
    NSMutableURLRequest *req = [NSMutableURLRequest socializeRequestWithConsumerKey:[[self class] consumerKey]
                                                                     consumerSecret:[[self class] consumerSecret]
                                                                        accessToken:[[self class] accessToken]
                                                                  accessTokenSecret:[[self class] accessTokenSecret]
                                                                               host:[[self class] host]
                                                                      operationType:SZAPIOperationTypeAuthenticate
                                                                         parameters:params];
    
    GHAssertNotNil(req.HTTPMethod, @"Should have method");
    GHAssertNotNil([req.URL scheme], @"Should have scheme");
    GHAssertNotNil([req.URL path], @"Should have path");
    GHAssertNotNil([req valueForHTTPHeaderField:@"Authorization"], @"Should have auth header");
}

- (void)testManualInitializer {
    NSDictionary *params = @{@"p1": @"v1"};
    NSString *path = @"/abc/def";
    NSString *scheme = @"https";
    NSString *method = @"POST";
    
    NSMutableURLRequest *req = [NSMutableURLRequest socializeRequestWithConsumerKey:[[self class] consumerKey]
                                                                     consumerSecret:[[self class] consumerSecret]
                                                                        accessToken:[[self class] accessToken]
                                                                  accessTokenSecret:[[self class] accessTokenSecret]
                                                                             scheme:scheme
                                                                             method:method
                                                                               host:[[self class] host]
                                                                               path:path
                                                                         parameters:params];
                                
    
    GHAssertEqualStrings(req.HTTPMethod, method, @"Incorrect method");
    GHAssertEqualStrings([req.URL scheme], scheme, @"Incorrect scheme");
    GHAssertEqualStrings([req.URL path], path, @"Incorrect path");
    GHAssertNotNil([req valueForHTTPHeaderField:@"Authorization"], @"Should have auth header");
}

@end
