//
//  OCMockRecorder+Utilities.h
//  OCMock
//
//  Created by Nathaniel Griswold on 3/30/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "OCMockRecorder.h"

@interface OCMockRecorder (Utilities)
- (id)andReturnBool:(BOOL)b;
- (id)andReturnInteger:(NSInteger)i;
- (id)andReturnUInteger:(NSUInteger)i;

- (id)andDo0:(void(^)())action;
- (id)andDo1:(void(^)(id))action;
- (id)andDo2:(void(^)(id, id))action;
- (id)andDo3:(void(^)(id, id, id))action;
- (id)andDo4:(void(^)(id, id, id, id))action;
- (id)andDo5:(void(^)(id, id, id, id, id))action;
- (id)andDo6:(void(^)(id, id, id, id, id, id))action;

- (id)andReturnFromBlock:(id (^)())block;
- (id)andReturnBoolFromBlock:(BOOL (^)())block;

- (id)andForwardToObject:(id)object;


@end
