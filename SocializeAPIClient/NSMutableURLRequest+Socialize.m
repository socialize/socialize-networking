//
//  SZOARequest+Socialize.m
//  Socialize
//
//  Created by Nathaniel Griswold on 8/8/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "NSMutableURLRequest+Socialize.h"
#import "SZGlobal.h"
#import "NSMutableURLRequest+Parameters.h"
#import "NSMutableURLRequest+OAuth.h"

static NSDictionary *operationTypes;

@implementation NSMutableURLRequest (Socialize)

+ (NSDictionary*)operationTypes {
    if (operationTypes == nil) {
        operationTypes = @{
                            @(SZAPIOperationTypeAuthenticate): @[ @"POST", @"https", @"/v1/authenticate/" ],
                            @(SZAPIOperationTypeListComments): @[ @"GET", @"http", @"/v1/comment/" ],
                            @(SZAPIOperationTypeCreateShare): @[ @"POST", @"http", @"/v1/share/" ],
                            };
    }
    
    return operationTypes;
}

+ (NSMutableURLRequest*)socializeRequestWithConsumerKey:(NSString *)consumerKey
                                         consumerSecret:(NSString *)consumerSecret
                                            accessToken:(NSString *)accessToken
                                      accessTokenSecret:(NSString *)accessTokenSecret
                                                 scheme:(NSString*)scheme
                                                 method:(NSString*)method
                                                   host:(NSString*)host
                                                   path:(NSString*)path
                                             parameters:(id)parameters
                                          operationType:(SZAPIOperationType)operationType {
    
    if (host == nil) {
        host = SZDefaultAPIHost;
    }
    
    if (operationType != SZAPIOperationTypeUndefined) {
        NSArray *info = [self.operationTypes objectForKey:@(operationType)];
        method = [info objectAtIndex:0];
        scheme = [info objectAtIndex:1];
        path = [info objectAtIndex:2];
    }
    
    // This is what the Socialize API wants
    if (parameters != nil && ([method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"])) {
        parameters = [NSDictionary dictionaryWithObject:[parameters JSONString] forKey:@"payload"];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest HTTPRequestWithMethod:method scheme:scheme host:host path:path parameters:parameters];
    [request setAuthorizationHeaderWithConsumerKey:consumerKey consumerSecret:consumerSecret token:accessToken tokenSecret:accessTokenSecret];
    
    return request;
}

+ (NSMutableURLRequest*)socializeRequestWithConsumerKey:(NSString *)consumerKey
                                  consumerSecret:(NSString *)consumerSecret
                                     accessToken:(NSString *)accessToken
                               accessTokenSecret:(NSString *)accessTokenSecret
                                            host:(NSString*)host
                                   operationType:(SZAPIOperationType)operationType
                                      parameters:(id)parameters {

    return [self socializeRequestWithConsumerKey:consumerKey consumerSecret:consumerSecret accessToken:accessToken accessTokenSecret:accessTokenSecret scheme:nil method:nil host:host path:nil parameters:parameters operationType:operationType];
}

+ (NSMutableURLRequest*)socializeRequestWithConsumerKey:(NSString *)consumerKey
                                  consumerSecret:(NSString *)consumerSecret
                                     accessToken:(NSString *)accessToken
                               accessTokenSecret:(NSString *)accessTokenSecret
                                          scheme:(NSString*)scheme
                                          method:(NSString*)method
                                            host:(NSString*)host
                                            path:(NSString*)path
                                      parameters:(id)parameters {
    
    return [self socializeRequestWithConsumerKey:consumerKey consumerSecret:consumerSecret accessToken:accessToken accessTokenSecret:accessTokenSecret scheme:scheme method:method host:host path:path parameters:parameters operationType:SZAPIOperationTypeUndefined];
}

@end
