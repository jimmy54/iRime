//
//  SHUIKit.h
//  SHKit
//
//  Created by Neo on 9/13/11.
//  Copyright (c) 2011 Paradigm X. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kSCNavigationBarBackgroundImageTag 6183746

@interface SHUIKit : NSObject

+ (BOOL)canConfigureAppearanceOfClass:(Class)c;
+ (void)customizeNavigationBar:(UINavigationController *)navController backgroundImage:(UIImage *)image tintColor:(UIColor *)color;
@end
