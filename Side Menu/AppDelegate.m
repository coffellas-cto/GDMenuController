//
//  AppDelegate.m
//  Side Menu
//
//  Created by Alex G on 24.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import "AppDelegate.h"
#import "GDMenuController.h"
#import "TestViewController.h"
#import "MenuViewController.h"

@interface AppDelegate () {
    GDMenuController *_menuController;
    TestViewController *_VCOne;
    TestViewController *_VCTwo;
}
@end

@implementation AppDelegate

#pragma mark - Notifications

- (void)showOne {
    [_menuController showViewController:_VCOne animated:YES];
}

- (void)showTwo {
    if (!_VCTwo) {
        _VCTwo = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
        [_VCTwo.view layoutSubviews];
        _VCTwo.titleItem.title = @"Two";
        _VCTwo.nameLabel.text = @"TWO";
    }
    
    [_menuController showViewController:_VCTwo animated:YES];
}

- (void)showMenu {
    [_menuController showMenuAnimated:YES];
}

#pragma mark - Life Cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOne) name:@"showOne" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTwo) name:@"showTwo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMenu) name:@"showMenu" object:nil];
    
    _menuController = [GDMenuController new];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.rootViewController = _menuController.viewController;
    [self.window makeKeyAndVisible];
    
    _VCOne = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
    [_VCOne.view layoutSubviews];
    _VCOne.titleItem.title = @"One";
    _VCOne.nameLabel.text = @"ONE";
    _menuController.menuViewController = [[MenuViewController new] autorelease];
    [_menuController showViewController:_VCOne animated:NO];
    
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
