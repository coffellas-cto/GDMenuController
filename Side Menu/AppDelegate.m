//
//  AppDelegate.m
//  Side Menu
//
//  Created by Alex G on 24.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import "AppDelegate.h"
#import "GDMenuController.h"
#import "OneViewController.h"
#import "MenuViewController.h"

@interface AppDelegate () {
    GDMenuController *_menuController;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _menuController = [GDMenuController new];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.rootViewController = _menuController.viewController;
    [self.window makeKeyAndVisible];
    
    OneViewController *testVC = [[[OneViewController alloc] initWithNibName:@"OneViewController" bundle:nil] autorelease];
    _menuController.menuViewController = [[MenuViewController new] autorelease];

    [_menuController showViewController:testVC animated:NO];
    
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
    [_menuController release];
}

@end
