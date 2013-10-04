//
//  OCMockObject+Utilities.h
//  OCMock
//
//  Created by Nathaniel Griswold on 3/30/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "OCMockObject.h"

// Expose the realObject private method
@interface OCMockObject ()
- (id)realObject;
@end

@interface OCMockObject (Utilities)
+ (id)classMockForClass:(Class)class;
- (void)stubIsKindOfClass:(Class)class;
- (void)stubIsMemberOfClass:(Class)class;
- (id)makeNice;
- (void)expectAllocAndReturn:(id)instance;
- (void)reset;

@end
