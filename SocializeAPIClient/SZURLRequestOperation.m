
#import "SZURLRequestOperation.h"
#import "SZGlobal.h"
#import "NSURLRequest+Socialize.h"
#import "NSHTTPURLResponse+StringEncoding.h"
#import "NSData+JSONHelpers.h"
#import "SZURLRequestOperation_private.h"

@interface SZURLRequestOperation ()
@property (nonatomic, copy) void (^internalSuccessBlock)(id result);
@property (nonatomic, copy) void (^internalFailureBlock)(NSError *error);

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSMutableString *responseString;

@property (nonatomic, assign, getter=isExecuting) BOOL executing;
@property (nonatomic, assign, getter=isFinished) BOOL finished;

@end

@implementation SZURLRequestOperation

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

- (void)stopExecuting {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = NO;
    [self didChangeValueForKey:@"isExecuting"];    
}

- (void)startExecuting {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)finish {
    [self willChangeValueForKey:@"isFinished"];
    _finished = YES;
    [self didChangeValueForKey:@"isFinished"];    
}

- (void)finishAndStopExecuting {
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    _executing = NO;
    _finished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (NSArray*)failedDependencies {
    NSMutableArray *failedDependencies = [NSMutableArray array];
    for (SZURLRequestOperation *operation in self.dependencies) {
        if (![operation isKindOfClass:[SZURLRequestOperation class]])
            continue;
        
        if (operation.error != nil) {
            [failedDependencies addObject:operation];
        }
    }

    return failedDependencies;
}

- (void)start {
    if ([self isCancelled]) {
        [self finish];
        return;
    }
    
    // Check for failed dependencies
    NSArray *failedDependencies = [self failedDependencies];
    if ([failedDependencies count] > 0) {
        NSDictionary *userInfo = @{
            SZErrorFailedDependenciesKey: failedDependencies,
        };

        NSError *error = [[NSError alloc] initWithDomain:SZAPIClientErrorDomain code:SZAPIErrorOperationHasFailedDependencies userInfo:userInfo];
        [self failWithError:error];
        [self finish];
        return;
    }

    [self startExecuting];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self isCancelled]) {
            [self finishAndStopExecuting];
            return;
        }
        self.connection = [NSURLConnection connectionWithRequest:self.request delegate:self];
        [self.connection start];
    });
}

- (void)cancel {
    [self.connection cancel];
    self.connection = nil;
    
    [super cancel];
}

- (void)failWithError:(NSError*)error {
    self.error = error;
    BLOCK_CALL_1(self.internalFailureBlock, error);
    BLOCK_CALL_1(self.failureBlock, error);
}

- (void)succeedWithResult:(id)result {
    BLOCK_CALL_1(self.successBlock, result);
    BLOCK_CALL_1(self.internalSuccessBlock, result);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self failWithError:error];
    [self finishAndStopExecuting];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

    if ([self.response statusCode] >= 400) {
        
        NSDictionary *userInfo = @{
            SZErrorHTTPURLResponseKey: self.response,
            SZErrorHTTPURLResponseBodyKey: self.responseString,
        };
        
        NSError *error = [[NSError alloc] initWithDomain:SZAPIClientErrorDomain code:SZAPIErrorCodeServerReturnedHTTPErrorStatus userInfo:userInfo];
        [self failWithError:error];
        [self finishAndStopExecuting];
        return;
    }
    
    [self handleResponse];
}

- (void)handleResponse {
    [self succeedWithResult:self.responseString];
    [self finishAndStopExecuting];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.response = (NSHTTPURLResponse*)response;
}

- (NSString *)responseString {
    if (_responseString == nil) {
        _responseString = [self.response stringForResponseData:self.responseData];
    }
    
    return _responseString;
}

@end
