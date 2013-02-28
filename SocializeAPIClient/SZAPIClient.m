//
//  SZAPIClient.m
//  SocializeAPIClient
//
//  Created by Nathaniel Griswold on 10/31/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZAPIClient.h"
#import "SZGlobal.h"
#import "SZAPIOperation.h"
#import "SZURLRequestOperation_private.h"
#import "NSOperation+AdditionalCompletion.h"
#import "NSMutableURLRequest+OAuth.h"
#import "SZAPIOperation_private.h"
#import "NSOperationQueue+BlockingOperation.h"

@interface SZAPIClient () {
    BOOL _authenticating;
}

@property (nonatomic, strong) NSRecursiveLock *authLock;

@end

@implementation SZAPIClient

+ (NSString *)defaultHost {
    return [SZAPIOperation defaultHost];
}

+ (NSString*)defaultUDID {
    return SZDefaultUDID;
}

- (id)initWithConsumerKey:(NSString *)consumerKey
           consumerSecret:(NSString *)consumerSecret
              accessToken:(NSString *)accessToken
        accessTokenSecret:(NSString *)accessTokenSecret {
    
    if (self = [super init]) {
        self.consumerKey = consumerKey;
        self.consumerSecret = consumerSecret;
        self.accessToken = accessToken;
        self.accessTokenSecret = accessTokenSecret;
    }
    
    return self;
}

- (id)initWithConsumerKey:(NSString *)consumerKey
           consumerSecret:(NSString *)consumerSecret {
    
    return [self initWithConsumerKey:consumerKey consumerSecret:consumerSecret accessToken:nil accessTokenSecret:nil];
}

- (BOOL)isAuthenticated {
    return [self.accessToken length] > 0 && [self.accessTokenSecret length] > 0;
}

- (NSOperationQueue*)operationQueue {
    if (_operationQueue == nil) {
        _operationQueue = [[NSOperationQueue alloc] init];
        [_operationQueue setMaxConcurrentOperationCount:10];
    }
    
    return _operationQueue;
}

- (NSString*)hostname {
    if (_hostname == nil) {
        _hostname = [[self class] defaultHost];
    }
    
    return _hostname;
}

- (NSString *)udid {
    if (_udid == nil) {
        _udid = [[self class] defaultUDID];
    }
    
    return _udid;
}

- (void)_addOperations:(NSArray*)operations waitUntilFinished:(BOOL)wait blocking:(BOOL)blocking {
    [self authenticateIfNeeded];

    for (SZAPIOperation *operation in operations) {
        if ([operation isKindOfClass:[SZAPIOperation class]]) {
            operation.APIClient = self;
        }
    }
    
    if (blocking) {
        WEAK(self) weakSelf = self;
        [self.operationQueue addBlockingOperations:operations waitUntilFinished:wait dontBlock:^BOOL(NSOperation *otherOperation) {
            return ![otherOperation isKindOfClass:[SZAPIOperation class]] || [(SZAPIOperation*)otherOperation APIClient] != weakSelf;
        }];
        
    } else {
        [self.operationQueue addOperations:operations waitUntilFinished:wait];
    }
}

- (void)addOperations:(NSArray*)operations waitUntilFinished:(BOOL)wait {
    [self _addOperations:operations waitUntilFinished:wait blocking:NO];
}

- (void)addOperation:(NSOperation*)operation {
    [self addOperations:@[operation] waitUntilFinished:NO];
}

- (void)addBlockingOperations:(NSArray*)operations waitUntilFinished:(BOOL)wait {

    [self _addOperations:operations waitUntilFinished:wait blocking:YES];
}

- (void)addBlockingOperation:(NSOperation*)operation {
    [self addBlockingOperations:@[operation] waitUntilFinished:NO];
}

- (void)authenticateIfNeeded {
    [self.authLock lock];
    if (!_authenticating && (self.accessToken == nil || self.accessTokenSecret == nil)) {
        [self authenticate];
    }
    [self.authLock unlock];
}

- (SZAPIOperation*)authenticate {
    
    [self.authLock lock];
    _authenticating = YES;
    [self.authLock unlock];

    NSDictionary *parameters = @{
        @"udid": self.udid,
    };
    
    SZAPIOperation *authOperation = [self APIOperationForOperationType:SZAPIOperationTypeAuthenticate
                                                            parameters:parameters];
    
    WEAK(authOperation) weakAuthOperation = authOperation;
    [authOperation addCompletionBlock:^{
        [self updateAuthorizationInfoFromAuthOperation:weakAuthOperation];
    }];
    
    [self addBlockingOperation:authOperation];
    
    return authOperation;
}

- (SZAPIOperation*)APIOperationForMethod:(NSString*)method
                                  scheme:(NSString*)scheme
                                    path:(NSString*)path
                              parameters:(id)parameters {
    
    return [[SZAPIOperation alloc] initWithConsumerKey:self.consumerKey
                                        consumerSecret:self.consumerSecret
                                           accessToken:self.accessToken
                                     accessTokenSecret:self.accessTokenSecret
                                                method:method
                                                scheme:scheme
                                                  host:self.hostname
                                                  path:path
                                            parameters:parameters];
    
}

- (SZAPIOperation*)APIOperationForOperationType:(SZAPIOperationType)operationType
                                     parameters:(id)parameters {
    
    return [[SZAPIOperation alloc] initWithConsumerKey:self.consumerKey
                                        consumerSecret:self.consumerSecret
                                           accessToken:self.accessToken
                                     accessTokenSecret:self.accessTokenSecret
                                                  host:self.hostname
                                         operationType:operationType
                                            parameters:parameters];
}

- (SZAPIOperation*)addAPIOperationForMethod:(NSString*)method
                                     scheme:(NSString*)scheme
                                       path:(NSString*)path
                                 parameters:(id)parameters {
    
    SZAPIOperation *operation = [self APIOperationForMethod:method scheme:scheme path:path parameters:parameters];
    [self addOperation:operation];
    
    return operation;
}

- (SZAPIOperation*)addAPIOperationForOperationType:(SZAPIOperationType)operationType
                                        parameters:(id)parameters {
    
    SZAPIOperation *operation = [self APIOperationForOperationType:operationType parameters:parameters];
    [self addOperation:operation];
    
    return operation;
}

- (void)updateAuthorizationInfoFromAuthOperation:(SZAPIOperation*)authOperation {
    [self.authLock lock];
    _authenticating = NO;
    self.accessToken = [authOperation.result objectForKey:@"oauth_token"];
    self.accessTokenSecret = [authOperation.result objectForKey:@"oauth_token_secret"];
    [self.authLock unlock];
    
    for (SZAPIOperation *operation in self.operationQueue.operations) {
        if ([operation isKindOfClass:[SZAPIOperation class]] && operation.APIClient == self && operation != authOperation) {
            [operation.request setAuthorizationHeaderWithConsumerKey:self.consumerKey consumerSecret:self.consumerSecret token:self.accessToken tokenSecret:self.accessTokenSecret];
        }
    }
}

@end
