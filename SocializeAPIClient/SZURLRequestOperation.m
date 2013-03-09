
#import "SZURLRequestOperation.h"
#import "SZGlobal.h"
#import "NSMutableURLRequest+Socialize.h"
#import "NSHTTPURLResponse+StringEncoding.h"
#import "NSData+JSONHelpers.h"
#import "SZURLRequestOperation_private.h"
#import "SZURLRequestDownloader.h"

@interface SZConcurrentOperation () {
    @protected BOOL _executing;
}
@property (nonatomic, assign, getter=isExecuting) BOOL executing;
@property (nonatomic, assign, getter=isFinished) BOOL finished;
@property (nonatomic, assign, getter=isCancelled) BOOL cancelled;
@end


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
    [self KVFinishAndStopExecuting];
}

- (void)failWithError:(NSError*)error {
    self.error = error;
    self.didFail = YES;
    [self callCompletion];
    [self KVFinishAndStopExecuting];
}

- (void)startConnection {
    [self.URLRequestDownloader start];
}

- (void)start {
    
    @synchronized(_stateLock) {
        if ([self isCancelled]) {
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
        
        WEAK(self) weakSelf = self;
        self.URLRequestDownloader = [[SZURLRequestDownloader alloc] initWithURLRequest:self.request];
        self.URLRequestDownloader.completionBlock = ^(NSURLResponse *response, NSData *data, NSError *error) {
            SZURLRequestDownloader *downloader = weakSelf.URLRequestDownloader;
            (void)downloader;
            [weakSelf downloadCompletionWithResponse:response data:data error:error];
        };

        [self performSelectorOnMainThread:@selector(startConnection) withObject:nil waitUntilDone:YES];
    }
}

- (void)cancel {
    @synchronized(_stateLock) {
        [self KVCancel];
        
        if (_executing) {
            [self.URLRequestDownloader cancel];
            self.URLRequestDownloader = nil;

            [self KVStopExecuting];
        }
        
        if (!self.isFinished) {
            [self KVFinish];
        }
    }
}

- (void)callCompletion {
    BLOCK_CALL_3(self.URLCompletionBlock, self.response, self.responseData, self.error);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@ / %@", [self class], self.request];
}

@end
