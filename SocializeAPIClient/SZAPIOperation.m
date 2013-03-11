//
//  SZAPIOperation.m
//  SocializeAPIClient
//
//  Created by Nathaniel Griswold on 10/30/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZAPIOperation.h"
#import "SZGlobal.h"
#import "NSMutableURLRequest+Socialize.h"
#import "SZURLRequestOperation_private.h"
#import "NSMutableURLRequest+Parameters.h"
#import "NSMutableURLRequest+OAuth.h"
#import "SZAPIOperation_private.h"

@implementation SZAPIOperation

- (id)initWithConsumerKey:(NSString *)consumerKey
           consumerSecret:(NSString *)consumerSecret
              accessToken:(NSString *)accessToken
        accessTokenSecret:(NSString *)accessTokenSecret
                   method:(NSString*)method
                   scheme:(NSString*)scheme
                     host:(NSString*)host
                     path:(NSString*)path
               parameters:(id)parameters
            operationType:(SZAPIOperationType)operationType {
    
    NSMutableURLRequest *request = [NSMutableURLRequest socializeRequestWithConsumerKey:consumerKey
                                                                         consumerSecret:consumerSecret
                                                                            accessToken:accessToken
                                                                      accessTokenSecret:accessTokenSecret
                                                                                 scheme:scheme
                                                                                 method:method
                                                                                   host:host
                                                                                   path:path
                                                                             parameters:parameters
                                                                          operationType:operationType];
    

    if (self = [super initWithURLRequest:request]) {
        self.operationType = operationType;
    }
    
    return self;
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
    
    return [self initWithConsumerKey:consumerKey consumerSecret:consumerSecret accessToken:accessToken accessTokenSecret:accessTokenSecret host:host operationType:SZAPIOperationTypeUndefined parameters:parameters];
}

- (id)initWithConsumerKey:(NSString *)consumerKey
           consumerSecret:(NSString *)consumerSecret
              accessToken:(NSString *)accessToken
        accessTokenSecret:(NSString *)accessTokenSecret
                     host:(NSString*)host
            operationType:(SZAPIOperationType)operationType
               parameters:(id)parameters {

    return [self initWithConsumerKey:consumerKey consumerSecret:consumerSecret accessToken:accessToken accessTokenSecret:accessTokenSecret method:nil scheme:nil host:host path:nil parameters:parameters operationType:operationType];
}

- (void)callCompletion {
    BLOCK_CALL_2(self.APICompletionBlock, self.result, self.error);
}

- (void)downloadCompletionWithResponse:(NSURLResponse *)response data:(NSMutableData *)data error:(NSError *)error {
    self.response = response;
    self.responseData = data;
    self.error = error;

    NSDictionary *dictionary = [self.responseData objectFromJSONData];
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *userInfo = @{
            SZErrorURLResponseKey: self.response ?: [NSNull null],
            SZErrorURLResponseBodyKey: self.responseData ?: [NSNull null],
        };
        
        [self failWithError:[[NSError alloc] initWithDomain:SZAPIClientErrorDomain code:SZAPIErrorCodeCouldNotParseServerResponse userInfo:userInfo]];
        return;
    }
    
    NSArray *errorsList = [dictionary objectForKey:@"errors"];
    if ([errorsList count] > 0) {
        NSDictionary *userInfo = @{
            SZErrorServerErrorsListKey: errorsList,
        };

        [self failWithError:[[NSError alloc] initWithDomain:SZAPIClientErrorDomain code:SZAPIErrorCodeServerReturnedErrors userInfo:userInfo]];
        return;
    }
    
    self.result = [dictionary objectForKey:@"items"] ?: dictionary;
    [self callCompletion];
    [self KVStop];
}

@end
