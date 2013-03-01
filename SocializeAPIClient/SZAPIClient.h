//
//  SZAPIClient.h
//  SocializeAPIClient
//
//  Created by Nathaniel Griswold on 10/31/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZAPIOperation.h"

/** An API Client for Socialize */
@interface SZAPIClient : NSObject

/** An operation queue to use. If unspecified, a new queue with concurrency 10 will automatically be created. */
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic, copy) NSString *hostname;

/** Consumer Key. Register app and obtain key from your dashboard at getsocialize.com */
@property (nonatomic, copy) NSString *consumerKey;

/** Consumer Secret. Register app and obtain Secret from your dashboard at getsocialize.com */
@property (nonatomic, copy) NSString *consumerSecret;

/** A Preexisting access token. If left unspecified, will be filled in by any authentication operations triggered through the authenticate method. */
@property (nonatomic, copy) NSString *accessToken;

/** A Preexisting access token secret. If left unspecified, will be filled in by any authentication operations triggered through the authenticate method. */
@property (nonatomic, copy) NSString *accessTokenSecret;

/** UDID to send for any authentication operations */
@property (nonatomic, copy) NSString *udid;

/** Whether or not this client is currently authenticating */
@property (nonatomic, assign, getter=isAuthenticating, readonly) BOOL authenticating;

/** The current auth operation, only non-nil if isAuthenticating is YES */
@property (nonatomic, strong, readonly) SZAPIOperation *authOperation;

/** Whether or not this client has successfully authenticated (has an access token and secret) */
@property (nonatomic, assign, readonly, getter=isAuthenticated) BOOL authenticated;

/** The default host string that will be used if not specified in hostname parameter */
+ (NSString*)defaultHost;

/** The default UDID string that will be used if not specified in udid parameter. Note that for privacy reasons, this does not default to the real UDID */
+ (NSString*)defaultUDID;

/**
 Initialize a client with your consumerKey and consumerSecret. You can register app and obtain credentials from your dashboard at getsocialize.com
 
 @param consumerKey Consumer Key. Register app and obtain key from your dashboard at getsocialize.com
 @param consumerSecret Consumer Secret. Register app and obtain Secret from your dashboard at getsocialize.com
 */
- (id)initWithConsumerKey:(NSString *)consumerKey
           consumerSecret:(NSString *)consumerSecret;

/**
 Authenticate. Any operations added through addOperation: or addOperations: after this method is called will block
 until the authentication is complete. Blocked operations adopt the credentials of the latest successful authenticate.

 */
- (SZAPIOperation*)authenticate;

/**
 Add multiple operations.
 
 @param operations Operations to add. The only difference from using _NSOperationQueue addOperations:waitUntilFinished:_ directly is that any
 SZAPIOperations added using this method or addOperation: will be associated with this API client. This currently means they will block on any of this client's blocking operations.
 
 @param wait Same as _NSOperationQueue addOperations:waitUntilFinished:_
 */
- (void)addOperations:(NSArray*)operations waitUntilFinished:(BOOL)wait;

/**
 Add single operation.
 
 @param operation Operation to add. The only difference from using _NSOperationQueue addOperation:_ directly is that any
 SZAPIOperations added using this method or addOperation: will be associated with this API client. This currently means they will block on any of this client's blocking operations.
 */
- (void)addOperation:(NSOperation*)operation;

/**
 Generate an SZAPIOperation using credentials from this client. The operation is not automatically queued.
 
 @param method HTTP Method, e.g. @"POST".
 @param scheme HTTP Scheme, e.g. @"http". Currently only Socialize authentication options are https.
 @param path Path, e.g. @"/v1/entity/".
 @param parameters JSON-serializable parameters object, e.g.
 
    SZAPIOperation *operation = [anAPIClient APIOperationForMethod:@"POST" scheme:@"http" path:@"/v1/entity/" parameters:@[ @{ @"entity_key": @"my_key" } ]]
 */
- (SZAPIOperation*)APIOperationForMethod:(NSString*)method
                                  scheme:(NSString*)scheme
                                    path:(NSString*)path
                              parameters:(id)parameters;

/**
 Generate an SZAPIOperation using credentials from this client. Associate the operation with this client ([SZAPIOperation APIClient] ). The operation is not automatically queued.
 
 @param operationType @see SZAPIOperationType
 @param parameters JSON-serializable parameters object.
 
    SZAPIOperation *operation = [anAPIClient APIOperationForOperationType:SZAPIOperationTypeListComments parameters:@[ @{ @"entity_key": @"my_key" } ]]
 */
- (SZAPIOperation*)APIOperationForOperationType:(SZAPIOperationType)operationType
                                     parameters:(id)parameters;

/**
 Create and queue an SZAPIOperation as in APIOperationForMethod:scheme:path:parameters:
 
 @param method HTTP Method, e.g. @"POST".
 @param scheme HTTP Scheme, e.g. @"http". Currently only Socialize authentication options are https.
 @param path Path, e.g. @"/v1/entity/".
 @param parameters JSON-serializable parameters object, e.g. @[ @{ @"entity_key": @"my_key" } ]
*/
- (SZAPIOperation*)addAPIOperationForMethod:(NSString*)method
                                     scheme:(NSString*)scheme
                                       path:(NSString*)path
                                 parameters:(id)parameters;

/**
 Create and queue an SZAPIOperation as in APIOperationForOperationType:parameters:
 
 @param operationType @see SZAPIOperationType
 @param parameters JSON-serializable parameters object.
 */
- (SZAPIOperation*)addAPIOperationForOperationType:(SZAPIOperationType)operationType
                                        parameters:(id)parameters;

@end

@interface SZAPIOperation (SZAPIClient)
@property (nonatomic, weak) SZAPIClient *APIClient;
@end
