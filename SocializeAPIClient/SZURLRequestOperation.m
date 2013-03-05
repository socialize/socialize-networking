
#import "SZURLRequestOperation.h"
#import "SZGlobal.h"
#import "NSMutableURLRequest+Socialize.h"
#import "NSHTTPURLResponse+StringEncoding.h"
#import "NSData+JSONHelpers.h"
#import "SZURLRequestOperation_private.h"
#import "SZURLRequestDownloader.h"

@interface SZURLRequestOperation ()


@end

@implementation SZURLRequestOperation

- (id)initWithURLRequest:(NSMutableURLRequest*)request {
    
    if (self = [super init]) {
        self.request = request;
    }
    
    return self;
}

- (void)downloadCompletionWithResponse:(NSURLResponse*)response data:(NSMutableData*)data error:(NSError*)error {
    self.response = response;
    self.responseData = data;
    self.error = error;
    [self callCompletion];
    [self KVFinishAndStopExecuting];
}

- (void)failWithError:(NSError*)error {
    self.error = error;
    self.didFail = YES;
    [self callCompletion];
    [self KVFinishAndStopExecuting];
}

- (void)startConnection {
    if ([self isCancelled]) {
        [self KVFinishAndStopExecuting];
        return;
    }
    
    WEAK(self) weakSelf = self;
    self.URLRequestDownloader = [[SZURLRequestDownloader alloc] initWithURLRequest:self.request];
    self.URLRequestDownloader.completionBlock = ^(NSURLResponse *response, NSData *data, NSError *error) {
        [weakSelf downloadCompletionWithResponse:response data:data error:error];
    };
    [self.URLRequestDownloader start];
}

- (void)start {
    if ([self isCancelled]) {
        [self KVFinish];
        return;
    }
    
    // Check for failed dependencies
    NSError *error = [self failedDependenciesError];
    if (error != nil) {
        self.error = error;
        [self callCompletion];
        [self KVFinish];
        return;
    }

    [self KVStartExecuting];
    [self performSelectorOnMainThread:@selector(startConnection) withObject:nil waitUntilDone:NO];
}

- (void)cancel {
    [self.URLRequestDownloader cancel];
    self.URLRequestDownloader = nil;
    
    [super cancel];
}

- (void)callCompletion {
    BLOCK_CALL_3(self.URLCompletionBlock, self.response, self.responseData, self.error);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@ / %@", [self class], self.request];
}

@end
