//
//  SZOARequest.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 10/29/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZURLRequestOperation : NSOperation <NSURLConnectionDataDelegate>

- (id)initWithURLRequest:(NSURLRequest*)request;

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong, readonly) NSError *error;
@property (nonatomic, strong, readonly) NSHTTPURLResponse *response;
@property (nonatomic, strong, readonly) NSMutableData *responseData;
@property (nonatomic, strong, readonly) NSString *responseString;

@property (nonatomic, copy) void (^successBlock)(id result);
@property (nonatomic, copy) void (^failureBlock)(NSError *error);

@end