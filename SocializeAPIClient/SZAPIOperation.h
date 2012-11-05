//
//  SZAPIOperation.h
//  SocializeAPIClient
//
//  Created by Nathaniel Griswold on 10/30/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZURLRequestOperation.h"

typedef NS_ENUM(NSUInteger, SZAPIOperationType) {
    SZAPIOperationTypeAuthenticate,
    SZAPIOperationListComments,
    SZAPIOperationCreateShare,
};

@interface SZAPIOperation : SZURLRequestOperation

+ (NSString *)defaultHost;

- (id)initWithConsumerKey:(NSString *)consumerKey
           consumerSecret:(NSString *)consumerSecret
              accessToken:(NSString *)accessToken
        accessTokenSecret:(NSString *)accessTokenSecret
                   method:(NSString*)method
                   scheme:(NSString*)scheme
                     host:(NSString*)host
                     path:(NSString*)path
               parameters:(id)parameters;

- (id)initWithConsumerKey:(NSString *)consumerKey
           consumerSecret:(NSString *)consumerSecret
              accessToken:(NSString *)accessToken
        accessTokenSecret:(NSString *)accessTokenSecret
                     host:(NSString*)host
            operationType:(SZAPIOperationType)operationType
               parameters:(id)parameters;

@property (nonatomic, copy) NSString *consumerKey;
@property (nonatomic, copy) NSString *consumerSecret;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *accessTokenSecret;
@property (nonatomic, copy) NSString *method;
@property (nonatomic, copy) NSString *scheme;
@property (nonatomic, copy) NSString *host;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) id parameters;

@end
