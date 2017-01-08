//
//  UINavigationBar+BackgroundImage.m
//  SHKit
//
//  Created by Neo on 9/13/11.
//  Copyright (c) 2011 Paradigm X. All rights reserved.
//

#import "UINavigationBar+BackgroundImage.h"
#import "SHUIKit.h"

@implementation UINavigationBar (BackgroundImage)

- (void)shInsertSubview:(UIView *)view atIndex:(NSInteger)index {
    [self shInsertSubview:view atIndex:index];
    
    UIView *backgroundImageView = [self viewWithTag:kSCNavigationBarBackgroundImageTag];
    if (backgroundImageView != nil)
    {
        [self shSendSubviewToBack:backgroundImageView];
    }
}

- (void)shSendSubviewToBack:(UIView *)view {
    [self shSendSubviewToBack:view];
    
    UIView *backgroundImageView = [self viewWithTag:kSCNavigationBarBackgroundImageTag];
    if (backgroundImageView != nil)
    {
        [self shSendSubviewToBack:backgroundImageView];
    }
}

@end
