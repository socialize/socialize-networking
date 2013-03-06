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

+ (void)load {
    NSError *error = nil;
    NSAssert([self sz_jr_swizzleMethod:@selector(start) withMethod:@selector(_AdditionalCompletion_start) error:&error], @"Swizzle failed %@", error);
}

+ (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isFinished"] && [[change objectForKey:NSKeyValueChangeNewKey] boolValue]) {
        [object removeObserver:(NSObject*)self forKeyPath:@"isFinished"];
        
        for (void(^completionBlock)() in [object completionBlocks]) {
            completionBlock();
        }
    }
}

- (void)_AdditionalCompletion_start {
    [self addObserver:(NSObject*)[self class] forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
    [self _AdditionalCompletion_start];
}

- (NSMutableArray*)completionBlocks {
    
    NSMutableArray *completionBlocks = objc_getAssociatedObject(self, CompletionBlocksKey);
    
    if (completionBlocks == nil) {
        completionBlocks = [NSMutableArray array];
        objc_setAssociatedObject(self, CompletionBlocksKey, completionBlocks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return completionBlocks;
}

- (void)addCompletionBlock:(void(^)())completionBlock {
    [[self completionBlocks] addObject:completionBlock];
}

@end