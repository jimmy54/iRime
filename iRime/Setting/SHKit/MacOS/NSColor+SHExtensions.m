//
//  NSColor+SHExtensions.m
//  SHKit
//
//  Created by Neo on 1/2/13.
//  Copyright (c) 2013 Paradigm X. All rights reserved.
//

#import "NSColor+SHExtensions.h"

@implementation NSColor (SHExtensions)

- (NSArray *)asStringArray{
    NSColor *rgbaColor = [self colorUsingColorSpaceName:NSDeviceRGBColorSpace];
    NSString *red = [NSString stringWithFormat:@"%f", [rgbaColor redComponent]];
    NSString *green = [NSString stringWithFormat:@"%f", [rgbaColor greenComponent]];
    NSString *blue = [NSString stringWithFormat:@"%f", [rgbaColor blueComponent]];
    NSString *alpha = [NSString stringWithFormat:@"%f", [rgbaColor alphaComponent]];
    
    return [NSArray arrayWithObjects:red, green, blue, alpha, nil];
}

- (NSArray *)asFloatArray {
    NSColor *rgbaColor = [self colorUsingColorSpaceName:NSDeviceRGBColorSpace];
    NSNumber *red = [NSNumber numberWithFloat:[rgbaColor redComponent]];
    NSNumber *green = [NSNumber numberWithFloat:[rgbaColor greenComponent]];
    NSNumber *blue = [NSNumber numberWithFloat:[rgbaColor blueComponent]];
    NSNumber *alpha = [NSNumber numberWithFloat:[rgbaColor alphaComponent]];

    return [NSArray arrayWithObjects:red, green, blue, alpha, nil];
}

- (NSDictionary *)asDictionary {
    NSColor *rgbaColor = [self colorUsingColorSpaceName:NSDeviceRGBColorSpace];
    NSNumber *red = [NSNumber numberWithFloat:[rgbaColor redComponent]];
    NSNumber *green = [NSNumber numberWithFloat:[rgbaColor greenComponent]];
    NSNumber *blue = [NSNumber numberWithFloat:[rgbaColor blueComponent]];
    NSNumber *alpha = [NSNumber numberWithFloat:[rgbaColor alphaComponent]];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:red, @"red", green, @"green", blue, @"blue", alpha, @"alpha", nil];
}

- (int)asInteger {
    return ((int)(([self alphaComponent]) * 255.0) << 24) | ((int)([self redComponent] * 255.0) << 16) | ((int)([self greenComponent] * 255.0) << 8) | ((int)([self blueComponent] * 255.0));
}

+ (NSColor *)colorWithArray:(NSArray *)array {
    return [NSColor colorWithDeviceRed:[[array objectAtIndex:0] floatValue]
                                 green:[[array objectAtIndex:1] floatValue]
                                  blue:[[array objectAtIndex:2] floatValue]
                                 alpha:[[array objectAtIndex:3] floatValue]];
}

+ (NSColor *)colorWithDictionary:(NSDictionary *)dictionary {
    return [NSColor colorWithDeviceRed:[[dictionary objectForKey:@"red"] floatValue]
                                 green:[[dictionary objectForKey:@"green"] floatValue]
                                  blue:[[dictionary objectForKey:@"blue"] floatValue]
                                 alpha:[[dictionary objectForKey:@"alpha"] floatValue]];
}

+ (NSColor *)colorWithInteger:(int)value {
    return [NSColor colorWithDeviceRed:((float)((value & 0x00FF0000) >> 16))/255.0
                                 green:((float)((value & 0x0000FF00) >> 8))/255.0
                                  blue:((float)(value & 0x000000FF))/255.0
                                 alpha:((float)((value & 0xFF000000) >> 24))/255.0];
}

+ (NSColor *)colorWithHexString:(NSString *)hexString {
    NSScanner *hexScanner = [NSScanner scannerWithString:hexString];
    unsigned value;

    if ([hexScanner scanHexInt:&value])
        return [self colorWithInteger:(value | 0xFF000000)];
    
    return [NSColor clearColor];
}

@end
