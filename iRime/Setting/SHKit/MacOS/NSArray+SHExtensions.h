//
//  NSArray+SHExtensions.h
//  SHKit
//
//  Created by Neo on 1/2/13.
//  Copyright (c) 2013 Paradigm X. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SHExtensions)

- (NSArray *)conformToPList;

- (NSUInteger)getIndexOfLongLong:(long long)value;

- (void)forEach:(SEL)selector;
- (void)forEach:(SEL)selector receiver:(id)receiver;
- (void)forEach:(SEL)selector withArg:(id)arg;
- (void)forEach:(SEL)selector receiver:(id)receiver withArg:(id)arg;

- (NSArray *)arrayWithPrefix:(NSString *)prefix;
- (NSArray *)arrayWithSuffix:(NSString *)suffix;

- (int)countEqualObject:(id)object;
- (int)countAssertSelector:(SEL)selector onTarget:(id)target;

+ (id)arrayWithReverseArray:(NSArray *)array;

+ (NSArray *)arrayWithColor:(NSColor*)color;
- (NSColor *)colorValue;
@end