//
//  NSURLConnection+Testing.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/8/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLConnection (Testing)

+ (void)expectRequestWithCheck:(BOOL(^)(NSURLRequest* request))checkBlock response:(NSURLResponse*)response chunks:(NSArray*)chunks;

@end
