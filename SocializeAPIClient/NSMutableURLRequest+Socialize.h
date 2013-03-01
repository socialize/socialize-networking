//
//  SZOARequest+Socialize.h
//  Socialize
//
//  Created by Nathaniel Griswold on 8/8/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZURLRequestOperation.h"

// Since appledoc does not support enums, please also update the below documentation when making changes
typedef NS_ENUM(NSUInteger, SZAPIOperationType) {
    SZAPIOperationTypeUndefined,
    SZAPIOperationTypeAuthenticate,
    SZAPIOperationTypeListComments,
    SZAPIOperationTypeCreateShare,
};

/**
 Create NSMutableURLRequests suitable for use with the Socialize API servers
 */
@interface NSMutableURLRequest (Socialize)

/**
 Create a Socialize request (operation type variant).
 
 @param consumerKey Consumer Key (Register at getsocialize.com)
 @param consumerSecret Consumer Secret (Register at getsocialize.com)
 @param accessToken Access Token. Not required for token request methods such as authenticate
 @param accessTokenSecret Access Token Secret. Not required for token request methods such as authenticate
 @param host Hostname to contact
 @param operationType SZAPIOperationType.
     typedef NS_ENUM(NSUInteger, SZAPIOperationType) {
         SZAPIOperationTypeUndefined,
         SZAPIOperationTypeAuthenticate,
         SZAPIOperationTypeListComments,
         SZAPIOperationTypeCreateShare,
     };

 @param parameters Parameters
 */
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


