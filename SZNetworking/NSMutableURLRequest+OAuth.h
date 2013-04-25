//
//  NSURLRequest+OAuth.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/21/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (OAuth)

- (void)setAuthorizationHeaderWithConsumerKey:(NSString*)consumerKey consumerSecret:(NSString*)consumerSecret token:(NSString*)token tokenSecret:(NSString*)tokenSecret;

@end
