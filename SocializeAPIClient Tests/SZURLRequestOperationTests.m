//
//  SZURLRequestOperationTests.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/8/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "SZURLRequestOperationTests.h"
#import "SZURLRequestOperation_private.h"
#import "SZURLRequestDownloader.h"
#import <objc/runtime.h>
#import "SZURLRequestDownloaderTests.h"

@interface SZURLRequestOperationTests ()
@property (nonatomic, strong) SZURLRequestOperation *URLRequestOperation;
@property (nonatomic, strong) id partial;
@property (nonatomic, strong) id mockDownloader;
@property (nonatomic, strong) SZURLRequestDownloader *realDownloader;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation SZURLRequestOperationTests

+ (NSURL*)testURL {
    return [NSURL URLWithString:@"http://api.getsocialize.com"];
}

+ (NSMutableURLRequest*)testURLRequest {
    return [NSURLRequest requestWithURL:[self testURL]];
}

- (void)setUp {
    self.URLRequestOperation = [[SZURLRequestOperation alloc] initWithURLRequest:[[self class] testURLRequest]];
    self.mockDownloader = [OCMockObject mockForClass:[SZURLRequestDownloader class]];
    
    [super setUp];
}

- (void)tearDown {
    [self.mockDownloader verify];
    
    self.mockDownloader = nil;
    self.partial = nil;

    [super tearDown];
}

- (NSOperationQueue *)operationQueue {
    if (_operationQueue == nil) {
        _operationQueue = [[NSOperationQueue alloc] init];
        [_operationQueue setMaxConcurrentOperationCount:50];
    }
    
    return _operationQueue;
}

- (void)becomePartial {
    if (self.partial == nil) {
        self.partial = [OCMockObject partialMockForObject:self.URLRequestOperation];
    }
}

- (void)replaceDownloaderProperty {
    [self becomePartial];

    REPLACE_PROPERTY(self.partial, URLRequestDownloader, self.mockDownloader, setURLRequestDownloader, self.realDownloader);
}

- (void)testRequestOperation {
    [self replaceDownloaderProperty];
    
    WEAK(self) weakSelf = self;
    self.URLRequestOperation.URLCompletionBlock = ^(NSURLResponse *response, NSData *responseData, NSError *error) {
        [weakSelf notify:kGHUnitWaitStatusSuccess];
    };
    
    id mockResponse = [OCMockObject mockForClass:[NSURLResponse class]];
    id mockData = [OCMockObject mockForClass:[NSMutableData class]];
    id mockError = [OCMockObject mockForClass:[NSError class]];
    [self.mockDownloader expectStartAndCompleteWithResponse:mockResponse data:mockData error:mockError];
    
    [self prepare];
    [self.URLRequestOperation start];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:0.5];
}

- (void)testCancelBeforeStartCancelsOperation {
    [self.URLRequestOperation cancel];
    [self.URLRequestOperation start];
    [self.URLRequestOperation waitUntilFinished];
    
    GHAssertTrue(self.URLRequestOperation.isFinished, @"Should be finished");
    GHAssertFalse(self.URLRequestOperation.isExecuting, @"Should not be executing");
    GHAssertTrue(self.URLRequestOperation.isCancelled, @"Should be cancelled");
}

- (void)testCancelAfterStartCancelsDownloadAndOperation {
    [self replaceDownloaderProperty];

    [self.mockDownloader makeNice];
    [self.URLRequestOperation start];
    [self.mockDownloader reset];
    
    self.mockDownloader = [OCMockObject mockForClass:[SZURLRequestDownloader class]];
    [[self.mockDownloader expect] cancel];
    
    [self.URLRequestOperation cancel];
}

- (void)testConsistencyOfStart {
    int numOperations = 100;
    
    for (int i = 0; i < numOperations; i++) {

        [self.operationQueue addOperationWithBlock:^{
            SZURLRequestOperation *operation = [[SZURLRequestOperation alloc] initWithURLRequest:[[self class] testURLRequest]];
            id mockDownloader = [OCMockObject mockForClass:[SZURLRequestDownloader class]];
            operation.URLRequestDownloader = mockDownloader;
            
            __block BOOL downloaderStarted = NO;
            [(SZURLRequestDownloader*)[[mockDownloader stub] andDo0:^{
                downloaderStarted = YES;
            }] start];
            
            __block BOOL downloaderCancelled = NO;
            [[[mockDownloader stub] andDo0:^{
                downloaderCancelled = YES;
            }] cancel];
            
            downloaderStarted = NO;
            downloaderCancelled = NO;
            
            // Perform a randomly timed early cancel
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSTimeInterval sleepInterval = RANDRANGE(0, 0.25);
                [NSThread sleepForTimeInterval:sleepInterval];
                [operation cancel];
            });
            [operation start];
            [operation waitUntilFinished];
            
            GHAssertTrue([operation isCancelled], @"Should be cancelled");
            GHAssertTrue(downloaderStarted && downloaderCancelled || !downloaderStarted && !downloaderCancelled, @"Should either be started and cancelled or never started");
            
            [self incrementAsyncCount];

        }];
    }
    
    [self waitForAsyncCount:numOperations];
}

@end
