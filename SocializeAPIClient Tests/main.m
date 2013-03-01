//
//  main.m
//  SocializeAPIClient Tests
//
//  Created by Nate Griswold on 11/1/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeUnitTestApplication.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        if (getenv("GHUNIT_CLI")) {
            return [GHTestRunner run];
        } else {
            return UIApplicationMain(argc, argv, nil, @"SocializeUnitTestApplication");
        }

    }
}