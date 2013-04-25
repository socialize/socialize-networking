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

static NSThread *connectionThread;

@interface SZURLRequestDownloader () {
    NSMutableData *_responseData;
    NSString *_responseString;
    NSObject *_stateLock;
}

@end

@implementation SZURLRequestDownloader

+ (void)load {
    [[self connectionThread] start];
}

+ (void)runConnectionThread {
    NSTimer *dummy = [[NSTimer alloc] initWithFireDate:[NSDate distantFuture] interval:0 target:nil selector:NULL userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:dummy forMode:NSDefaultRunLoopMode];
    
    while ([[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]) {
    }
}

+ (NSThread*)connectionThread {
    if (connectionThread == nil) {
        connectionThread = [[NSThread alloc] initWithTarget:self selector:@selector(runConnectionThread) object:nil];
    }
    return connectionThread;
}

- (id)initWithURLRequest:(NSURLRequest*)request {
    
    if (self = [super init]) {
        _stateLock = [[NSObject alloc] init];
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

- (void)startConnection {
    self.connection = [NSURLConnection connectionWithRequest:self.request delegate:self];
    [self.connection start];
}

- (void)cancelConnection {
    [self.connection cancel];
    self.connection = nil;
}

- (void)start {

    @synchronized(_stateLock) {
        if (_cancelled) {
            return;
        }
        
        [self performSelector:@selector(startConnection) onThread:[[self class] connectionThread] withObject:nil waitUntilDone:YES];
    }
}

- (void)cancel {
    
    @synchronized(_stateLock) {
        _cancelled = YES;
        [self performSelector:@selector(cancelConnection) onThread:[[self class] connectionThread] withObject:nil waitUntilDone:YES];
    }
}

- (void)_failWithError:(NSError*)error {
    self.error = error;
    BLOCK_CALL_3(self.completionBlock, self.response, self.responseData, error);
}

- (void)failWithError:(NSError*)error {
    @synchronized(_stateLock) {
        [self performSelectorOnMainThread:@selector(_failWithError:) withObject:error waitUntilDone:YES];
    }
}

- (void)_succeed {
    BLOCK_CALL_3(self.completionBlock, self.response, self.responseData, self.error);
}

- (void)succeed {
    @synchronized(_stateLock) {
        [self performSelectorOnMainThread:@selector(_succeed) withObject:nil waitUntilDone:YES];
    }
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
        
        NSError *error = [[NSError alloc] initWithDomain:SZNetworkingErrorDomain code:SZNetworkingErrorCodeServerReturnedHTTPErrorStatus userInfo:userInfo];
        [self failWithError:error];
        return;
    }
    
    [self succeed];
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