//
//  AppDelegate.m
//  iPhoneMeetupRichTextDemo
//
//  Created by Jeffrey Friesen on 2013-01-17.
//  Copyright (c) 2013 Jeffrey Friesen. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoTableViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [DemoTableViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
