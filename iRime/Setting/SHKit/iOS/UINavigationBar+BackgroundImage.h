//
//  UINavigationBar+BackgroundImage.h
//  SHKit
//
//  Created by Neo on 9/13/11.
//  Copyright (c) 2011 Paradigm X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (BackgroundImage)

- (void)shInsertSubview:(UIView *)view atIndex:(NSInteger)index;
- (void)shSendSubviewToBack:(UIView *)view;
@end
