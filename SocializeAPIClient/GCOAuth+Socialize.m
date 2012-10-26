//
//  SZOARequest+Socialize.m
//  Socialize
//
//  Created by Nathaniel Griswold on 8/8/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "GCOAuth+Socialize.h"
#import "SZCommon.h"

static NSDictionary *requestInfo;

static NSString const *kSocializeRequestInfoMethod = @"kSocializeRequestInfoMethod";
static NSString const *kSocializeRequestInfoPath = @"kSocializeRequestInfoPath";

@implementation NSURLRequest (Socialize)

+ (NSDictionary*)requestInfo {
    if (requestInfo == nil) {
        requestInfo = @{
            kSocializeRequestCreateShare: @{
                kSocializeRequestInfoMethod: @"POST",
                kSocializeRequestInfoPath: @"/v1/share/",
            },
        
        };
    }
    
    return requestInfo;
}

+ (NSURLRequest*)socializeRequestWithScheme:(NSString*)scheme
                                     method:(NSString*)method
                                       path:(NSString*)path
                                 parameters:(NSDictionary*)parameters {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [defaults objectForKey:kSZAccessToken];
    NSString *accessTokenSecret = [defaults objectForKey:kSZAccessTokenSecret];
    NSString *consumerKey = [defaults objectForKey:kSZConsumerKey];
    NSString *consumerSecret = [defaults objectForKey:kSZConsumerSecret];
    
    NSString *credentialsMessage = @"Tried to make Socialize request without existing credentials";
    NSAssert(accessToken != nil, credentialsMessage);
    NSAssert(accessTokenSecret != nil, credentialsMessage);
    NSAssert(consumerKey != nil, credentialsMessage);
    NSAssert(consumerSecret != nil, credentialsMessage);
    
    // This is what the Socialize API wants
    if ([method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"]) {
        parameters = [NSDictionary dictionaryWithObject:[parameters JSONString] forKey:@"payload"];
    }
    
    return [GCOAuth URLRequestForPath:path HTTPMethod:method parameters:parameters scheme:scheme host:@"api.getsocialize.com" consumerKey:consumerKey consumerSecret:consumerSecret accessToken:accessToken tokenSecret:accessTokenSecret];
}

@end
