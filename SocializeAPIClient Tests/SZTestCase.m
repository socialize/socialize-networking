//
//  SZTestCase.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 11/1/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZTestCase.h"
#import "NSMutableURLRequest+Parameters.h"
#import "NSMutableURLRequest+OAuth.h"
#import "SZURLRequestOperation.h"

@interface SZTestCase ()
@property (nonatomic, strong) NSConditionLock *asyncCounter;

@end

@implementation SZTestCase

- (void)incrementAsyncCount {
    [self.asyncCounter lock];
    [self.asyncCounter unlockWithCondition:[self.asyncCounter condition] + 1];
}

- (void)waitForAsyncCount:(NSUInteger)count {
    [self.asyncCounter lockWhenCondition:count];
    [self.asyncCounter unlock];
}

- (void)setUp {
    _asyncCounter = [[NSConditionLock alloc] initWithCondition:0];
    
    [ClassMockRegistry stopMockingAllClasses];
}

- (void)tearDown {
    [ClassMockRegistry stopMockingAllClassesAndVerify];
}

- (void)notify:(NSInteger)status forSelector:(SEL)selector {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [super notify:status forSelector:selector];
    });
}

@end
