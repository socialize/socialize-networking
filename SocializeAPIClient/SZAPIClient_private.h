//
//  SZAPIClient_private.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 3/7/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

@interface SZAPIClient () {
    BOOL _authenticating;
}

@property (nonatomic, strong) NSRecursiveLock *authLock;
@property (nonatomic, strong) SZAPIOperation *authOperation;

- (SZAPIOperation*)createAnonymousAuthOperation;

@end

