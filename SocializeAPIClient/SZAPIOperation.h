//
//  SZAPIOperation.h
//  SocializeAPIClient
//
//  Created by Nathaniel Griswold on 10/30/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZURLRequestOperation.h"
#import "NSMutableURLRequest+Socialize.h"

typedef NS_ENUM(NSUInteger, SZShareMedium) {
    SZShareMediumTwitter = 1,
    SZShareMediumFacebook = 2,
    SZShareMediumEmail = 3,
    SZShareMediumSMS = 4,
    SZShareMediumOther = 101,
};

@class SZAPIClient;

@interface SZAPIOperation : SZURLRequestOperation

- (id)initWithConsumerKey:(NSString *)consumerKey
           consumerSecret:(NSString *)consumerSecret
              accessToken:(NSString *)accessToken
        accessTokenSecret:(NSString *)accessTokenSecret
                     host:(NSString*)host
            operationType:(SZAPIOperationType)operationType
               parameters:(id)parameters;

- (id)initWithConsumerKey:(NSString *)consumerKey
           consumerSecret:(NSString *)consumerSecret
              accessToken:(NSString *)accessToken
        accessTokenSecret:(NSString *)accessTokenSecret
                   method:(NSString*)method
                   scheme:(NSString*)scheme
                     host:(NSString*)host
                     path:(NSString*)path
               parameters:(id)parameters;

+ (NSString *)defaultHost;

@property (nonatomic, copy) void (^APICompletionBlock)(id result, NSError *error);
@property (nonatomic, strong, readonly) id result;
@property (nonatomic, weak, readonly) SZAPIClient *APIClient;
@property (nonatomic, assign, readonly) SZAPIOperationType operationType;

@end
