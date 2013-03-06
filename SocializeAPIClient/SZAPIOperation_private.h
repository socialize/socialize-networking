//
//  SZAPIOperation_private.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/22/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

@interface SZAPIOperation ()
- (id)initWithConsumerKey:(NSString *)consumerKey
           consumerSecret:(NSString *)consumerSecret
              accessToken:(NSString *)accessToken
        accessTokenSecret:(NSString *)accessTokenSecret
                   method:(NSString*)method
                   scheme:(NSString*)scheme
                     host:(NSString*)host
                     path:(NSString*)path
               parameters:(id)parameters
            operationType:(SZAPIOperationType)operationType;


@property (nonatomic, weak) SZAPIClient *APIClient;
@property (nonatomic, strong) id result;
@property (nonatomic, assign) SZAPIOperationType operationType;

@end