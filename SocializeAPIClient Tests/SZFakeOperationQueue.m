//
//  SZFakeOperationQueue.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/27/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "SZFakeOperationQueue.h"

@implementation SZFakeOperationQueue

- (NSMutableArray *)operations {
    if (_operations == nil) {
        _operations = [NSMutableArray array];
    }
    
    return _operations;
}

- (void)addOperation:(NSOperation *)op {
    [self.operations addObject:op];
}

- (void)addOperations:(NSArray *)ops waitUntilFinished:(BOOL)wait {
    [self.operations addObjectsFromArray:ops];
}

@end
