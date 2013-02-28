//
//  NSURLConnection+Testing.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/8/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "NSURLConnection+Testing.h"
#import <OCMock/OCMock.h>

@implementation NSURLConnection (Testing)

+ (void)expectRequestWithCheck:(BOOL(^)(NSURLRequest*))checkBlock response:(NSURLResponse*)response chunks:(NSArray*)chunks {

    __block id connectionDelegate = nil;
    __block id connectionRequest = nil;
    
    id mockURLConnection = [OCMockObject mockForClass:[NSURLConnection class]];
    [(NSURLConnection*)[[mockURLConnection stub] andDo0:^{
        
        [connectionDelegate connection:mockURLConnection didReceiveResponse:response];
        
        for (NSData *chunk in chunks) {
            [connectionDelegate connection:mockURLConnection didReceiveData:chunk];
        }
        
        [connectionDelegate connectionDidFinishLoading:mockURLConnection];
    }] start];
    
    [[[[NSURLConnection stub] andDo2:^(NSURLRequest *request, id delegate) {
        connectionDelegate = delegate;
        connectionRequest = request;
    }] andReturn:mockURLConnection] connectionWithRequest:[OCMArg checkWithBlock:checkBlock] delegate:OCMOCK_ANY];
    
}

@end
