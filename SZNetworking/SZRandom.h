//
//  SZRandom.h
//  SocializeAPIClient
//
//  Created by Nate Griswold on 3/8/13.
//  Copyright (c) 2013 Socialize. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ARC4RANDOM_MAX      0x100000000
#define RANDRANGE(a, b) ((double)arc4random() * (b - a) / ARC4RANDOM_MAX + a)
