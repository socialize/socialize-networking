//
//  SZAPIClientTests.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 11/1/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZAPIClientTests.h"
#import "SZAPIClient.h"
#import "NSOperation+Testing.h"
#import "SZAPIOperation_private.h"
#import "SZAPIClient_private.h"
#import "SZFakeAPIOperation.h"
#import "NSMutableURLRequest+OAuth.h"

static NSString *ConsumerKey = @"ConsumerKey";
static NSString *ConsumerSecret = @"ConsumerSecret";

@interface SZAPIClientTests ()
@property (nonatomic, strong) SZAPIClient *APIClient;
@property (nonatomic, strong) SZFakeOperationQueue *fakeOperationQueue;
@property (nonatomic, strong) id partial;

@end

@implementation SZAPIClientTests

+ (NSString*)fakeAuthTestToken {
    return @"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa";
}

+ (NSString*)fakeAuthTestTokenSecret {
    return @"bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbbb";
}

+ (NSDictionary*)fakeAuthResult {
    return @{
        @"oauth_token": [self fakeAuthTestToken],
        @"oauth_token_secret": [self fakeAuthTestTokenSecret],
        @"user": @{
            @"description": @"<null>",
            @"first_name": @"<null>",
            @"id": @123658072,
            @"large_image_uri": @"<null>",
            @"last_name": @"<null>",
            @"location": @"<null>",
            @"medium_image_uri": @"<null>",
            @"meta": @"<null>",
            @"quiet_end_time": @"<null>",
            @"quiet_start_time": @"<null>",
            @"sex": @"<null>",
            @"small_image_uri": @"<null>",
            @"stats": @{
                @"comments": @0,
                @"likes": @0,
                @"shares": @0,
                @"views": @0,
            },
            @"third_party_auth": @[],
            @"timezone": @"<null>",
            @"username": @"User123658072",
        },
    };
}

- (void)setUp {
    self.APIClient = [[SZAPIClient alloc] initWithConsumerKey:ConsumerKey consumerSecret:ConsumerSecret];
    self.fakeOperationQueue = [[SZFakeOperationQueue alloc] init];
    self.APIClient.operationQueue = self.fakeOperationQueue;
}

- (void)tearDown {
    self.partial = nil;
    self.APIClient = nil;
    self.fakeOperationQueue = nil;
}

- (void)becomePartial {
    if (self.partial == nil) {
        self.partial = [OCMockObject partialMockForObject:self.APIClient];
    }
}

- (void)replaceNextAnonymousAuthOperationWithOperation:(SZAPIOperation*)operation {
    [self becomePartial];
    [[[self.partial expect] andReturn:operation] createAnonymousAuthOperation];
}

- (void)testAddingOperationSetsAPIClient {
    id mockOperation = [OCMockObject niceMockForClass:[SZAPIOperation class]];
    [[[mockOperation stub] andReturnBool:YES] isKindOfClass:[SZAPIOperation class]];
    [[mockOperation expect] setAPIClient:self.APIClient];
    [self.APIClient addOperation:mockOperation];
}

- (void)testAddingOperationAutomaticallyAuthenticates {
    
    // Add a fake operation
    id mockOperation = [OCMockObject niceMockForClass:[SZAPIOperation class]];
    
    [self.APIClient addOperation:mockOperation];
    
    // Check an auth operation was automatically placed in the queue
    SZAPIOperation *operation = [self.fakeOperationQueue.operations objectAtIndex:0];
    GHAssertEquals(operation.operationType, SZAPIOperationTypeAuthenticate, @"Should be an auth operation");
    GHAssertTrue([self.fakeOperationQueue.operations containsObject:mockOperation], @"Missing operation");
    GHAssertTrue([self.fakeOperationQueue.operations count] == 2, @"Bad operation count");

}

- (void)testAddedOperationDependsOnAuthOperation {
    id mockOperation = [OCMockObject niceMockForClass:[SZAPIOperation class]];
    [[[mockOperation stub] andReturnBool:YES] isKindOfClass:[SZAPIOperation class]];
    [[mockOperation expect] addDependency:self.APIClient.authOperation];
    [self.APIClient addOperation:mockOperation];
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

- (void)testAuthenticate {
    [self.APIClient authenticate];
    
    GHAssertTrue(self.APIClient.isAuthenticating, @"Should be authenticating");
    GHAssertTrue(self.APIClient.authOperation != nil, @"Should have auth operation");
}

- (void)testAuthenticateDoesNotDependOnSelf {
    [self.APIClient authenticate];
    
    GHAssertFalse([[self.APIClient.authOperation dependencies] containsObject:self.APIClient.authOperation], @"Should not depend on self");
}

- (void)testAuthenticatingTwiceCreatesNewOperation {
    [self.APIClient authenticate];
    
    GHAssertTrue(self.APIClient.isAuthenticating, @"Should be authenticating");
    GHAssertTrue(self.APIClient.authOperation != nil, @"Should have auth operation");
    SZAPIOperation *firstAuthOperation = self.APIClient.authOperation;
    
    [self.APIClient authenticate];

    GHAssertTrue(self.APIClient.isAuthenticating, @"Should be authenticating");
    GHAssertTrue(self.APIClient.authOperation != nil, @"Should have auth operation");
    
    GHAssertNotEquals(self.APIClient.authOperation, firstAuthOperation, @"Not first");
}

- (void)testAuthenticatingTwiceCreatesDependency {
    [self.APIClient authenticate];
    [self.APIClient authenticate];

    NSOperation *op1 = [self.fakeOperationQueue.operations objectAtIndex:0];
    NSOperation *op2 = [self.fakeOperationQueue.operations objectAtIndex:1];
    
    GHAssertTrue([op2.dependencies containsObject:op1], @"Missing dep");
}

- (void)testCompletingAuthStopsAuthenticating {
    [self.APIClient authenticate];
    
    GHAssertTrue(self.APIClient.isAuthenticating, @"Should be authenticating");
    GHAssertTrue(self.APIClient.authOperation != nil, @"Should have auth operation");
    
    [self.APIClient.authOperation simulateCompletion];
    
    GHAssertFalse(self.APIClient.isAuthenticating, @"Should not be authenticating");
    GHAssertFalse(self.APIClient.authOperation != nil, @"Should not have auth operation");
}

- (void)testCompletingAnonymousAuthSetsCredentialsFromResult {
    [self.APIClient authenticate];

    SZAPIOperation *authOperation = self.APIClient.authOperation;
    authOperation.result = [[self class] fakeAuthResult];
    
    [authOperation simulateCompletion];
    
    GHAssertEqualStrings(self.APIClient.accessToken, [[self class] fakeAuthTestToken], @"Bad access token");
    GHAssertEqualStrings(self.APIClient.accessTokenSecret, [[self class] fakeAuthTestTokenSecret], @"Bad access token secret");
}

- (void)testCompletingAnonymousAuthAddsCredentialsToPendingOperations {
    SZFakeAPIOperation *fakeAuthOperation = [[SZFakeAPIOperation alloc] init];
    fakeAuthOperation.result = [[self class] fakeAuthResult];
    [self replaceNextAnonymousAuthOperationWithOperation:fakeAuthOperation];
    
    [self.APIClient authenticate];

    id mockOperation = [OCMockObject niceMockForClass:[SZAPIOperation class]];
    [[[mockOperation stub] andReturnBool:YES] isKindOfClass:[SZAPIOperation class]];
    [[[mockOperation stub] andReturn:self.APIClient] APIClient];
    id mockRequest = [OCMockObject mockForClass:[NSMutableURLRequest class]];
    [[[mockOperation stub] andReturn:mockRequest] request];
    [[mockRequest expect] setAuthorizationHeaderWithConsumerKey:ConsumerKey consumerSecret:ConsumerSecret token:[[self class] fakeAuthTestToken] tokenSecret:[[self class] fakeAuthTestTokenSecret]];
    
    [self.APIClient addOperation:mockOperation];
    
    [fakeAuthOperation start];
}

- (void)testOperationQueueHasDefaultValue {
    self.APIClient.operationQueue = nil;
    GHAssertNotNil(self.APIClient.operationQueue, @"Should be non-nil");
}

- (void)testAddOperation {
    [self.APIClient addAPIOperationForMethod:@"GET" scheme:@"https" path:@"path" parameters:@{@"key": @"value"}];
    SZAPIOperation *operation = [self.fakeOperationQueue.operations objectAtIndex:0];
    GHAssertNotNil(operation, @"Should have operation");
}

- (void)testAddOperationWithType {
    [self.APIClient addAPIOperationForOperationType:SZAPIOperationTypeAuthenticate parameters:@{@"key": @"value"}];
    SZAPIOperation *operation = [self.fakeOperationQueue.operations objectAtIndex:0];
    GHAssertNotNil(operation, @"Should have operation");
}

- (void)testUDIDIsUsed {
    NSString *customUDID = @"customUDID";
    self.APIClient.udid = customUDID;
    [self.APIClient authenticate];
    SZAPIOperation *authOperation = [self.fakeOperationQueue.operations objectAtIndex:0];
    NSString *body = [[NSString alloc] initWithData:authOperation.request.HTTPBody encoding:NSUTF8StringEncoding];
    GHAssertTrue([body rangeOfString:@"customUDID"].location != NSNotFound, @"UDID not found");
}

- (void)testHostnameIsUsed {
    NSString *customHostname = @"customHostname";
    self.APIClient.hostname = customHostname;
    [self.APIClient authenticate];
    SZAPIOperation *authOperation = [self.fakeOperationQueue.operations objectAtIndex:0];
    GHAssertEqualStrings([authOperation.request.URL host], customHostname, @"Hello");
}

@end
