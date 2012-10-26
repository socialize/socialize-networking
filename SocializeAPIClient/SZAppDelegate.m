//
//  SZAppDelegate.m
//  SocializeAPIClient
//
//  Created by Nate Griswold on 10/26/12.
//  Copyright (c) 2012 Socialize. All rights reserved.
//

#import "SZAppDelegate.h"
#import "SZAPIOperation.h"
#import "SZGlobal.h"
#import "SZAPIClient.h"

@interface SZAppDelegate ()
@property (nonatomic, strong) SZAPIClient *client;
@end

@implementation SZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, 50, 50);
    [self.window addSubview:button];

    self.client = [[SZAPIClient alloc] initWithConsumerKey:@"252f7ed8-2fe5-49a5-8b52-b5c06bd63891" consumerSecret:@"ea9dc991-fb32-4d40-9d85-aab35debf61c"];
    SZAPIOperation *auth = [self.client authenticate];
    auth.completionBlock = ^{
        NSLog(@"Received response %@", [auth responseString]);
    };

    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [auth cancel];
    });
//    [[NSOperationQueue mainQueue] addOperation:auth];

//    [[NSUserDefaults standardUserDefaults] setObject:@"252f7ed8-2fe5-49a5-8b52-b5c06bd63891" forKey:SZConsumerKeyDefaultsKey];
//    [[NSUserDefaults standardUserDefaults] setObject:@"ea9dc991-fb32-4d40-9d85-aab35debf61c" forKey:SZConsumerSecretDefaultsKey];
//    [[NSUserDefaults standardUserDefaults] setObject:@"610dc655-017f-4cd6-a0f1-a8b76d3cfeb6" forKey:SZAccessTokenDefaultsKey];
//    [[NSUserDefaults standardUserDefaults] setObject:@"484acbf1-74e1-4c2e-803a-aabb4839ed49" forKey:SZAccessTokenSecretDefaultsKey];
//    
//    NSArray *entities = @[ @{ @"entity_key": @"something", @"text": @"hello", @"medium": @101 } ];
//    
//    SZAPIOperation *api1 = [[SZAPIOperation alloc] initWithConsumerKey:@"252f7ed8-2fe5-49a5-8b52-b5c06bd63891" consumerSecret:@"ea9dc991-fb32-4d40-9d85-aab35debf61c" accessToken:@"610dc655-017f-4cd6-a0f1-a8b76d3cfeb6" accessTokenSecret:@"484acbf1-74e1-4c2e-803a-aabb4839ed49" method:@"POST" scheme:@"http" host:@"api.getsocialize.com" path:@"/v1/share/" parameters:entities];
////    SZAPIOperation *api1 = [[SZAPIOperation alloc] initWithScheme:@"http" method:@"POST" path:@"/v1/share/" parameters:entities];
//    api1.completionBlock = ^{
//        NSLog(@"Hi there %@", [api1 error]);
//    };
//    [[NSOperationQueue mainQueue] addOperation:api1];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
