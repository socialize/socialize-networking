//
//  NSHTTPURLResponse+StringEncoding.h
//  SocializeAPIClient
//
//  Created by Nathaniel Griswold on 10/31/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSHTTPURLResponse (StringEncoding)

- (NSStringEncoding)stringEncoding;
- (NSString*)stringForResponseData:(NSData*)data;


@end
