//
//  NSString+SHExtensions.m
//  SHKit
//
//  Created by Neo on 1/2/13.
//  Copyright (c) 2013 Paradigm X. All rights reserved.
//

#import "NSString+SHExtensions.h"

@implementation NSString (SHExtensions)

+ (NSString *)stringWithBool:(BOOL)value {
    return value ? @"true" : @"false";
}

@end
