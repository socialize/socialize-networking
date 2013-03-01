//
//  SZTestCase.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 11/1/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GHUnitIOS/GHUnit.h>
#import <OCMock/OCMock.h>
#import "SZGlobal.h"
#import "NSURLConnection+Testing.h"
#import "SZFakeOperationQueue.h"
#import "SZAPIOperation+Testing.h"
#import "NSOperation+Testing.h"

@interface SZTestCase : GHAsyncTestCase

@end
