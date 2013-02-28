//
//  NSDictionary+Functional.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/27/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Functional)
- (void)each:(void(^)(id, id))block;
- (NSArray*)map:(id(^)(id, id))block;

@end
