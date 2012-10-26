//
//  SZURLRequestOperation_private.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 11/1/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

@interface SZURLRequestOperation (Private)

@property (nonatomic, copy) void (^internalSuccessBlock)(id result);
@property (nonatomic, copy) void (^internalFailureBlock)(NSError *error);

@end