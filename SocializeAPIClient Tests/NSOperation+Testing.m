//
//  NSOperation+Testing.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 3/1/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "NSOperation+Testing.h"
#import "NSOperation+AdditionalCompletion.h"
#import "SZGlobal.h"

@implementation NSOperation (Testing)

- (void)simulateCompletion {
    BLOCK_CALL(self.completionBlock);
    for (void(^completionBlock)() in [self completionBlocks]) {
        completionBlock();
    }
}

@end
