//
//  SZURLRequestDownloader_private.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 3/1/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

@interface SZURLRequestDownloader ()

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSURLResponse *response;

@end

