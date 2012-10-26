//
//  SZOARequest.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 10/29/12.
//  Copyright (c) 2012 Nate Griswold. All rights reserved.
//

#import "SZOARequest.h"
#import "GCOAuth+Socialize.h"

@interface SZOARequest ()
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSMutableString *responseString;

@property (nonatomic, assign, getter=isExecuting) BOOL executing;
@property (nonatomic, assign, getter=isFinished) BOOL finished;

@end

@implementation SZOARequest

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

- (void)finish {
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    _executing = NO;
    _finished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)start {
    if ([self isCancelled]) {
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    self.connection = [NSURLConnection connectionWithRequest:self.request delegate:self];
    [self.connection start];
}

- (void)cancel {
    [self.connection cancel];
    [self finish];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self finish];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.response = (NSHTTPURLResponse*)response;
    [self finish];
}

- (NSStringEncoding)stringEncodingForURLResponse:(NSHTTPURLResponse*)response {
    NSStringEncoding encoding = NSISOLatin1StringEncoding;
    NSString *contentType = [[[response allHeaderFields] objectForKey:@"Content-Type"] lowercaseString];
    if (contentType && [contentType rangeOfString:@"charset=utf-8"].location != NSNotFound) {
        encoding = NSUTF8StringEncoding;
    }
    
    return encoding;
}

- (NSString*)stringForHTTPURLResponse:(NSHTTPURLResponse*)response data:(NSData*)data {
    NSStringEncoding encoding = [self stringEncodingForURLResponse:response];
    return [[NSString alloc] initWithData:data encoding:encoding];
}

- (NSString *)responseString {
    if (_responseString == nil) {
        _responseString = [self stringForHTTPURLResponse:self.response data:self.responseData];
    }
    
    return _responseString;
}

@end
