//
//  SZOARequest+Socialize.h
//  Socialize
//
//  Created by Nathaniel Griswold on 8/8/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZURLRequestOperation.h"

@interface NSURLRequest (Socialize)

+ (NSURLRequest*)socializeRequestWithScheme:(NSString*)scheme
                                     method:(NSString*)method
                                       path:(NSString*)path
                                 parameters:(NSDictionary*)parameters;

@end

static NSString const * kSocializeRequestCreateShare = @"kSocializeRequestCreateShare";
