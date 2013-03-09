//
//  SZOperationTests.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 3/1/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "SZOperationTests.h"
#import "SZOperation.h"

@interface SZTestOperation : SZOperation
@property (nonatomic, assign) BOOL shouldFail;
@end

@implementation SZTestOperation

- (void)main {
    self.didFail = self.shouldFail;
}

@end

@interface SZOperationTests ()
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end

@implementation SZOperationTests

- (NSOperationQueue *)operationQueue {
    if (_operationQueue == nil) {
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    return _operationQueue;
}

- (void)testFailingDependency {
    
    SZTestOperation *op1 = [[SZTestOperation alloc] init];
    op1.shouldFail = YES;
    
    SZTestOperation *op2 = [[SZTestOperation alloc] init];
    [op2 addDependency:op1];
    
    [self.operationQueue addOperations:@[ op1, op2 ] waitUntilFinished:NO];
    [self.operationQueue waitUntilAllOperationsAreFinished];

    NSError *error = [op2 failedDependenciesError];
    NSArray *failedDependencies = [[error userInfo] objectForKey:SZErrorFailedDependenciesKey];
    GHAssertTrue([failedDependencies containsObject:op1], @"Should have failed deps");
}

- (void)testNormalDependency {
    NSOperation *op1 = [[NSOperation alloc] init];
    
    SZTestOperation *op2 = [[SZTestOperation alloc] init];
    [op2 addDependency:op1];
    
    [self.operationQueue addOperations:@[ op1, op2 ] waitUntilFinished:NO];
    [self.operationQueue waitUntilAllOperationsAreFinished];
    
    NSError *error = [op2 failedDependenciesError];
    GHAssertNil(error, @"Should not have error");

}

- (void)testAddSingleOperationWithMultipleHandlers {
    SZTestOperation *operation = [[SZTestOperation alloc] init];
    
    __block BOOL one = NO, two = NO;
    [operation addCompletionBlock:^{
        one = YES;
        [self incrementAsyncCount];
    }];
    
    [operation addCompletionBlock:^{
        two = YES;
        [self incrementAsyncCount];
    }];
    
    [operation start];
    [self waitForAsyncCount:2];
    
    GHAssertTrue(one, @"One not called");
    GHAssertTrue(two, @"Two not called");
}

- (void)testAddMultipleOperationsWithSingleHandler {
    
    SZTestOperation *o1 = [[SZTestOperation alloc] init];
    __block BOOL one = NO, two = NO;
    [o1 addCompletionBlock:^{
        one = YES;
        [self incrementAsyncCount];
    }];
    
    SZTestOperation *o2 = [[SZTestOperation alloc] init];
    [o2 addCompletionBlock:^{
        two = YES;
        [self incrementAsyncCount];
    }];
    
    [o1 start];
    [o2 start];
    [self waitForAsyncCount:2];

    
    GHAssertTrue(one, @"One not called");
    GHAssertTrue(two, @"Two not called");
}


@end
