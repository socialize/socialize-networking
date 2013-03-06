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
    NSLog(@"Running op");
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


@end
