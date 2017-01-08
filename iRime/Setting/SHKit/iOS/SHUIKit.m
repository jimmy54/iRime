//
//  SHUIKit.m
//  SHKit
//
//  Created by Neo on 9/13/11.
//  Copyright (c) 2011 Paradigm X. All rights reserved.
//

#import "SHUIKit.h"

@implementation SHUIKit

+ (BOOL)canConfigureAppearanceOfClass:(Class)c {
    return [c respondsToSelector:@selector(appearance)];
}

+ (void)customizeNavigationBar:(UINavigationController *)navController backgroundImage:(UIImage *)image tintColor:(UIColor *)color {
    if ([SHUIKit canConfigureAppearanceOfClass:[UINavigationBar class]]) {
        [[UINavigationBar appearance] setTintColor:color];
        [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }    
    else {
        UINavigationBar *navBar = [navController navigationBar];
        [navBar setTintColor:color];
        UIImageView *imageView = (UIImageView *)[navBar viewWithTag:kSCNavigationBarBackgroundImageTag];
        if (imageView == nil)
        {
            imageView = [[UIImageView alloc] initWithImage:image];
            [imageView setTag:kSCNavigationBarBackgroundImageTag];
            [navBar insertSubview:imageView atIndex:0];
        }
    }
}

@end
