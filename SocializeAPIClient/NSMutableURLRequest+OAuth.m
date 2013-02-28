//
//  NSURLRequest+OAuth.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/21/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "NSMutableURLRequest+OAuth.h"
#import <OAuthCore/OAuthCore.h>

@implementation NSMutableURLRequest (OAuth)

- (void)setAuthorizationHeaderWithConsumerKey:(NSString*)consumerKey consumerSecret:(NSString*)consumerSecret token:(NSString*)token tokenSecret:(NSString*)tokenSecret {
    NSString *authorizationHeader = OAuthorizationHeader([self URL], [self HTTPMethod], [self HTTPBody], consumerKey, consumerSecret, token, tokenSecret);
    [self setValue:authorizationHeader forHTTPHeaderField:@"Authorization"];
}

@end