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

- (void)testSuccessfulAuthOperation {
    
    NSDictionary *params = @{ @"udid": @"blah" };
    self.APIOperation = [[SZAPIOperation alloc] initWithConsumerKey:[[self class] consumerKey] consumerSecret:[[self class] consumerSecret] accessToken:nil accessTokenSecret:nil host:[[self class] testHost] operationType:SZAPIOperationTypeAuthenticate parameters:params];
    
    [self replaceDownloaderProperty];

    NSDictionary *responseDict = @{ @"item1_key": @"item1_value" };

    WEAK(self) weakSelf = self;
    self.APIOperation.APICompletionBlock = ^(id result, NSError *error) {
#define self weakSelf
        if (error != nil) {
            [self notify:kGHUnitWaitStatusFailure];
        } else {
            
            GHAssertEqualObjects(responseDict, result, @"Bad result");
            [self notify:kGHUnitWaitStatusSuccess];
        }
#undef self
    };

    id mockResponse = [OCMockObject mockForClass:[NSHTTPURLResponse class]];
    
    NSMutableData *responseData = [[[responseDict JSONString] dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];

    [self.mockDownloader expectStartAndCompleteWithResponse:mockResponse data:responseData error:nil];

    [self prepare];
    [self.APIOperation start];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:0.5];
}


@end
