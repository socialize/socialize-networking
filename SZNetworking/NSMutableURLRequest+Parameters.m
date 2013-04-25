//
//  NSURLRequest+Parameters.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 2/21/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "NSMutableURLRequest+Parameters.h"
#import "SZGlobal.h"

BOOL MethodIsBodyStyle(NSString *method) {
    return [method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"];
}

@implementation NSMutableURLRequest (Parameters)

+ (NSMutableURLRequest*)HTTPRequestWithMethod:(NSString*)method scheme:(NSString*)scheme host:(NSString*)host path:(NSString*)path parameters:(NSDictionary*)parameters {
    
    NSString *queryString = [[parameters map:^id(id key, id obj) {
        return [NSString stringWithFormat:@"%@=%@", key, obj];
    }] componentsJoinedByString:@"&"];
    

    NSMutableString *URLString = [NSMutableString stringWithFormat:@"%@://%@%@", scheme, host, path];
    if (!MethodIsBodyStyle(method) && [queryString length] > 0) {
        [URLString appendFormat:@"?%@", queryString];
    }
    
    NSURL *URL = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    [request setHTTPMethod:method];
    
    if (MethodIsBodyStyle(method)) {
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        [request setHTTPBody:[queryString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return request;
}

@end