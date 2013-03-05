//
//  NSURLConnection+Testing.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/8/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "NSURLConnection+Testing.h"
#import <OCMock/OCMock.h>

@implementation OCMockObject (NSURLConnectionTesting)

- (void)expectStartAndRespondWithDelegate:(id)delegate response:(NSURLResponse*)response chunks:(NSArray*)chunks {
    [(NSURLConnection*)[[self stub] andDo0:^{
        
        [delegate connection:(NSURLConnection*)self didReceiveResponse:response];
        
        for (NSData *chunk in chunks) {
            [delegate connection:(NSURLConnection*)self didReceiveData:chunk];
        }
        
        [delegate connectionDidFinishLoading:(NSURLConnection*)self];
    }] start];
}

- (void)expectStartAndFailWithDelegate:(id)delegate error:(NSError*)error {
    [(NSURLConnection*)[[self expect] andDo0:^{
        [delegate connection:nil didFailWithError:error];
    }] start];
}

@end
