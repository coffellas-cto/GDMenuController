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
    UISwipeGestureRecognizer *_swipeGestureRight;
    UISwipeGestureRecognizer *_swipeGestureLeft;
    UITapGestureRecognizer *_tapGesture;
}

@end

@implementation GDMenuController

#pragma mark - Public Methods

- (void)showMenuAnimated:(BOOL)animated {
    CGRect newFrame = _VCContainerView.frame;
    newFrame.origin.x = newFrame.size.width * _menuWidthPart;
    [UIView animateWithDuration:animated ? _transitionInterval : 0 animations:^{
        _VCContainerView.frame = newFrame;
    } completion:^(BOOL finished) {
        _menuVisible = YES;
        if (_usesGestures) {
            [_currentVC.view addGestureRecognizer:_tapGesture];
        }
    }];
}

- (void)showViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [_currentVC.view removeGestureRecognizer:_tapGesture];
    if (_currentVC != viewController) {
        viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        viewController.view.frame = CGRectMake(0, 0, CGRectGetWidth(_viewController.view.frame), CGRectGetHeight(_viewController.view.frame));
        
        [_currentVC.view removeGestureRecognizer:_swipeGestureRight];
        [_currentVC.view removeGestureRecognizer:_swipeGestureLeft];
        if (_usesGestures) {
            [viewController.view addGestureRecognizer:_swipeGestureRight];
            [viewController.view addGestureRecognizer:_swipeGestureLeft];
        }
        
        [UIView transitionWithView:_VCContainerView duration:_transitionInterval options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            if (_currentVC) {
                [_currentVC.view removeFromSuperview];
                [_currentVC release];
            }
            
            [_VCContainerView addSubview:viewController.view];
        } completion:^(BOOL finished) {
            _currentVC = [viewController retain];
        }];
    }
    
    CGRect newFrame = _VCContainerView.frame;
    newFrame.origin.x = 0;
    [UIView animateWithDuration:animated ? _transitionInterval : 0 animations:^{
        _VCContainerView.frame = newFrame;
    } completion:^(BOOL finished) {
        _menuVisible = NO;
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

#pragma mark - Gestures

- (void)swipeRight:(UISwipeGestureRecognizer *)g {
    [self showMenuAnimated:YES];
}

- (void)swipeLeft:(UISwipeGestureRecognizer *)g {
    [self showViewController:_currentVC animated:YES];
}

- (void)tap:(UISwipeGestureRecognizer *)g {
    [self showViewController:_currentVC animated:YES];
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
        
        _swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
        _swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
        _swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        
        _menuWidthPart = 0.5;
        _transitionInterval = 0.3;
        _VCContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.shadowRadius = 30;
        self.shadowOpacity = 0.5;
        self.usesGestures = YES;
    }
    return self;
}

- (void)dealloc {
    [_currentVC.view removeGestureRecognizer:_tapGesture];
    [_currentVC.view removeGestureRecognizer:_swipeGestureRight];
    [_currentVC.view removeGestureRecognizer:_swipeGestureLeft];
    [_currentVC release];
    
    [_viewController release];
    [_menuContainerView release];
    [_VCContainerView release];
    [_swipeGestureRight release];
    [_swipeGestureLeft release];
    [_tapGesture release];
    self.menuViewController = nil;
    [super dealloc];
}

@end
