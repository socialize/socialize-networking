//
//  NSURLDownloader.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/7/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//
// This does the exact same thing as +[NSURLConnection sendAsynchronousRequest:queue:completionHandler:], except it allows cancellation mid-request
// The completionHandler is always called on the main thread

#import <Foundation/Foundation.h>

@interface SZURLRequestDownloader : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

- (id)initWithURLRequest:(NSURLRequest*)request;
- (void)start;
- (void)cancel;

@property (nonatomic, copy) void (^completionBlock)(NSURLResponse *response, NSMutableData *data, NSError *error);
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong, readonly) NSError *error;
@property (nonatomic, strong, readonly) NSURLResponse *response;
@property (nonatomic, strong, readonly) NSMutableData *responseData;

@property (nonatomic, assign, getter=isCancelled, readonly) BOOL cancelled;

@property (nonatomic, strong, readonly) NSString *responseString;

@end
