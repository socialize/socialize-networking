//
//  SZOARequest.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 10/29/12.
//  Copyright (c) 2012 Nate Griswold. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZOARequest : NSOperation <NSURLConnectionDataDelegate>

- (id)initWithURLRequest:(NSURLRequest*)request;

@property (nonatomic, strong, readonly) NSURLRequest *request;
@property (nonatomic, strong, readonly) NSError *error;
@property (nonatomic, strong, readonly) NSHTTPURLResponse *response;
@property (nonatomic, strong, readonly) NSMutableData *responseData;
@property (nonatomic, strong, readonly) NSString *responseString;

@end