//
//  SZOARequest+Socialize.h
//  Socialize
//
//  Created by Nathaniel Griswold on 8/8/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZURLRequestOperation.h"

typedef NS_ENUM(NSUInteger, SZAPIOperationType) {
    SZAPIOperationTypeUndefined,
    SZAPIOperationTypeAuthenticate,
    SZAPIOperationTypeListComments,
    SZAPIOperationTypeCreateShare,
};

@interface NSMutableURLRequest (Socialize)

+ (NSMutableURLRequest*)socializeRequestWithConsumerKey:(NSString *)consumerKey
                                         consumerSecret:(NSString *)consumerSecret
                                            accessToken:(NSString *)accessToken
                                      accessTokenSecret:(NSString *)accessTokenSecret
                                                   host:(NSString*)host
                                          operationType:(SZAPIOperationType)operationType
                                             parameters:(id)parameters;

+ (NSMutableURLRequest*)socializeRequestWithConsumerKey:(NSString *)consumerKey
                                  consumerSecret:(NSString *)consumerSecret
                                     accessToken:(NSString *)accessToken
                               accessTokenSecret:(NSString *)accessTokenSecret
                                          scheme:(NSString*)scheme
                                          method:(NSString*)method
                                            host:(NSString*)host
                                            path:(NSString*)path
                                      parameters:(id)parameters;

@end