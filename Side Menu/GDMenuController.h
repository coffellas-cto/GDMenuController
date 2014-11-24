//
//  GDMenuController.h
//  Side Menu
//
//  Created by Alex G on 24.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDMenuController : NSObject

@property (nonatomic, retain) UIViewController *menuViewController;
@property (nonatomic, readonly) UIViewController *viewController;
@property (nonatomic) CGFloat menuWidthPart;

- (void)showMenuAnimated:(BOOL)animated;
- (void)showViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
