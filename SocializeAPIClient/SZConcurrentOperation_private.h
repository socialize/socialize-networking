//
//  SZConcurrentOperation_private.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 3/11/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

@interface SZConcurrentOperation () {
@protected BOOL _executing;
@protected BOOL _finished;
@protected BOOL _cancelled;
}

@property (nonatomic, assign, getter=isExecuting) BOOL executing;
@property (nonatomic, assign, getter=isFinished) BOOL finished;
@property (nonatomic, assign, getter=isCancelled) BOOL cancelled;
@end