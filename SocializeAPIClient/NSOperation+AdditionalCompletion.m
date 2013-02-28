//
//  NSOperation+AdditionalCompletion.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/26/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "NSOperation+AdditionalCompletion.h"
#import "NSObject+JRSwizzle.h"
#import <objc/runtime.h>

static const char *CompletionBlocksKey = "CompletionBlocksKey";

@implementation NSOperation (AdditionalCompletion)

- (void)addCompletionBlock:(void(^)())completionBlock {
    [[self completionBlock] addObject:completionBlock];
}

- (NSMutableArray*)completionBlocks {
    
    NSMutableArray *completionBlocks = objc_getAssociatedObject(self, CompletionBlocksKey);
    
    if (completionBlocks == nil) {
        completionBlocks = [NSMutableArray array];
        objc_setAssociatedObject(self, CompletionBlocksKey, completionBlocks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return completionBlocks;
}

@end

@implementation NSOperationQueue (AdditionalCompletion)

+ (void)load {
    NSError *error = nil;
    NSAssert([self sz_jr_swizzleMethod:@selector(addOperation:) withMethod:@selector(_AdditionalCompletion_addOperation:) error:&error], @"Swizzle failed %@", error);
    NSAssert([self sz_jr_swizzleMethod:@selector(addOperations:waitUntilFinished:) withMethod:@selector(_AdditionalCompletion_addOperations:waitUntilFinished:) error:&error], @"Swizzle failed %@", error);
}

- (void)_AdditionalCompletion_addOperation:(NSOperation *)op {
    [op addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
    [self _AdditionalCompletion_addOperation:op];
}

- (void)_AdditionalCompletion_addOperations:(NSArray *)ops waitUntilFinished:(BOOL)wait {
    for (NSOperation *operation in ops) {
        [operation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
    }
    [self _AdditionalCompletion_addOperations:ops waitUntilFinished:wait];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isFinished"] && [[change objectForKey:NSKeyValueChangeNewKey] boolValue]) {
        [object removeObserver:self forKeyPath:@"isFinished"];
        
        for (BOOL(^completionBlock)() in [object completionBlocks]) {
            completionBlock();
        }
    }
}

@end
