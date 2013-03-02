//
//  SZOperation.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/8/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "SZOperation.h"
#import "SZGlobal.h"

@implementation SZOperation

- (NSError*)failedDependenciesError {
    NSArray *failedDependencies = [self failedDependencies];
    if ([failedDependencies count] == 0) {
        return nil;
    }
    
    NSDictionary *userInfo = @{
        SZErrorFailedDependenciesKey: failedDependencies,
    };
    
    return [[NSError alloc] initWithDomain:SZAPIClientErrorDomain code:SZAPIErrorOperationHasFailedDependencies userInfo:userInfo];
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


@end
