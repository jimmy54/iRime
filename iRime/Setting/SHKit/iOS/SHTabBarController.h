//
//  SHTabBarController.h
//  SHKit
//
//  Created by Neo on 9/9/11.
//  Copyright (c) 2011 Paradigm X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHTabBarController : UITabBarController

// Create a view controller and setup it's tab bar item with a title and image
- (UIViewController *)viewControllerWithTabTitle:(NSString*)title image:(UIImage*)image;

// Bind a pre-created view controller to a newly created TabBarItem
- (UIViewController *)bindTabBarItemToViewController:(UIViewController *)viewController title:(NSString*)title image:(UIImage*)image;

// Create a custom UIButton and add it to the center of the tab bar
- (void)addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage;

// Override this method to handle the middle button touch event
- (void)buttonEvent;
@end
