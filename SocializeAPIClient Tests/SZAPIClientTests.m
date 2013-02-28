//
//  SZAPIClientTests.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 11/1/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZAPIClientTests.h"
#import "SZAPIClient.h"

static NSString *ConsumerKey = @"ConsumerKey";
static NSString *ConsumerSecret = @"ConsumerSecret";

@interface SZAPIClientTests ()
@property (nonatomic, strong) SZAPIClient *APIClient;
@property (nonatomic, strong) SZFakeOperationQueue *fakeOperationQueue;

@end

@implementation SZAPIClientTests

- (void)setUp {
    self.APIClient = [[SZAPIClient alloc] initWithConsumerKey:ConsumerKey consumerSecret:ConsumerSecret];
    self.fakeOperationQueue = [[SZFakeOperationQueue alloc] init];
    self.APIClient.operationQueue = (NSOperationQueue*)self.fakeOperationQueue;
}

- (void)tearDown {
    self.APIClient = nil;
    self.fakeOperationQueue = nil;
}

- (void)testAddingOperationAutomaticallyAuthenticates {
    
    // Add a fake operation
    id mockOperation = [OCMockObject niceMockForClass:[NSOperation class]];
    [self.APIClient addOperation:mockOperation];
    
    // Check an auth operation was automatically placed in the queue
    SZAPIOperation *operation = [self.fakeOperationQueue.operations objectAtIndex:0];
    GHAssertEquals(operation.operationType, SZAPIOperationTypeAuthenticate, @"Should be an auth operation");
    GHAssertTrue([self.fakeOperationQueue.operations containsObject:mockOperation], @"Missing operation");
    GHAssertTrue([self.fakeOperationQueue.operations count] == 2, @"Bad operation count");

}

- (void)testAddingTwoOperationsOnlyAuthenticatesOnce {
    
    // Add two fake operations
    id mockOperation1 = [OCMockObject niceMockForClass:[NSOperation class]];
    id mockOperation2 = [OCMockObject niceMockForClass:[NSOperation class]];
    [self.APIClient addOperation:mockOperation1];
    [self.APIClient addOperation:mockOperation2];

    GHAssertTrue([self.fakeOperationQueue.operations containsObject:mockOperation1], @"Missing operation");
    GHAssertTrue([self.fakeOperationQueue.operations containsObject:mockOperation2], @"Missing operation");

    GHAssertTrue([self.fakeOperationQueue.operations count] == 3, @"Bad operation count");
}

@end
