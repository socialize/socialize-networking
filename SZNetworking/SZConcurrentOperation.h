//
//  SZConcurrentOperation.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 3/1/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "SZOperation.h"

@interface SZConcurrentOperation : SZOperation

- (void)KVStop;
- (void)KVStart;
- (void)KVCancel;

@end
