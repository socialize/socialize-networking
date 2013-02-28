//
//  SZURLRequestDownloaderTests.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/8/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "SZTestCase.h"
#import "SZURLRequestDownloader.h"

@interface SZURLRequestDownloaderTests : SZTestCase

- (void)testSuccessfulDownload;
+ (id)completingMockDownloaderWithResponse:(NSURLResponse*)response data:(NSData*)data error:(NSError*)error;

@property (nonatomic, strong) SZURLRequestDownloader *URLRequestDownloader;

@end
