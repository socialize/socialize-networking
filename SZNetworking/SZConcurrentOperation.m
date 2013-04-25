//
//  SZConcurrentOperation.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 3/1/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "SZConcurrentOperation.h"
#import "SZConcurrentOperation_private.h"

@implementation SZConcurrentOperation

- (void)KVStop {
    BOOL didChangeFinished = NO;
    BOOL didChangeExecuting = NO;
    
    if (!_finished) {
        [self willChangeValueForKey:@"isFinished"];
        didChangeFinished = YES;
    }
    
    if (_executing) {
        [self willChangeValueForKey:@"isExecuting"];
        didChangeExecuting = YES;
    }
    
    _executing = NO;
    _finished = YES;
    
    if (didChangeFinished) {
        [self didChangeValueForKey:@"isFinished"];
    }
    if (didChangeExecuting) {
        [self didChangeValueForKey:@"isExecuting"];
    }
}

- (void)KVStart {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)KVCancel {
    [self willChangeValueForKey:@"isCancelled"];
    _cancelled = YES;
    [self didChangeValueForKey:@"isCancelled"];
}

@end
