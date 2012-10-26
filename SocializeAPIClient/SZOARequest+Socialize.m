//
//  SZOARequest+Socialize.m
//  Socialize
//
//  Created by Nathaniel Griswold on 8/8/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZOARequest+Socialize.h"
#import "SZCommon.h"

static NSDictionary *requestInfo;

static NSString const *kSocializeRequestInfoMethod = @"kSocializeRequestInfoMethod";
static NSString const *kSocializeRequestInfoPath = @"kSocializeRequestInfoPath";

@implementation SZOARequest (Socialize)

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

+ (SZOARequest*)socializeRequestWithMethod:(NSString*)method
                                      path:(NSString*)path
                                parameters:(NSDictionary*)parameters
                                   success:(void(^)(id result))success
                                   failure:(void(^)(NSError *error))failure {
    
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
        parameters = [NSDictionary dictionaryWithObject:parameters forKey:@"payload"];
    }
    
    SZOARequest *request = [[SZOARequest alloc] initWithConsumerKey:consumerKey
                                                     consumerSecret:consumerSecret
                                                              token:accessToken
                                                        tokenSecret:accessTokenSecret
                                                             method:method
                                                             scheme:@"http"
                                                               host:@"api.getsocialize.com"
                                                               path:path
                                                         parameters:parameters
                                                            success:^(NSURLResponse *response, NSData *data) {
                                                                NSDictionary *dictionary = [data objectFromJSONData];
                                                                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                
                                                                if (![dictionary isKindOfClass:[NSDictionary class]]) {
                                                                    NSDictionary *userInfo = @{
                                                                        kSZErrorHTTPURLResponseKey: response,
                                                                        kSZErrorHTTPURLResponseBodyKey: responseString,
                                                                    };
                                                                    NSError *error = [[NSError alloc] initWithDomain:SimpleSharingErrorDomain code:SZErrorCouldNotParseServerResponse userInfo:userInfo];
                                                                    BLOCK_CALL_1(failure, error);
                                                                    return;
                                                                }
                                                                                                                                
                                                                BLOCK_CALL_1(success, [dictionary objectForKey:@"items"]);
                                                            }
                                                            failure:failure];
    
    return request;
}

@end
