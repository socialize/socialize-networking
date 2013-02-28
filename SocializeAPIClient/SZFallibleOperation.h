//
//  SZFallableOperation.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/8/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SZFallibleOperation <NSObject>

@property (nonatomic, assign, readonly) BOOL didFail;

@end