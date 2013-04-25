//
//  SZOARequest.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 10/29/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZConcurrentOperation.h"
#import "SZURLRequestDownloader.h"

@interface SZURLRequestOperation : SZConcurrentOperation <NSURLConnectionDataDelegate>

- (id)initWithURLRequest:(NSMutableURLRequest*)request;

@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, strong, readonly) NSURLResponse *response;
@property (nonatomic, strong, readonly) NSMutableData *responseData;
@property (nonatomic, strong, readonly) NSError *error;

@property (nonatomic, copy) void (^URLCompletionBlock)(NSURLResponse *response, NSData *data, NSError *error);

@end