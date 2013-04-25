//
//  NSData+JSONHelpers.m
//  SocializeAPIClient
//
//  Created by Nathaniel Griswold on 10/17/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "NSData+JSONHelpers.h"

@implementation NSData (JSONHelpers)

- (id)objectFromJSONData {
    return [NSJSONSerialization JSONObjectWithData:self options:0 error:nil];
}

@end
