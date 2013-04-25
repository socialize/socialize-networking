
#import "SZURLRequestOperation.h"
#import "SZGlobal.h"
#import "NSHTTPURLResponse+StringEncoding.h"
#import "NSData+JSONHelpers.h"
#import "SZURLRequestOperation_private.h"
#import "SZURLRequestDownloader.h"
#import "SZConcurrentOperation_private.h"

@interface SZURLRequestOperation () {
    NSObject *_stateLock;
}

@end

@implementation SZURLRequestOperation

- (id)initWithURLRequest:(NSMutableURLRequest*)request {
    
    if (self = [super init]) {
        _stateLock = [[NSObject alloc] init];
        self.request = request;
    }
    
    return self;
}

- (void)downloadCompletionWithResponse:(NSURLResponse*)response data:(NSMutableData*)data error:(NSError*)error {
    self.response = response;
    self.responseData = data;
    self.error = error;
    [self callCompletion];
    [self KVStop];
}

- (void)failWithError:(NSError*)error {
    self.error = error;
    self.didFail = YES;
    [self callCompletion];
    [self KVStop];
}

- (void)start {
    
    @synchronized(_stateLock) {
        if ([self isCancelled]) {
            return;
        }
        
        // Check for failed dependencies
        NSError *error = [self failedDependenciesError];
        if (error != nil) {
            [self failWithError:error];
            return;
        }

        [self KVStart];
        
        WEAK(self) weakSelf = self;
        self.URLRequestDownloader = [[SZURLRequestDownloader alloc] initWithURLRequest:self.request];
        self.URLRequestDownloader.completionBlock = ^(NSURLResponse *response, NSData *data, NSError *error) {
            [weakSelf downloadCompletionWithResponse:response data:data error:error];
        };
        [self.URLRequestDownloader start];
    }
}

- (void)cancel {
    @synchronized(_stateLock) {
    
        if (_executing) {
            [self.URLRequestDownloader cancel];
            self.URLRequestDownloader = nil;
            
        }
        
        [self KVCancel];
        [self KVStop];
    }
}

- (void)callCompletion {
    BLOCK_CALL_3(self.URLCompletionBlock, self.response, self.responseData, self.error);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@ / %@", [self class], self.request];
}

@end
