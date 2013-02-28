//
//  SZOperation.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/8/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "SZOperation.h"
#import "SZGlobal.h"

@interface SZOperation ()
@property (nonatomic, assign, getter=isExecuting) BOOL executing;
@property (nonatomic, assign, getter=isFinished) BOOL finished;
@end

@implementation SZOperation

- (void)KVStopExecuting {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = NO;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)KVStartExecuting {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)KVFinish {
    [self willChangeValueForKey:@"isFinished"];
    _finished = YES;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)KVFinishAndStopExecuting {
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    _executing = NO;
    _finished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (NSError*)failedDependenciesError {
    NSArray *failedDependencies = [self failedDependencies];
    if ([failedDependencies count] == 0) {
        return nil;
    }
    
    NSDictionary *userInfo = @{
        SZErrorFailedDependenciesKey: failedDependencies,
    };
    
    return [[NSError alloc] initWithDomain:SZAPIClientErrorDomain code:SZAPIErrorOperationHasFailedDependencies userInfo:userInfo];
}

- (NSArray*)failedDependencies {
    NSMutableArray *failedDependencies = [NSMutableArray array];
    for (id<SZFallibleOperation> operation in self.dependencies) {
        if (![operation conformsToProtocol:@protocol(SZFallibleOperation)])
            continue;
        
        if (operation.didFail) {
            [failedDependencies addObject:operation];
        }
    }
    
    return failedDependencies;
}


@end
