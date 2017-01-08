//
//  NSDictionary+SHExtensions.h
//  SHKit
//
//  Created by Neo on 1/2/13.
//  Copyright (c) 2013 Paradigm X. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSColor;

@interface NSDictionary (SHExtensions)

- (NSRect)rectangleForKey:(NSString *)key;
- (NSSize)sizeForKey:(NSString *)key;
- (NSPoint)pointForKey:(NSString *)key;
- (NSColor *)colorForKey:(NSString *)key;

- (NSDictionary *)conformToPList;
@end

@interface NSMutableDictionary (SHExtensions)

- (void)setRectangle:(NSRect)rect forKey:(NSString *)key;
- (void)setSize:(NSSize)size forKey:(NSString *)key;
- (void)setPoint:(NSPoint)point forKey:(NSString *)key;
- (void)setColor:(NSColor *)color forKey:(NSString *)key;

- (void)fillWithStringArray:(NSArray *)array;

@end
