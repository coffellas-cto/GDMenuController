//
//  GDMenuController.m
//  Side Menu
//
//  Created by Alex G on 24.11.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import "GDMenuController.h"

@interface GDMenuController() {
    UIView *_VCContainerView;
    UIView *_menuContainerView;
    UIViewController *_currentVC;
    BOOL _menuVisible;
}

@end

@implementation GDMenuController

#pragma mark - Public Methods

- (void)showMenuAnimated:(BOOL)animated {
    CGRect newFrame = _VCContainerView.frame;
    newFrame.origin.x = newFrame.size.width * _menuWidthPart;
    [UIView animateWithDuration:animated ? _transitionInterval : 0 animations:^{
        _VCContainerView.frame = newFrame;
    }];
}

- (void)showViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (_currentVC != viewController) {
        viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        viewController.view.frame = CGRectMake(0, 0, CGRectGetWidth(_viewController.view.frame), CGRectGetHeight(_viewController.view.frame));
        
        [UIView transitionWithView:_VCContainerView duration:_transitionInterval options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            if (_currentVC) {
                [_currentVC.view removeFromSuperview];
            }
            
            [_VCContainerView addSubview:viewController.view];
        } completion:^(BOOL finished) {
            _currentVC = viewController;
        }];
    }
    
    CGRect newFrame = _VCContainerView.frame;
    newFrame.origin.x = 0;
    [UIView animateWithDuration:animated ? _transitionInterval : 0 animations:^{
        _VCContainerView.frame = newFrame;
    }];
}

#pragma mark - Setters & Getters

- (void)setMenuWidthPart:(CGFloat)menuWidthPart {
    if (menuWidthPart > 0.8) {
        _menuWidthPart = 0.8;
    } else if (menuWidthPart < 0) {
        _menuWidthPart = 0;
    } else {
        _menuWidthPart = menuWidthPart;
    }
}

- (void)setMenuViewController:(UIViewController *)menuViewController {
    [_menuViewController.view removeFromSuperview];
    [_menuViewController release];
    _menuViewController = [menuViewController retain];
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    _VCContainerView.layer.shadowRadius = shadowRadius;
}

- (CGFloat)shadowRadius {
    return _VCContainerView.layer.shadowRadius;
}

- (void)setShadowOpacity:(float)shadowOpacity {
    _VCContainerView.layer.shadowOpacity = shadowOpacity;
}

- (float)shadowOpacity {
    return _VCContainerView.layer.shadowOpacity;
}

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewController = [UIViewController new];
        
        _menuContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_viewController.view.frame), CGRectGetHeight(_viewController.view.frame))];
        _VCContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_viewController.view.frame), CGRectGetHeight(_viewController.view.frame))];
        _VCContainerView.autoresizingMask = _menuContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_viewController.view addSubview:_menuContainerView];
        [_viewController.view addSubview:_VCContainerView];
        
        _menuContainerView.backgroundColor = [UIColor redColor];
        _VCContainerView.backgroundColor = [UIColor lightGrayColor];
        
        _menuWidthPart = 0.5;
        _transitionInterval = 0.3;
        _VCContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.shadowRadius = 30;
        self.shadowOpacity = 0.5;
    }
    return self;
}

- (void)dealloc {
    [_viewController release];
    [_menuContainerView release];
    [_VCContainerView release];
    self.menuViewController = nil;
    [super dealloc];
}

@end
