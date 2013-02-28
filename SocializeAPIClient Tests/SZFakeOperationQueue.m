//
//  SZFakeOperationQueue.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/27/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "SZFakeOperationQueue.h"
#import "NSObject+JRSwizzle.h"

@implementation SZFakeOperationQueue

- (NSArray*)operations {
    return self.fakeOperations;
}

- (NSMutableArray *)fakeOperations {
    if (_fakeOperations == nil) {
        _fakeOperations = [NSMutableArray array];
    }
    
    return _fakeOperations;
}

- (void)addOperation:(NSOperation *)op {
    [self.fakeOperations addObject:op];
}

- (void)addOperations:(NSArray *)ops waitUntilFinished:(BOOL)wait {
    [self.fakeOperations addObjectsFromArray:ops];
}

@end
