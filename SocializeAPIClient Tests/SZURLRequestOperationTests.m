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

@interface SZURLRequestOperationHarness : SZURLRequestOperation
@property (nonatomic, strong) SZURLRequestDownloader *realURLRequestDownloader;
@end

@implementation SZURLRequestOperationHarness
- (void)setURLRequestDownloader:(SZURLRequestDownloader *)URLRequestDownloader { _realURLRequestDownloader = URLRequestDownloader; }
- (void)setMockURLRequestDownloader:(SZURLRequestDownloader *)URLRequestDownloader { [super setURLRequestDownloader:URLRequestDownloader]; }
@end

@interface SZURLRequestOperationTests ()
@property (nonatomic, strong) id realObject;
@property (nonatomic, strong) SZURLRequestOperation *URLRequestOperation;

@end

@implementation SZURLRequestOperationTests

- (NSOperationQueue*)operationQueue {
    if (_operationQueue == nil) {
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    
    return _operationQueue;
}

- (void)testRequestOperation {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]];
    SZURLRequestOperationHarness *operation = [[SZURLRequestOperationHarness alloc] initWithURLRequest:request];

    id mockResponse = [OCMockObject mockForClass:[NSHTTPURLResponse class]];
    id mockData = [OCMockObject mockForClass:[NSData class]];
    
    id mockDownloader = [SZURLRequestDownloaderTests completingMockDownloaderWithResponse:mockResponse data:mockData error:nil];
    [operation setMockURLRequestDownloader:mockDownloader];
    
    operation.URLCompletionBlock = ^(NSURLResponse *response, NSData *data, NSError *error) {
        GHAssertEquals(response, mockResponse, @"Response incorrect");
        GHAssertEquals(data, mockData, @"Data incorrect");
        GHAssertNil(error, @"Unexpected error");
        
        [self notify:kGHUnitWaitStatusSuccess];
    };
        
    [self prepare];
    [self.operationQueue addOperation:operation];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:2];
}

@end
