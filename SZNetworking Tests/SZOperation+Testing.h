//
//  SZOperation+Testing.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 3/11/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import "SZOperation.h"

@interface SZTestOperation : SZOperation
@property (nonatomic, assign) BOOL shouldFail;
@end

@interface SZOperation (Testing)

@end
