//
//  AppDelegate.m
//  HMRcDemo
//
//  Created by 研发ios工程师 on 2018/2/1.
//  Copyright © 2018年 heimaniOS. All rights reserved.
//

#import "AppDelegate.h"
#import "HmRcHttpRequest.h"
#import "HMRcSDK.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

//A020A61387B6
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [HMRcSDK startHmRcSDKWithUserName:@"HJ" andUserId:@"110"];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor =[UIColor whiteColor];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController * VC =[sb instantiateViewControllerWithIdentifier:@"Main"];
    self.window.rootViewController = VC;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
