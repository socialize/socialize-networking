//
//  SZFakeOperationQueue.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/27/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZFakeOperationQueue : NSOperationQueue
@property (nonatomic, strong) NSMutableArray *fakeOperations;

@end
