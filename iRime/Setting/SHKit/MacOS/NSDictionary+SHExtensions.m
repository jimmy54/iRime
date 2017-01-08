//
//  NSDictionary+SHExtensions.m
//  SHKit
//
//  Created by Neo on 1/2/13.
//  Copyright (c) 2013 Paradigm X. All rights reserved.
//

#import "NSDictionary+SHExtensions.h"
#import "NSColor+SHExtensions.h"
#import "NSArray+SHExtensions.h"

@implementation NSDictionary (SHExtensions)

- (NSRect)rectangleForKey:(NSString *)key {
    NSArray *components = [self objectForKey:key];
    if ((components == nil) || (![components isKindOfClass:[NSArray class]])) {
        return NSMakeRect(0.0, 0.0, 0.0, 0.0);
    }

    NS_DURING
    return NSMakeRect([[components objectAtIndex:0] floatValue],
                      [[components objectAtIndex:1] floatValue],
                      [[components objectAtIndex:2] floatValue],
                      [[components objectAtIndex:3] floatValue]);
    NS_HANDLER
    NS_ENDHANDLER

    return NSMakeRect(0.0, 0.0, 0.0, 0.0);
}

- (NSSize)sizeForKey:(NSString *)key {
    NSArray *components = [self objectForKey:key];
    if ((components == nil) || (![components isKindOfClass:[NSArray class]])) {
        return NSMakeSize(0.0, 0.0);
    }

    NS_DURING
    return NSMakeSize([[components objectAtIndex:0] floatValue],
                      [[components objectAtIndex:1] floatValue]);
    NS_HANDLER
    NS_ENDHANDLER

    return NSMakeSize(0.0, 0.0);
}

- (NSPoint)pointForKey:(NSString *)key {
    NSArray *components = [self objectForKey:key];
    if ((components == nil) || (![components isKindOfClass:[NSArray class]])) {
        return NSMakePoint(0.0, 0.0);
    }

    NS_DURING
    return NSMakePoint([[components objectAtIndex:0] floatValue],
                       [[components objectAtIndex:1] floatValue]);
    NS_HANDLER
    NS_ENDHANDLER

    return NSMakePoint(0.0, 0.0);
}

- (NSColor *)colorForKey:(NSString *)key {
    NSDictionary *d = [self objectForKey:key];

    if ((d == nil) || (![d isKindOfClass:[NSDictionary class]])) {
        return nil;
    }

    NSString *colorSpace = [d objectForKey:@"colorSpaceName"];

    if ((colorSpace == nil) || (![colorSpace isKindOfClass:[NSString class]])) {
        return nil;
    }

    NSArray *components = [d objectForKey:@"components"];

    if ((components == nil) || (![colorSpace isKindOfClass:[NSArray class]])) {
        return nil;
    }

    NSColor *color = nil;

    NS_DURING
    if ([colorSpace isEqualToString:NSDeviceWhiteColorSpace]) {
        color = [NSColor colorWithDeviceWhite:[[components objectAtIndex:0] floatValue]
                                        alpha:[[components objectAtIndex:1] floatValue]];
    }
    else if ([colorSpace isEqualToString:NSCalibratedWhiteColorSpace]) {
        color = [NSColor colorWithCalibratedWhite:[[components objectAtIndex:0] floatValue]
                                            alpha:[[components objectAtIndex:1] floatValue]];
    }
    else if ([colorSpace isEqualToString:NSDeviceRGBColorSpace]) {
        color = [NSColor colorWithDeviceRed:[[components objectAtIndex:0] floatValue]
                                      green:[[components objectAtIndex:1] floatValue]
                                       blue:[[components objectAtIndex:2] floatValue]
                                      alpha:[[components objectAtIndex:3] floatValue]];
    }
    else if ([colorSpace isEqualToString:NSCalibratedRGBColorSpace]) {
        color = [NSColor colorWithCalibratedRed:[[components objectAtIndex:0] floatValue]
                                          green:[[components objectAtIndex:1] floatValue]
                                           blue:[[components objectAtIndex:2] floatValue]
                                          alpha:[[components objectAtIndex:3] floatValue]];
    }
    else    {
        [NSException raise:@"Unsupported color space" format:@"Colorspace name is %@", colorSpace];
    }
    NS_HANDLER
    NS_ENDHANDLER
    
    return color;
}

- (NSDictionary *)conformToPList {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:[self count]];
    NSEnumerator *enumerator = [[self allKeys] objectEnumerator];
    id key, obj;

    while (key = [enumerator nextObject]) {
        obj = [self objectForKey:key];
        if ([obj isKindOfClass:[NSNumber class]])
            [result setObject:obj forKey:key];
        else if ([obj isKindOfClass:[NSString class]])
            [result setObject:obj forKey:key];
        else if ([obj isKindOfClass:[NSArray class]])
            [result setObject:[(NSArray *)obj conformToPList] forKey:key];
        else if ([obj isKindOfClass:[NSDictionary class]])
            [result setObject:[(NSDictionary *)obj conformToPList] forKey:key];
        else if ([obj isKindOfClass:[NSData class]])
            [result setObject:obj forKey:key];
        else if ([obj isKindOfClass:[NSDate class]])
            [result setObject:obj forKey:key];
        else if ([obj isKindOfClass:[NSColor class]])
            [result setObject:[(NSColor *)obj asFloatArray] forKey:key];
        else {
            NSLog(@"Unsupported data class %@", [obj class]);
            [NSException raise:@"Unsupported data class" format:@"Unsupported data class %@", [obj class]];
        }
    }

    return result;
}

@end

@implementation NSMutableDictionary (SHExtensions)

- (void)setRectangle:(NSRect)rect forKey:(NSString *)key
{
    [self setObject:[NSArray arrayWithObjects:
                     [NSNumber numberWithFloat:rect.origin.x],
                     [NSNumber numberWithFloat:rect.origin.y],
                     [NSNumber numberWithFloat:rect.size.width],
                     [NSNumber numberWithFloat:rect.size.height],
                     nil
                     ] forKey:key];
}

- (void)setSize:(NSSize)size forKey:(NSString *)key
{
    [self setObject:[NSArray arrayWithObjects:
                     [NSNumber numberWithFloat:size.width],
                     [NSNumber numberWithFloat:size.height],
                     nil
                     ] forKey:key];
}

- (void)setPoint:(NSPoint)point forKey:(NSString *)key {
    [self setObject:[NSArray arrayWithObjects:
                     [NSNumber numberWithFloat:point.x],
                     [NSNumber numberWithFloat:point.y],
                     nil
                     ] forKey:key];
}

- (void)setColor:(NSColor *)color forKey:(NSString *)key {
    NSString *colorSpace = [color colorSpaceName];
    NSArray *components = nil;
    
    if (([colorSpace isEqualToString:NSDeviceWhiteColorSpace]) ||
        ([colorSpace isEqualToString:NSCalibratedWhiteColorSpace])) {
        components = [NSArray arrayWithObjects:
                      [NSNumber numberWithFloat:[color whiteComponent]],
                      [NSNumber numberWithFloat:[color alphaComponent]],
                      nil
                      ];
    }
    else if (([colorSpace isEqualToString:NSDeviceRGBColorSpace]) ||
             ([colorSpace isEqualToString:NSCalibratedRGBColorSpace])) {
        components = [NSArray arrayWithObjects:
                      [NSNumber numberWithFloat:[color redComponent]],
                      [NSNumber numberWithFloat:[color greenComponent]],
                      [NSNumber numberWithFloat:[color blueComponent]],
                      [NSNumber numberWithFloat:[color alphaComponent]],
                      nil
                      ];
    }
    else {
        [NSException raise:@"Unsupported color space" format:@"Colorspace name is %@", colorSpace];
    }
    
    [self setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                     colorSpace, @"colorSpaceName",
                     components, @"components",
                     nil
                     ] forKey:key];
}

// Input array element format: key=value
- (void)fillWithStringArray:(NSArray *)array {
    NSEnumerator *enumerator = [array objectEnumerator];
    NSString *s;
    
    while ((s = [enumerator nextObject]) != nil) {
        NSRange r = [s rangeOfString:@"="];
        if ((r.location != NSNotFound) && (r.location > 0) && (r.location < [s length] - 1)) {
            NSString *key = [s substringToIndex:r.location];
            NSString *value = [s substringFromIndex:(r.location+1)];
            [self setObject:value forKey:key];
        }
    }
}

@end
