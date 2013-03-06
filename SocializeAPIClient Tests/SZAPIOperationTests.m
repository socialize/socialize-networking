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

@interface SZAPIOperationTests ()
@property (nonatomic, strong) SZAPIOperation *APIOperation;
@property (nonatomic, strong) id partial;
@property (nonatomic, strong) id mockDownloader;
@property (nonatomic, strong) SZURLRequestDownloader *realDownloader;
@end

@implementation SZAPIOperationTests

+ (NSString*)consumerKey {
    return @"aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa";
}

+ (NSString*)consumerSecret {
    return @"bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbbb";
}

+ (NSString*)testHost {
    return @"api.getsocialize.com";
}

- (void)setUp {
    self.mockDownloader = [OCMockObject mockForClass:[SZURLRequestDownloader class]];
}

- (void)createAPIOperation {
}

- (void)tearDown {
    [self.mockDownloader verify];

    self.mockDownloader = nil;
    self.partial = nil;
    self.APIOperation = nil;
}

- (void)becomePartial {
    if (self.partial == nil) {
        self.partial = [OCMockObject partialMockForObject:self.APIOperation];
    }
}

- (void)replaceDownloaderProperty {
    [self becomePartial];
    REPLACE_PROPERTY(self.partial, URLRequestDownloader, self.mockDownloader, setURLRequestDownloader, self.realDownloader);
}

- (void)completeDownloadWithResponseData:(NSMutableData*)responseData {
    [self replaceDownloaderProperty];
    
    WEAK(self) weakSelf = self;
    self.APIOperation.APICompletionBlock = ^(id result, NSError *error) {
#define self weakSelf
        if (error != nil) {
            [self notify:kGHUnitWaitStatusFailure];
        } else {
            [self notify:kGHUnitWaitStatusSuccess];
        }
#undef self
    };
    
    id mockResponse = [OCMockObject mockForClass:[NSHTTPURLResponse class]];
    
    [self.mockDownloader expectStartAndCompleteWithResponse:mockResponse data:responseData error:nil];
}

- (void)completeDownloadWithResponseString:(NSString*)string {
    [self completeDownloadWithResponseData:[[string dataUsingEncoding:NSUTF8StringEncoding] mutableCopy]];
}

- (void)completeDownloadWithResponseObject:(NSDictionary*)responseDict {
    [self completeDownloadWithResponseString:[responseDict JSONString]];
    
}

- (void)testSuccessfulAuthOperationUsingTypeInitialization {
    
    NSDictionary *params = @{ @"udid": @"blah" };
    self.APIOperation = [[SZAPIOperation alloc] initWithConsumerKey:[[self class] consumerKey] consumerSecret:[[self class] consumerSecret] accessToken:nil accessTokenSecret:nil host:[[self class] testHost] operationType:SZAPIOperationTypeAuthenticate parameters:params];
    
    [self completeDownloadWithResponseObject:@{}];

    [self prepare];
    [self.APIOperation start];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:0.5];
}

- (void)testSuccessfulAuthOperationUsingManualInitialization {
    
    NSDictionary *params = @{ @"udid": @"blah" };
    self.APIOperation = [[SZAPIOperation alloc] initWithConsumerKey:[[self class] consumerKey] consumerSecret:[[self class] consumerSecret] accessToken:nil accessTokenSecret:nil method:@"POST" scheme:@"https" host:[[self class] testHost] path:@"/v1/authenticate/" parameters:params];
    
    [self completeDownloadWithResponseObject:@{}];
    
    [self prepare];
    [self.APIOperation start];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:0.5];
}

- (void)testFailedOperation {
    
    NSDictionary *params = @{ @"udid": @"blah" };
    self.APIOperation = [[SZAPIOperation alloc] initWithConsumerKey:[[self class] consumerKey] consumerSecret:[[self class] consumerSecret] accessToken:nil accessTokenSecret:nil method:@"POST" scheme:@"https" host:[[self class] testHost] path:@"/v1/authenticate/" parameters:params];
    
    [self completeDownloadWithResponseObject:@{ @"errors": @[ @{@"k1": @"v1"} ] }];
    
    [self prepare];
    [self.APIOperation start];
    [self waitForStatus:kGHUnitWaitStatusFailure timeout:0.5];
    
    GHAssertNotNil(self.APIOperation.error, @"Should have error");
}

- (void)testInvalidJSONCausesCouldNotParseError {
    NSDictionary *params = @{ @"udid": @"blah" };
    self.APIOperation = [[SZAPIOperation alloc] initWithConsumerKey:[[self class] consumerKey] consumerSecret:[[self class] consumerSecret] accessToken:nil accessTokenSecret:nil method:@"POST" scheme:@"https" host:[[self class] testHost] path:@"/v1/authenticate/" parameters:params];

    [self completeDownloadWithResponseString:@"Hello, there"];

    [self prepare];
    [self.APIOperation start];
    [self waitForStatus:kGHUnitWaitStatusFailure timeout:0.5];
    
    NSError *error = self.APIOperation.error;
    GHAssertTrue([error code] == SZAPIErrorCodeCouldNotParseServerResponse, @"Bad error");
}

- (void)testNilHostHasDefaultHost {
    NSDictionary *params = @{ @"udid": @"blah" };
    self.APIOperation = [[SZAPIOperation alloc] initWithConsumerKey:[[self class] consumerKey] consumerSecret:[[self class] consumerSecret] accessToken:nil accessTokenSecret:nil method:@"POST" scheme:@"https" host:[[self class] testHost] path:@"/v1/authenticate/" parameters:params];
    NSURL *url = self.APIOperation.request.URL;
    
    GHAssertNotNil(url, @"Should have valid URL");
}

- (void)testRequestWithNullParams {
    self.APIOperation = [[SZAPIOperation alloc] initWithConsumerKey:[[self class] consumerKey] consumerSecret:[[self class] consumerSecret] accessToken:nil accessTokenSecret:nil method:@"POST" scheme:@"https" host:[[self class] testHost] path:@"/v1/authenticate/" parameters:nil];

    [self completeDownloadWithResponseObject:@{}];
    
    [self prepare];
    [self.APIOperation start];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:0.5];
}

- (void)testRequestWithNullHost {
    self.APIOperation = [[SZAPIOperation alloc] initWithConsumerKey:[[self class] consumerKey] consumerSecret:[[self class] consumerSecret] accessToken:nil accessTokenSecret:nil method:@"POST" scheme:@"https" host:[[self class] testHost] path:@"/v1/authenticate/" parameters:nil];
    
    [self completeDownloadWithResponseObject:@{}];
    
    [self prepare];
    [self.APIOperation start];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:0.5];
}

@end
