//
//  NSOperation+AdditionalCompletionTests.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 3/1/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "NSOperation+AdditionalCompletionTests.h"
#import "NSOperation+AdditionalCompletion.h"

@interface TestOperation : NSOperation
@end

@implementation TestOperation

- (void)main {    
}

@end

@interface NSOperation_AdditionalCompletionTests ()
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end

@implementation NSOperation_AdditionalCompletionTests

- (NSOperationQueue *)operationQueue {
    if (_operationQueue == nil) {
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    return _operationQueue;
}

- (void)testAddSingleOperationWithMultipleHandlers {
    TestOperation *operation = [[TestOperation alloc] init];
    
    __block BOOL one = NO, two = NO;
    [operation addCompletionBlock:^{
        one = YES;
    }];

    [operation addCompletionBlock:^{
        two = YES;
    }];

    
    [self.operationQueue addOperation:operation];
    [self.operationQueue waitUntilAllOperationsAreFinished];
    
    GHAssertTrue(one, @"One not called");
    GHAssertTrue(two, @"Two not called");
}

- (void)testAddMultipleOperationsWithSingleHandler {
    
    TestOperation *o1 = [[TestOperation alloc] init];
    __block BOOL one = NO, two = NO;
    [o1 addCompletionBlock:^{
        one = YES;
    }];
    
    TestOperation *o2 = [[TestOperation alloc] init];
//    __block BOOL two = NO;
    [o2 addCompletionBlock:^{
        two = YES;
    }];
    
    [self.operationQueue addOperations:@[ o1, o2 ] waitUntilFinished:NO];
    [self.operationQueue waitUntilAllOperationsAreFinished];
    GHAssertTrue(one, @"One not called");
    GHAssertTrue(two, @"Two not called");
}

@end
