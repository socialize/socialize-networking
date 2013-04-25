//
//  SZGlobal.h
//  SocializeAPIClient
//
//  Created by Nathaniel Griswold on 10/31/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "NSData+JSONHelpers.h"
#import "SZError.h"
#import "NSObject+JSONHelpers.h"
#import "NSHTTPURLResponse+StringEncoding.h"
#import "Functional.h"
#import "SZRandom.h"

#define WEAK(obj) __weak __typeof__(obj)

#define BLOCK_CALL(blk) do { if (blk != nil) blk(); } while (0)
#define BLOCK_CALL_1(blk, arg1) do { if (blk != nil) blk(arg1); } while (0)
#define BLOCK_CALL_2(blk, arg1, arg2) do { if (blk != nil) blk(arg1, arg2); } while (0)
#define BLOCK_CALL_3(blk, arg1, arg2, arg3) do { if (blk != nil) blk(arg1, arg2, arg3); } while (0)