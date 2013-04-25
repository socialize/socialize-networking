//
//  main.m
//  SocializeAPIClient Tests
//
//  Created by Nate Griswold on 11/1/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeUnitTestApplication.h"

@interface RunnerDelegate : NSObject <GHTestRunnerDelegate>
@end

@implementation RunnerDelegate
- (void)testRunnerDidEnd:(GHTestRunner *)runner {
    exit((int)runner.stats.failureCount);
}
@end

int main(int argc, char *argv[])
{
    @autoreleasepool {
        
        if (getenv("GHUNIT_CLI")) {
            GHTestRunner *runner = [GHTestRunner runnerFromEnv];
            RunnerDelegate *delegate = [[RunnerDelegate alloc] init];
            runner.delegate = delegate;
            [runner runInBackground];
            [[NSRunLoop mainRunLoop] run];
        } else {
            return UIApplicationMain(argc, argv, nil, @"SocializeUnitTestApplication");
        }
    }
}