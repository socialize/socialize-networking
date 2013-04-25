//
//  SZOperation.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/8/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "SZOperation.h"
#import "SZGlobal.h"

@interface SZOperation () {
    NSMutableArray *_completionBlocks;
}

@end

@implementation SZOperation

- (id)init {
    if (self = [super init]) {
        
        WEAK(self) weakSelf = self;
        self.completionBlock = ^{
            for (void(^completionBlock)() in weakSelf.completionBlocks) {
                completionBlock();
            }
        };
    }
    
    return self;
}
- (NSError*)failedDependenciesError {
    NSArray *failedDependencies = [self failedDependencies];
    if ([failedDependencies count] == 0) {
        return nil;
    }
    
    NSDictionary *userInfo = @{
        SZErrorFailedDependenciesKey: failedDependencies,
    };
    
    return [[NSError alloc] initWithDomain:SZNetworkingErrorDomain code:SZNetworkingErrorOperationHasFailedDependencies userInfo:userInfo];
}

- (NSArray*)failedDependencies {
    NSMutableArray *failedDependencies = [NSMutableArray array];
    for (id<SZFallibleOperation> operation in self.dependencies) {
        if (![operation conformsToProtocol:@protocol(SZFallibleOperation)])
            continue;
        
        if (operation.didFail) {
            [failedDependencies addObject:operation];
        }
    }
    
    return failedDependencies;
}

- (NSMutableArray*)completionBlocks {
    
    if (_completionBlocks == nil) {
        _completionBlocks = [[NSMutableArray alloc] init];
    }
    
    return _completionBlocks;
}

- (void)addCompletionBlock:(void(^)())completionBlock {
    [self.completionBlocks addObject:completionBlock];
}

@end
