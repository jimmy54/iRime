//
//  SHFoundation.h
//  SHKit
//
//  Created by Neo on 9/13/11.
//  Copyright (c) 2011 Paradigm X. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHFoundation : NSObject

// Objective-C utilities
+ (void)swizzleSelector:(SEL)orig ofClass:(Class)c withSelector:(SEL)alt;
@end
