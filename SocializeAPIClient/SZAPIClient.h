//
//  SZAPIClient.h
//  SocializeAPIClient
//
//  Created by Nathaniel Griswold on 10/31/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZAPIOperation.h"

@interface SZAPIClient : NSObject

@property (nonatomic, strong) NSOperationQueue *requestQueue;
@property (nonatomic, copy) NSString *hostname;
@property (nonatomic, copy) NSString *consumerKey;
@property (nonatomic, copy) NSString *consumerSecret;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *accessTokenSecret;
@property (nonatomic, copy) NSString *udid;
@property (nonatomic, assign) BOOL authenticating;

+ (NSString*)defaultHost;
+ (NSString*)defaultUDID;

- (id)initWithConsumerKey:(NSString *)consumerKey
           consumerSecret:(NSString *)consumerSecret;

- (SZAPIOperation*)authenticate;

- (SZAPIOperation*)APIOperationForMethod:(NSString*)method
                                  scheme:(NSString*)scheme
                                    path:(NSString*)path
                              parameters:(id)parameters;

- (SZAPIOperation*)APIOperationForOperationType:(SZAPIOperationType)operationType
                                     parameters:(id)parameters;

- (SZAPIOperation*)addAPIOperationForMethod:(NSString*)method
                                     scheme:(NSString*)scheme
                                       path:(NSString*)path
                                 parameters:(id)parameters;

- (SZAPIOperation*)addAPIOperationForOperationType:(SZAPIOperationType)operationType
                                        parameters:(id)parameters;

@end
