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

NSString *const SZDefaultUDID = @"105f33d";

@interface SZAPIClient ()

@property (nonatomic, strong) SZAPIOperation *authOperation;
@property (nonatomic, strong) NSLock *authLock;

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

- (NSOperationQueue*)requestQueue {
    if (_requestQueue == nil) {
        _requestQueue = [[NSOperationQueue alloc] init];
        [_requestQueue setMaxConcurrentOperationCount:10];
    }
    
    return _requestQueue;
}

- (NSLock *)authLock {
    if (_authLock == nil) {
        _authLock = [[NSLock alloc] init];
    }
    
    return _authLock;
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

- (void)addOperation:(NSOperation*)operation {
    [[self requestQueue] addOperation:operation];
}

- (SZAPIOperation*)prepareOperation:(SZAPIOperation*)operation {
    [self.authLock lock];
    if (_authenticating) {
        [operation addDependency:self.authOperation];
    }
    [self.authLock unlock];
    
    return operation;
}

- (SZAPIOperation*)APIOperationForMethod:(NSString*)method
                                  scheme:(NSString*)scheme
                                    path:(NSString*)path
                              parameters:(id)parameters {
    
    SZAPIOperation *operation = [self _APIOperationForMethod:method scheme:scheme path:path parameters:parameters];
    return [self prepareOperation:operation];
}

- (SZAPIOperation*)APIOperationForOperationType:(SZAPIOperationType)operationType
                                     parameters:(id)parameters {
    
    SZAPIOperation *operation = [self _APIOperationForOperationType:operationType parameters:parameters];
    return [self prepareOperation:operation];
}

- (SZAPIOperation*)_APIOperationForMethod:(NSString*)method
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

- (SZAPIOperation*)_APIOperationForOperationType:(SZAPIOperationType)operationType
                                      parameters:(id)parameters {
    
    return [[SZAPIOperation alloc] initWithConsumerKey:self.consumerKey
                                        consumerSecret:self.consumerSecret
                                           accessToken:self.accessToken
                                     accessTokenSecret:self.accessTokenSecret
                                                  host:self.hostname operationType:operationType parameters:parameters];
                                                
    
}

- (SZAPIOperation*)addAPIOperationForMethod:(NSString*)method
                                  scheme:(NSString*)scheme
                                    path:(NSString*)path
                              parameters:(id)parameters {
    
    SZAPIOperation *operation = [self APIOperationForMethod:method scheme:scheme path:path parameters:parameters];
    [[self requestQueue] addOperation:operation];
    
    return operation;
}

- (SZAPIOperation*)addAPIOperationForOperationType:(SZAPIOperationType)operationType
                                 parameters:(id)parameters {
    
    SZAPIOperation *operation = [self APIOperationForOperationType:operationType parameters:parameters];
    [[self requestQueue] addOperation:operation];
    
    return operation;
}


- (SZAPIOperation*)authenticate {
    
    [self.authLock lock];
    
    if (_authenticating) {
        [self.authLock unlock];
        [[NSException exceptionWithName:@"AlreadyAuthenticating"
                                 reason:[NSString stringWithFormat:@"-[SZAPIOperation authenticate] called, but client %@ is already authenticating", self]
                               userInfo:nil] raise];
    }
    
    _authenticating = YES;


    NSDictionary *parameters = @{
        @"udid": self.udid,
    };
    
    __weak SZAPIOperation *authOperation = [self _APIOperationForOperationType:SZAPIOperationTypeAuthenticate
                                                      parameters:parameters];
    
    authOperation.internalSuccessBlock = ^(id response) {
        [self.authLock lock];
        self.accessToken = [response objectForKey:@"oauth_token"];
        self.accessTokenSecret = [response objectForKey:@"oauth_token_secret"];
        
        for (SZAPIOperation *operation in [self.requestQueue operations]) {
            if ([operation isKindOfClass:[SZAPIOperation class]] &&
                operation != authOperation &&
                (operation.accessToken == nil || operation.accessTokenSecret == nil)) {
                
                operation.accessToken = self.accessToken;
                operation.accessTokenSecret = self.accessTokenSecret;
            }
        }
        
        _authenticating = NO;
        self.authOperation = nil;
        [self.authLock unlock];
    };
    
    authOperation.internalFailureBlock = ^(NSError *error) {
        [self.authLock lock];
        _authenticating = NO;
        self.authOperation = nil;
        [self.authLock unlock];
    };

    self.authOperation = authOperation;
    [self.authLock unlock];

    [self.requestQueue addOperation:authOperation];
    

    return self.authOperation;
}

@end
