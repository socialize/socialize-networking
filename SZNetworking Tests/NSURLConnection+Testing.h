//
//  NSURLConnection+Testing.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/8/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OCMock/OCMock.h>

@interface OCMockObject (NSURLConnectionTesting)

- (void)expectStartAndRespondWithDelegate:(id)delegate response:(NSURLResponse*)response chunks:(NSArray*)chunks;
- (void)expectStartAndFailWithDelegate:(id)delegate error:(NSError*)error;

@end
