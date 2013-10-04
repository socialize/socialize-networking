//
//  OCMockRecorder+Utilities.m
//  OCMock
//
//  Created by Nathaniel Griswold on 3/30/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "OCMockRecorder+Utilities.h"
#import "OCMock.h"

@implementation OCMockRecorder (Utilities)

- (id)andReturnBool:(BOOL)b {
    return [self andReturnValue:OCMOCK_VALUE(b)];
}

- (id)andReturnUInteger:(NSUInteger)i {
    return [self andReturnValue:OCMOCK_VALUE(i)];
}

- (id)andReturnInteger:(NSInteger)i {
    return [self andReturnValue:OCMOCK_VALUE(i)];
}

- (id)andDo0:(void(^)())action {
    if (action == nil) return self;
    
    return [self andDo:^(NSInvocation *inv) {
        action();
    }];
}

- (id)andDo1:(void(^)(id))action {
    if (action == nil) return self;
    
    return [self andDo:^(NSInvocation *inv) {
        id arg1;
        [inv getArgument:&arg1 atIndex:2];
        action(arg1);
    }];
}

- (id)andDo2:(void(^)(id, id))action {
    if (action == nil) return self;
    
    return [self andDo:^(NSInvocation *inv) {
        id arg1, arg2;
        [inv getArgument:&arg1 atIndex:2];
        [inv getArgument:&arg2 atIndex:3];
        action(arg1, arg2);
    }];
}

- (id)andDo3:(void(^)(id, id, id))action {
    if (action == nil) return self;
    return [self andDo:^(NSInvocation *inv) {
        id arg1, arg2, arg3;
        [inv getArgument:&arg1 atIndex:2];
        [inv getArgument:&arg2 atIndex:3];
        [inv getArgument:&arg3 atIndex:4];
        action(arg1, arg2, arg3);
    }];
}

- (id)andDo4:(void(^)(id, id, id, id))action {
    if (action == nil) return self;
    return [self andDo:^(NSInvocation *inv) {
        id arg1, arg2, arg3, arg4;
        [inv getArgument:&arg1 atIndex:2];
        [inv getArgument:&arg2 atIndex:3];
        [inv getArgument:&arg3 atIndex:4];
        [inv getArgument:&arg4 atIndex:5];
        action(arg1, arg2, arg3, arg4);
    }];
}

- (id)andDo5:(void(^)(id, id, id, id, id))action {
    if (action == nil) return self;
    return [self andDo:^(NSInvocation *inv) {
        id arg1, arg2, arg3, arg4, arg5;
        [inv getArgument:&arg1 atIndex:2];
        [inv getArgument:&arg2 atIndex:3];
        [inv getArgument:&arg3 atIndex:4];
        [inv getArgument:&arg4 atIndex:5];
        [inv getArgument:&arg5 atIndex:6];
        action(arg1, arg2, arg3, arg4, arg5);
    }];
}

- (id)andDo6:(void(^)(id, id, id, id, id, id))action {
    if (action == nil) return self;
    return [self andDo:^(NSInvocation *inv) {
        id arg1, arg2, arg3, arg4, arg5, arg6;
        [inv getArgument:&arg1 atIndex:2];
        [inv getArgument:&arg2 atIndex:3];
        [inv getArgument:&arg3 atIndex:4];
        [inv getArgument:&arg4 atIndex:5];
        [inv getArgument:&arg5 atIndex:6];
        [inv getArgument:&arg6 atIndex:7];
        action(arg1, arg2, arg3, arg4, arg5, arg6);
    }];
}

- (id)andReturnFromBlock:(id (^)())block {
    return [self andDo:^(NSInvocation *inv) {
        id retVal = block();
        [inv setReturnValue:&retVal];
    }];
}

- (id)andReturnBoolFromBlock:(BOOL (^)())block {
    return [self andDo:^(NSInvocation *inv) {
        BOOL retVal = block();
        [inv setReturnValue:&retVal];
    }];
}

- (id)andForwardToObject:(id)object {
    return [self andDo:^(NSInvocation *inv) {
        [inv invokeWithTarget:object];
    }];
}

@end
