//
//  AppDelegate.m
//  BBYScanner
//
//  Created by Frank Barrett on 6/25/15.
//  Copyright (c) 2015 Frank Barrett. All rights reserved.
//

#import "AppDelegate.h"
#import "Functions.h"
#import "PrimaryViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

NSData *postData;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[Functions alloc] postToMysql:@"willResignActive"];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[Functions alloc] postToMysql:@"didEnterBackground"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[Functions alloc] postToMysql:@"willEnterForeground"];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[Functions alloc] postToMysql:@"willBecomeActive"];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[Functions alloc] postToMysql:@"willTerminate"];
}

@end
