//
//  NSOperation+AdditionalCompletion.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/26/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOperation (AdditionalCompletion)

- (void)addCompletionBlock:(void(^)())completionBlock;

@end

@interface NSOperationQueue (AdditionalCompletion)

@end

