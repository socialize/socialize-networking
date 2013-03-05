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
#import "SZAPIOperation.h"

@implementation SZTestCase

- (void)setUp {
    [ClassMockRegistry stopMockingAllClasses];
}

- (void)tearDown {
    [ClassMockRegistry stopMockingAllClassesAndVerify];
}

- (void)disableClass:(Class)class {
    [class startNiceMockingClass];
    [[class stub] alloc];
}

@end
