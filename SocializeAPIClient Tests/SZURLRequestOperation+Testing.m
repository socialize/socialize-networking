//
//  SZURLRequestOperation+Testing.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 3/5/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "SZURLRequestOperation+Testing.h"

@implementation SZURLRequestOperation (Testing)

@end

@implementation OCMockObject (SZURLRequestOperationTesting)

- (void)expectStartAndCompleteWithResponse:(NSURLResponse*)response data:(NSMutableData*)data error:(NSError*)error {
    
    __block void (^localCompletionBlock)(NSURLResponse*, NSMutableData*, NSError*) = nil;

    [[[self stub] andDo1:^(id completionBlock) {
        localCompletionBlock = completionBlock;
    }] setCompletionBlock:OCMOCK_ANY];
    
    [(SZURLRequestDownloader*)[[self expect] andDo0:^{
        localCompletionBlock(response, data, error);
    }] start];
}

@end
