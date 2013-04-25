//
//  NSURLRequest+Parameters.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/21/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (Parameters)

+ (NSMutableURLRequest*)HTTPRequestWithMethod:(NSString*)method scheme:(NSString*)scheme host:(NSString*)host path:(NSString*)path parameters:(NSDictionary*)parameters;

@end