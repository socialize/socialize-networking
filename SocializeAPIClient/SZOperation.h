//
//  SZOperation.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/8/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZFallibleOperation.h"

@interface SZOperation : NSOperation <SZFallibleOperation>

@property (nonatomic, assign) BOOL didFail;

- (NSArray*)failedDependencies;
- (NSError*)failedDependenciesError;

@end
