//
//  SZError.h
//  SocializeAPIClient
//
//  Created by Nathaniel Griswold on 10/17/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SZNetworkingError) {
    SZNetworkingErrorCodeRequestCancelled,
    SZNetworkingErrorCodeServerReturnedHTTPErrorStatus,
    SZNetworkingErrorOperationHasFailedDependencies,
};

extern NSString *const SZNetworkingErrorDomain;
extern NSString *const SZErrorURLResponseKey;
extern NSString *const SZErrorURLResponseBodyKey;
extern NSString *const SZErrorFailedDependenciesKey;
