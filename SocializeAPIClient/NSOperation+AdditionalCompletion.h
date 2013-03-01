//
//  NSOperation+AdditionalCompletion.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/26/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOperation (AdditionalCompletion)

@property (nonatomic, strong, readonly) NSMutableArray *completionBlocks;
- (void)addCompletionBlock:(void(^)())completionBlock;

@end

@interface NSOperationQueue (AdditionalCompletion)

@end

