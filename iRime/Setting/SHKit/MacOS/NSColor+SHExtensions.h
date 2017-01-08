//
//  NSColor+SHExtensions.h
//  SHKit
//
//  Created by Neo on 1/2/13.
//  Copyright (c) 2013 Paradigm X. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (SHExtensions)

// RGBA for arrays and dictionaries: [red, green, blue, alpha]
// ARGB for integers and hex strings

- (NSArray *)asStringArray;
- (NSArray *)asFloatArray;
- (NSDictionary *)asDictionary;
- (int)asInteger;

+ (NSColor *)colorWithArray:(NSArray *)array;
+ (NSColor *)colorWithDictionary:(NSDictionary *)dictionary;
+ (NSColor *)colorWithInteger:(int)value;
+ (NSColor *)colorWithHexString:(NSString *)hexString;
@end
