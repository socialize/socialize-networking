//
//  SZAPIOperationTests.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/25/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "SZAPIOperationTests.h"
#import "SZAPIOperation.h"
#import "SZURLRequestOperation_private.h"
#import "SZURLRequestDownloaderTests.h"

@interface SZAPIOperationHarness : SZAPIOperation
@property (nonatomic, strong) SZURLRequestDownloader *realURLRequestDownloader;
@end

@implementation SZAPIOperationHarness
- (void)setURLRequestDownloader:(SZURLRequestDownloader *)URLRequestDownloader { _realURLRequestDownloader = URLRequestDownloader; }
- (void)setMockURLRequestDownloader:(SZURLRequestDownloader *)URLRequestDownloader { [super setURLRequestDownloader:URLRequestDownloader]; }
@end

@interface SZAPIOperationTests ()
@property (nonatomic, strong) SZAPIOperation *operation;
@property (nonatomic, strong) id partial;
@end

@implementation SZAPIOperationTests

- (void)setUp {
    self.URLRequestDownloader = [[SZURLRequestDownloader alloc] initWithURLRequest:[[self class] testURLRequest]];
    
    self.mockConnection = [OCMockObject mockForClass:[NSURLConnection class]];
}

- (void)disableAllConnections {
    [self disableClass:[NSURLConnection class]];
}

- (void)tearDown {
    [self.mockConnection verify];
    self.mockConnection = nil;
    self.partial = nil;
    self.URLRequestDownloader = nil;
}

- (void)becomePartial {
    if (self.partial == nil) {
        self.partial = [OCMockObject partialMockForObject:self.URLRequestDownloader];
    }
}

- (void)replaceConnectionProperty {
    [self becomePartial];
    REPLACE_PROPERTY(self.partial, connection, self.mockConnection, setConnection, self.realConnection);
}

- (void)testSuccessfulAPIOperation {
    NSDictionary *params = @{ @"udid": @"blah" };

    NSDictionary *responseDict = @{ @"item1_key": @"item1_value" };

    SZAPIOperation *operation = [[SZAPIOperation alloc] initWithConsumerKey:@"35ac50dd-b07c-463d-8de4-898447af738b" consumerSecret:@"7e8514ed-9acc-47a9-9721-2eac0afbf722" accessToken:nil accessTokenSecret:nil host:nil operationType:SZAPIOperationTypeAuthenticate parameters:params];
    operation.APICompletionBlock = ^(id result, NSError *error) {
        if (error != nil) {
            [self notify:kGHUnitWaitStatusFailure];
        } else {
            
            GHAssertEqualObjects(responseDict, result, @"Bad result");
            [self notify:kGHUnitWaitStatusSuccess];
        }
    };

    id mockResponse = [OCMockObject mockForClass:[NSHTTPURLResponse class]];
    
    NSData *responseData = [[responseDict JSONString] dataUsingEncoding:NSUTF8StringEncoding];

    id mockDownloader = [OCMockObject mockForClass:[SZURLRequestDownloader class]];
    [[mockDownloader expect] ]
    id mockDownloader = [SZURLRequestDownloaderTests completingMockDownloaderWithResponse:mockResponse data:responseData error:nil];
    [operation setMockURLRequestDownloader:mockDownloader];

    [self prepare];
    [self.operationQueue addOperation:operation];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:5];
}


@end
