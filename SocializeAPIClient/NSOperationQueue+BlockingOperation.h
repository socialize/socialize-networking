//
//  NSOperationQueue+BlockingOperation.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/25/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOperationQueue (BlockingOperation)

- (void)addBlockingOperation:(NSOperation*)operation dontBlock:(BOOL(^)(NSOperation *otherOperation))dontBlock;
- (void)addBlockingOperations:(NSArray*)operations waitUntilFinished:(BOOL)wait dontBlock:(BOOL(^)(NSOperation *otherOperation))dontBlock;
@end
