//
//  SZAPIOperation.m
//  SocializeAPIClient
//
//  Created by Nathaniel Griswold on 10/30/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZAPIOperation.h"
#import "NSURLRequest+Socialize.h"

NSString *const SZDefaultAPIHost = @"api.getsocialize.com";

@interface SZAPIOperation ()
@property (nonatomic, strong) NSDictionary *operationTypes;
@end

@implementation SZAPIOperation

+ (NSString *)defaultHost {
    return SZDefaultAPIHost;
}

- (id)initWithConsumerKey:(NSString *)consumerKey
           consumerSecret:(NSString *)consumerSecret
              accessToken:(NSString *)accessToken
        accessTokenSecret:(NSString *)accessTokenSecret
                   method:(NSString*)method
                   scheme:(NSString*)scheme
                     host:(NSString*)host
                     path:(NSString*)path
               parameters:(id)parameters {
    
    if (host == nil) {
        host = [[self class] defaultHost];
    }
    
    self.consumerKey = consumerKey;
    self.consumerSecret = consumerSecret;
    self.accessToken = accessToken;
    self.accessTokenSecret = accessTokenSecret;
    self.method = method;
    self.scheme = scheme;
    self.host = host;
    self.path = path;
    self.parameters = parameters;

    return [self initWithURLRequest:nil];
}

- (id)initWithConsumerKey:(NSString *)consumerKey
           consumerSecret:(NSString *)consumerSecret
              accessToken:(NSString *)accessToken
        accessTokenSecret:(NSString *)accessTokenSecret
                     host:(NSString*)host
            operationType:(SZAPIOperationType)operationType
               parameters:(id)parameters {
    
    NSArray *info = [self.operationTypes objectForKey:@(operationType)];
    NSString *method = [info objectAtIndex:0];
    NSString *scheme = [info objectAtIndex:1];
    NSString *path = [info objectAtIndex:2];
    
    return [self initWithConsumerKey:consumerKey consumerSecret:consumerSecret accessToken:accessToken accessTokenSecret:accessTokenSecret
                              method:method scheme:scheme host:host path:path parameters:parameters];
}

- (NSDictionary*)operationTypes {
    if (_operationTypes == nil) {
        _operationTypes = @{
            @(SZAPIOperationTypeAuthenticate): @[ @"POST", @"https", @"/v1/authenticate/" ],
            @(SZAPIOperationListComments): @[ @"GET", @"http", @"/v1/comment/" ],
            @(SZAPIOperationCreateShare): @[ @"POST", @"http", @"/v1/share/" ],
        };
    }
    
    return _operationTypes;
}

- (void)start {
    
    self.request = [NSURLRequest socializeRequestWithConsumerKey:self.consumerKey
                                                  consumerSecret:self.consumerSecret
                                                     accessToken:self.accessToken
                                               accessTokenSecret:self.accessTokenSecret
                                                          scheme:self.scheme
                                                          method:self.method
                                                            host:self.host
                                                            path:self.path
                                                      parameters:self.parameters];
    [super start];
}

@end
