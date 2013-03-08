//
//  SZFakeAPIOperation.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 3/7/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "SZFakeAPIOperation.h"
#import "SZGlobal.h"

@implementation SZFakeAPIOperation

- (void)start {
    [self KVStartExecuting];
    BLOCK_CALL_2(self.APICompletionBlock, self.result, self.error);
    [self KVFinishAndStopExecuting];
}

@end