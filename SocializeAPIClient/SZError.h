//
//  SZError.h
//  SocializeAPIClient
//
//  Created by Nathaniel Griswold on 10/17/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SZAPIError) {
    SZAPIErrorCodeRequestCancelled,
    SZAPIErrorCodeServerReturnedHTTPErrorStatus,
    SZAPIErrorCodeServerReturnedErrors,
    SZAPIErrorCodeCouldNotParseServerResponse,
    SZAPIErrorOperationHasFailedDependencies,
};

extern NSString *const SZAPIClientErrorDomain;
extern NSString *const SZErrorHTTPURLResponseKey;
extern NSString *const SZErrorHTTPURLResponseBodyKey;
extern NSString *const SZErrorFailedDependenciesKey;
extern NSString *const SZErrorServerErrorsListKey;
