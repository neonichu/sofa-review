//
//  BBUAppDelegate.m
//  SofaReview
//
//  Created by Boris Bügling on 11.05.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBUAppDelegate.h"
#import "BBUCodeViewController.h"
#import "BBUFileListViewController.h"

@implementation BBUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UINavigationController* fileNavigation = [[UINavigationController alloc]
                                              initWithRootViewController:[BBUFileListViewController new]];
    
    UISplitViewController* splitVC = [UISplitViewController new];
    splitVC.viewControllers = @[ fileNavigation, [BBUCodeViewController new] ];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = splitVC;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
