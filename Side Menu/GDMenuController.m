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
    UITapGestureRecognizer *_tapGesture;
    UIPanGestureRecognizer *_panGesture;
}

@end

@implementation GDMenuController

#pragma mark - Public Methods

- (void)showMenuAnimated:(BOOL)animated {
    [self showMenuAnimated:animated withVelocity:1];
}

- (void)showViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self showViewController:viewController animated:animated withVelocity:1];
}

#pragma mark - Private Methods

- (void)showMenuAnimated:(BOOL)animated withVelocity:(CGFloat)velocity {
    [UIView animateWithDuration:animated ? _transitionInterval * velocity : 0 animations:^{
        _VCContainerView.transform = CGAffineTransformMakeScale(_scaleFactor, _scaleFactor);
        CGRect newFrame = _VCContainerView.frame;
        newFrame.origin.x = newFrame.size.width * _menuWidthPart;
        _VCContainerView.frame = newFrame;
    } completion:^(BOOL finished) {
        _menuVisible = YES;
        if (_usesGestures) {
            [_currentVC.view addGestureRecognizer:_tapGesture];
        }
    }];
}

- (void)showViewController:(UIViewController *)viewController animated:(BOOL)animated withVelocity:(CGFloat)velocity {
    [_currentVC.view removeGestureRecognizer:_tapGesture];
    if (_currentVC != viewController) {
        viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        viewController.view.frame = CGRectMake(0, 0, CGRectGetWidth(_viewController.view.frame), CGRectGetHeight(_viewController.view.frame));
        
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
    
    [UIView animateWithDuration:animated ? _transitionInterval * velocity : 0 animations:^{
        _VCContainerView.transform = CGAffineTransformMakeScale(1, 1);
        CGRect newFrame = _VCContainerView.frame;
        newFrame.origin.x = 0;
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

- (void)setScaleFactor:(CGFloat)scaleFactor {
    if (scaleFactor > 1) {
        scaleFactor = 1;
    } else if (scaleFactor < 0.5) {
        scaleFactor = 0.5;
    }
    
    _scaleFactor = scaleFactor;
}

#pragma mark - Gestures

- (void)tap:(UISwipeGestureRecognizer *)g {
    [self showViewController:_currentVC animated:YES];
}

- (void)pan:(UIPanGestureRecognizer *)r {
    if (!_usesGestures)
        return;
    
    // Get the translation in the view
    CGPoint translatedPoint = [r translationInView:r.view];
    [r setTranslation:CGPointZero inView:r.view];
    
    // Translate target view using this translation
    CGRect newFrame = _VCContainerView.frame;
    CGFloat newX = _VCContainerView.frame.origin.x + translatedPoint.x;
    if (newX > 0) {
        newFrame.origin.x = newX;
        _VCContainerView.frame = newFrame;
        
        CGFloat relativePosition = newX / CGRectGetWidth(_VCContainerView.frame);
        CGFloat scale = 1 - relativePosition + relativePosition * _scaleFactor;
        _VCContainerView.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    // But also, detect the swipe gesture
    if (r.state == UIGestureRecognizerStateEnded)
    {
        CGPoint vel = [r velocityInView:r.view];
        if (vel.x < -1000)
        {
            // Fast pan - swipe to the left
            [self showViewController:_currentVC animated:YES];
        }
        else if (vel.x > 1000)
        {
            // Fast pan - swipe to the right
            [self showMenuAnimated:YES];
        }
        else
        {
            CGFloat thresholdX = CGRectGetWidth(_VCContainerView.frame) * _menuWidthPart;
            // Velocity calculation is based on the difference between an
            // actual and default transition distances
            CGFloat directionMultiplier = vel.x > 0 ? 0.33 : 0.66;
            if (newX > thresholdX * directionMultiplier) {
                CGFloat veloctiy = (newX - thresholdX) / thresholdX;
                [self showMenuAnimated:YES withVelocity:veloctiy];
            } else {
                CGFloat velocity = newX / thresholdX * 2;
                [self showViewController:_currentVC animated:YES withVelocity:velocity];
            }
        }
    }
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
        
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [_viewController.view addGestureRecognizer:_panGesture];
        
        _menuWidthPart = 0.5;
        _transitionInterval = 0.3;
        _VCContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.shadowRadius = 30;
        self.shadowOpacity = 0.5;
        self.usesGestures = YES;
        self.scaleFactor = 0.5;
    }
    return self;
}

- (void)dealloc {
    [_currentVC.view removeGestureRecognizer:_tapGesture];
    [_viewController.view removeGestureRecognizer:_panGesture];
    [_currentVC release];
    
    [_viewController release];
    [_menuContainerView release];
    [_VCContainerView release];
    self.menuViewController = nil;
    
    [_tapGesture release];
    [_panGesture release];
    [super dealloc];
}

@end
