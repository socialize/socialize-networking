//
//  NSDictionary+Functional.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/27/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "NSDictionary+Functional.h"

@implementation NSDictionary (Functional)

- (void)each:(void(^)(id, id))block {
	NSParameterAssert(block != nil);
	
	[self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		block(key, obj);
	}];
}

- (NSArray*)map:(id(^)(id, id))block {
	NSParameterAssert(block != nil);
	
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    
	[self each:^(id key, id obj) {
		id value = block(key, obj);
		[result addObject:value];
	}];
	
	return result;
}

@end

