//
//  SZOARequest+Socialize.m
//  Socialize
//
//  Created by Nathaniel Griswold on 8/8/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "NSURLRequest+Socialize.h"
#import "SZGlobal.h"
#import <GCOAuth/GCOAuth.h>

@implementation NSURLRequest (Socialize)

+ (NSURLRequest*)socializeRequestWithConsumerKey:(NSString *)consumerKey
                                  consumerSecret:(NSString *)consumerSecret
                                     accessToken:(NSString *)accessToken
                               accessTokenSecret:(NSString *)accessTokenSecret
                                          scheme:(NSString*)scheme
                                          method:(NSString*)method
                                            host:(NSString*)host
                                            path:(NSString*)path
                                      parameters:(id)parameters {

    // This is what the Socialize API wants
    if ([method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"]) {
        parameters = [NSDictionary dictionaryWithObject:[parameters JSONString] forKey:@"payload"];
    }
    
    return [GCOAuth URLRequestForPath:path HTTPMethod:method parameters:parameters scheme:scheme host:host consumerKey:consumerKey consumerSecret:consumerSecret accessToken:accessToken tokenSecret:accessTokenSecret];
}

@end
