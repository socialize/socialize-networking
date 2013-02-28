//
//  NSOperationQueue+BlockingOperation.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/25/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "NSOperationQueue+BlockingOperation.h"
#import "NSObject+JRSwizzle.h"
#import <objc/runtime.h>
#import "NSOperation+AdditionalCompletion.h"
#import "SZGlobal.h"

static const char *DoNotBlockBlockKey = "DoNotBlockBlockKey";

@interface NSOperation (BlockingOperation)
@property (nonatomic, copy) BOOL (^doNotBlockBlock)(NSOperation *operation);
@end

@implementation NSOperation (BlockingOperation)

- (BOOL (^)(NSOperation *operation))doNotBlockBlock {
    return objc_getAssociatedObject(self, DoNotBlockBlockKey);
}

- (void)setDoNotBlockBlock:(BOOL(^)(NSOperation *operation))doNotBlockBlock {
    objc_setAssociatedObject(self, DoNotBlockBlockKey, doNotBlockBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

static const char *BlockingOperationsKey = "BlockingOperationsKey";

@implementation NSOperationQueue (BlockingOperation)

+ (void)load {
    NSError *error = nil;
    NSAssert([self sz_jr_swizzleMethod:@selector(addOperation:) withMethod:@selector(_BlockingOperation_addOperation:) error:&error], @"Swizzle failed %@", error);
    NSAssert([self sz_jr_swizzleMethod:@selector(addOperations:waitUntilFinished:) withMethod:@selector(_BlockingOperation_addOperations:waitUntilFinished:) error:&error], @"Swizzle failed %@", error);
}

- (NSMutableSet*)blockingOperations {
    
     NSMutableSet *blockingOperations = objc_getAssociatedObject(self, BlockingOperationsKey);
    
    if (blockingOperations == nil) {
        blockingOperations = [NSMutableSet set];
        objc_setAssociatedObject(self, BlockingOperationsKey, blockingOperations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return blockingOperations;
}

- (void)addBlockingDependencies:(NSArray*)ops {
    @synchronized(self) {
        for (NSOperation *newOperation in ops) {
            for (NSOperation *blockingOperation in [self blockingOperations]) {
                
                BOOL doNotBlock = blockingOperation.doNotBlockBlock && blockingOperation.doNotBlockBlock(newOperation);
                if (newOperation != blockingOperation && !doNotBlock) {
                    [newOperation addDependency:blockingOperation];
                }
            }
        }
    }
}

- (void)_BlockingOperation_addOperation:(NSOperation *)op {
    [self addBlockingDependencies:@[op]];
    [self _BlockingOperation_addOperation:op];
}

- (void)_BlockingOperation_addOperations:(NSArray *)ops waitUntilFinished:(BOOL)wait {
    [self addBlockingDependencies:ops];
    [self _BlockingOperation_addOperations:ops waitUntilFinished:wait];
}

- (void)addBlockingOperations:(NSArray*)operations waitUntilFinished:(BOOL)wait dontBlock:(BOOL(^)(NSOperation *otherOperation))dontBlock {

    
    @synchronized(self) {
        [[self blockingOperations] addObjectsFromArray:operations];
    }

    for (NSOperation *operation in operations) {
        operation.doNotBlockBlock = dontBlock;
        
        WEAK(operation) weakOperation = operation;
        [operation addCompletionBlock:^{
            [[self blockingOperations] removeObject:weakOperation];
        }];
    }
    
    [self addOperations:operations waitUntilFinished:wait];
}

- (void)addBlockingOperation:(NSOperation*)operation dontBlock:(BOOL(^)(NSOperation *otherOperation))dontBlock {
    [self addBlockingOperations:@[operation] waitUntilFinished:NO dontBlock:dontBlock];
}

@end