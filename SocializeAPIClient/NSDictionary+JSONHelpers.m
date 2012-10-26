//
//  NSDictionary+JSONHelpers.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 10/29/12.
//  Copyright (c) 2012 Nate Griswold. All rights reserved.
//

#import "NSDictionary+JSONHelpers.h"

@implementation NSDictionary (JSONHelpers)

- (NSString*)JSONString {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
