//
//  UIViewController+SHExtensions.m
//  SHKit
//
//  Created by Neo on 3/30/12.
//  Copyright (c) 2012 Paradigm X. All rights reserved.
//

#import "UIViewController+SHExtensions.h"

@implementation UIViewController (SHExtensions)

- (CGRect) viewFrame {
    static CGFloat const kNavigationBarPortraitHeight = 44;
    static CGFloat const kNavigationBarLandscapeHeight = 34;
    static CGFloat const kToolBarHeight = 49;
    
    // Start with the screen size minus the status bar if present
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    
    // If the orientation is landscape left or landscape right then swap the width and height
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        CGFloat height = frame.size.height;
        frame.size.height = frame.size.width;
        frame.size.width = height;
    }
    
    // Take into account if there is a navigation bar present and visible (note that if the NavigationBar may
    // not be visible at this stage in the view controller's lifecycle.  If the NavigationBar is shown/hidden
    // in the loadView then this provides an accurate result.  If the NavigationBar is shown/hidden using the
    // navigationController:willShowViewController: delegate method then this will not be accurate until the
    // viewDidAppear method is called.
    if (self.navigationController) {
        if (self.navigationController.navigationBarHidden == NO) {
            // Depending upon the orientation reduce the height accordingly
            if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
                frame.size.height -= kNavigationBarLandscapeHeight;
            }
            else {
                frame.size.height -= kNavigationBarPortraitHeight;
            }
        }
    }
    
    // Take into account if there is a toolbar present and visible
    if (self.tabBarController) {
        if (!self.tabBarController.view.hidden) frame.size.height -= kToolBarHeight;
    }
    return frame;
}

@end
