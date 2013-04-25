//
//  NSHTTPURLResponse+StringEncoding.m
//  SocializeAPIClient
//
//  Created by Nathaniel Griswold on 10/31/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "NSHTTPURLResponse+StringEncoding.h"

@implementation NSHTTPURLResponse (StringEncoding)

- (NSStringEncoding)stringEncoding {
    NSStringEncoding encoding = NSISOLatin1StringEncoding;
    NSString *contentType = [[[self allHeaderFields] objectForKey:@"Content-Type"] lowercaseString];
    if (contentType && [contentType rangeOfString:@"charset=utf-8"].location != NSNotFound) {
        encoding = NSUTF8StringEncoding;
    }
    
    return encoding;
}

- (NSString*)stringForResponseData:(NSData*)data {
    NSStringEncoding encoding = [self stringEncoding];
    return [[NSString alloc] initWithData:data encoding:encoding];
}

@end
