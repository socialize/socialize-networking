//
//  OCMockObject+Utilities.m
//  OCMock
//
//  Created by Nathaniel Griswold on 3/30/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "OCMockObject+Utilities.h"
#import "OCMock.h"
#import <objc/runtime.h>
#import "OCMockRecorder+Utilities.h"

@interface OCMockObject ()
+ (id)_makeNice:(OCMockObject *)mock;
@end

@implementation OCMockObject (Utilities)

+ (id)classMockForClass:(Class)class {
    Class meta = object_getClass(class);
    return [self mockForClass:meta];
}

- (id)makeNice {
    [OCMockObject _makeNice:self];
    return self;
}

- (void)stubIsKindOfClass:(Class)class {
    [[[self stub] andReturnBool:YES] isKindOfClass:class];
    [[[self stub] andReturnBool:NO] isKindOfClass:OCMOCK_ANY];
}

- (void)stubIsMemberOfClass:(Class)class {
    [[[self stub] andReturnBool:YES] isMemberOfClass:class];
    [[[self stub] andReturnBool:NO] isMemberOfClass:OCMOCK_ANY];
}

- (void)expectAllocAndReturn:(id)instance {
    [[[[self stub] andDo0:^{
        [instance retain];
    }] andReturn:instance] alloc];
}

- (void)reset {
    [self init];
}

@end
