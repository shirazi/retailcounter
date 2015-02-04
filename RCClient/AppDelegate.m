//
//  AppDelegate.m
//  RCClient
//
//  Created by Dimitris Togias on 2/4/15.
//  Copyright (c) 2015 RC Ltd. All rights reserved.
//

#import "AppDelegate.h"

#import <Parse/Parse.h>

////////////////////////////////////////////////////////////////////////////////
@interface AppDelegate ()

@end

////////////////////////////////////////////////////////////////////////////////
@implementation AppDelegate

////////////////////////////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"3Rpp4yhUDr0HFJIYpCBLhkPHplFED7tgRSfJ8ecc"
                  clientKey:@"ho8nQw0N75t6COrB8RdSoEMBnBbdUuDLpNSaqXlY"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    return YES;
}

@end
