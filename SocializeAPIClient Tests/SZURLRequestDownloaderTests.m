//
//  SZURLRequestDownloaderTests.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/8/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "SZURLRequestDownloaderTests.h"

@implementation SZURLRequestDownloaderTests

- (void)dealloc {
    
}

+ (id)completingMockDownloaderWithResponse:(NSURLResponse*)response data:(NSData*)data error:(NSError*)error {
    __block void (^localCompletionBlock)(NSURLResponse *response, NSData *data, NSError *error);
    
    id mockDownloader = [OCMockObject mockForClass:[SZURLRequestDownloader class]];
    [(SZURLRequestDownloader*)[[mockDownloader stub] andDo0:^{
        localCompletionBlock(response, data, error);
    }] start];
    
    [[[mockDownloader stub] andDo1:^(id completionBlock) {
        localCompletionBlock = completionBlock;
    }] setCompletionBlock:OCMOCK_ANY];
    
    return mockDownloader;
}

- (void)testSuccessfulDownload {

    NSURL *testURL = [NSURL URLWithString:@"http://api.getsocialize.com"];
    NSDictionary *responseHeaders = @{@"Content-type": @"text/html;charset=utf-8"};
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:testURL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:responseHeaders];

    NSURLRequest *request = [NSURLRequest requestWithURL:testURL];
    self.URLRequestDownloader = [[SZURLRequestDownloader alloc] initWithURLRequest:request];
    
    NSArray *chunks = @[ [@"He" dataUsingEncoding:NSUTF8StringEncoding], [@"llo" dataUsingEncoding:NSUTF8StringEncoding] ];
    
    WEAK(self) weakSelf = self;
    self.URLRequestDownloader.completionBlock = ^(NSURLResponse *response, NSData *data, NSError *error) {
#define self weakSelf
        NSString *responseString = [(NSHTTPURLResponse*)response stringForResponseData:data];
        
        GHAssertEqualStrings(responseString, @"Hello", @"Bad response string");
        
        [self notify:kGHUnitWaitStatusSuccess];
#undef self
    };
    
    [NSURLConnection startMockingClass];
    [[NSURLConnection origClass] expectRequestWithCheck:^BOOL(NSURLRequest *request) {
        return [request.URL isEqual:testURL];
    } response:response chunks:chunks];
    [self prepare];
    [self.URLRequestDownloader start];

    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:2];
}

- (void)testFailedDownload {
    
    NSURL *testURL = [NSURL URLWithString:@"http://api.getsocialize.com"];
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:testURL statusCode:404 HTTPVersion:@"HTTP/1.1" headerFields:nil];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:testURL];
    self.URLRequestDownloader = [[SZURLRequestDownloader alloc] initWithURLRequest:request];
    
    WEAK(self) weakSelf = self;
    self.URLRequestDownloader.completionBlock = ^(NSURLResponse *response, NSData *data, NSError *error) {
#define self weakSelf
        GHAssertNotNil(error, @"Expected error");
        [self notify:kGHUnitWaitStatusSuccess];
#undef self
    };
    
    [NSURLConnection startMockingClass];
    [[NSURLConnection origClass] expectRequestWithCheck:^BOOL(NSURLRequest *request) {
        return [request.URL isEqual:testURL];
    } response:response chunks:nil];
    [self prepare];
    [self.URLRequestDownloader start];
    
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:2];
}

@end
