//
//  SZURLRequestOperation+Testing.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 3/5/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "SZURLRequestOperation.h"
#import <OCMock/OCMock.h>

@interface SZURLRequestOperation (Testing)

@end

@interface OCMockObject (SZURLRequestOperationTesting)
- (void)expectStartAndCompleteWithResponse:(NSURLResponse*)response data:(NSMutableData*)data error:(NSError*)error;
@end
