//
//  NSURLDownloader.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/7/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "SZURLRequestDownloader.h"
#import "SZGlobal.h"
#import "NSHTTPURLResponse+StringEncoding.h"
#import "SZURLRequestDownloader_private.h"

@interface SZURLRequestDownloader () {
    NSMutableData *_responseData;
    NSString *_responseString;
}
@end

@implementation SZURLRequestDownloader

- (id)initWithURLRequest:(NSURLRequest*)request {
    
    if (self = [super init]) {
        self.request = request;
    }
    
    return self;
}

- (NSMutableData*)responseData {
    if (_responseData == nil) {
        _responseData = [[NSMutableData alloc] init];
    }
    return _responseData;
}

- (void)start {
    if ([self isCancelled]) {
        return;
    }
    
    self.connection = [NSURLConnection connectionWithRequest:self.request delegate:self];
    [self.connection start];
}

- (void)cancel {
    self.cancelled = YES;
    [self.connection cancel];
    self.connection = nil;
}

- (void)failWithError:(NSError*)error {
    self.error = error;
    BLOCK_CALL_3(self.completionBlock, self.response, self.responseData, error);
}

- (void)succeedWithResult:(id)result {
    BLOCK_CALL_3(self.completionBlock, self.response, self.responseData, self.error);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self failWithError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if ([self.response isKindOfClass:[NSHTTPURLResponse class]] && [(NSHTTPURLResponse*)self.response statusCode] >= 400) {
        
        NSDictionary *userInfo = @{
                                   SZErrorURLResponseKey: self.response,
                                   SZErrorURLResponseBodyKey: self.responseData,
                                   };
        
        NSError *error = [[NSError alloc] initWithDomain:SZAPIClientErrorDomain code:SZAPIErrorCodeServerReturnedHTTPErrorStatus userInfo:userInfo];
        [self failWithError:error];
        return;
    }
    
    [self handleResponse];
}

- (void)handleResponse {
    [self succeedWithResult:self.responseString];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.response = (NSHTTPURLResponse*)response;
}

- (NSString *)responseString {
    if (_responseString == nil) {
        
        if ([self.response isKindOfClass:[NSHTTPURLResponse class]]) {
            _responseString = [(NSHTTPURLResponse*)self.response stringForResponseData:self.responseData];
        }
    }
    
    return _responseString;
}

@end