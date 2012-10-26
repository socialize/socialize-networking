//
//  NSDictionary+JSONHelpers.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 10/29/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "NSObject+JSONHelpers.h"

@implementation NSObject (JSONHelpers)

- (NSString*)JSONString {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
