//
//  SZURLRequestOperation_private.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 11/1/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZURLRequestDownloader.h"

@interface SZURLRequestOperation ()

- (void)callCompletion;
- (void)downloadCompletionWithResponse:(NSURLResponse*)response data:(NSData*)data error:(NSError*)error;
- (void)failWithError:(NSError*)error;

@property (nonatomic, strong) SZURLRequestDownloader *URLRequestDownloader;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSMutableData *responseData;

@end