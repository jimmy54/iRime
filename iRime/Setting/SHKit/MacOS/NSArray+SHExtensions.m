//
//  NSArray+SHExtensions.m
//  SHKit
//
//  Created by Neo on 1/2/13.
//  Copyright (c) 2013 Paradigm X. All rights reserved.
//

#import "NSArray+SHExtensions.h"
#import "NSDictionary+SHExtensions.h"

#import <objc/objc-runtime.h>

@implementation NSArray (SHExtensions)

- (NSArray *)conformToPList {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self objectEnumerator];
    id obj;

    while (obj = [enumerator nextObject]) {
        if ([obj isKindOfClass:[NSNumber class]])
            [result addObject:obj];
        else if ([obj isKindOfClass:[NSString class]])
            [result addObject:obj];
        else if ([obj isKindOfClass:[NSArray class]])
            [result addObject:[(NSArray *)obj conformToPList]];
        else if ([obj isKindOfClass:[NSDictionary class]])
            [result addObject:[(NSDictionary *)obj conformToPList]];
        else if ([obj isKindOfClass:[NSData class]])
            [result addObject:obj];
        else if ([obj isKindOfClass:[NSDate class]])
            [result addObject:obj];
        else {
            NSLog(@"Unsupported data class %@", [obj class]);
            [NSException raise:@"Unsupported data class" format:@"Unsupported data class %@", [obj class]];
        }
    }

    return result;
}

- (NSUInteger)getIndexOfLongLong:(long long)value {
    NSUInteger i, n = [self count];

    for (i = 0; i < n; i++) {
        NSNumber *num = (NSNumber *)[self objectAtIndex:i];

        if ([num longLongValue] == value) return i;
    }

    return -1;
}

- (void)forEach:(SEL)selector {
    // Could use [self makeObjectsPerformSelector:selector]
    NSUInteger i, n = [self count];

    for (i = 0; i < n; i++) {
        id obj = [self objectAtIndex:i];

        if ([obj respondsToSelector:selector]) objc_msgSend(obj, selector);
    }
}

- (void)forEach:(SEL)selector receiver:(id)receiver {
    NSUInteger i, n = [self count];

    for (i = 0; i < n; i++) {
        id obj = [self objectAtIndex:i];

        objc_msgSend(receiver, selector, obj);
    }
}

- (void)forEach:(SEL)selector withArg:(id)arg {
    // Could use [self makeObjectsPerformSelector:selector withObject:arg]
    NSUInteger i, n = [self count];

    for (i = 0; i < n; i++) {
        id obj = [self objectAtIndex:i];

        if ([obj respondsToSelector:selector]) objc_msgSend(obj, selector, arg);
    }
}

- (void)forEach:(SEL)selector receiver:(id)receiver withArg:(id)arg {
    NSUInteger i, n = [self count];

    for (i = 0; i < n; i++) {
        id obj = [self objectAtIndex:i];

        objc_msgSend(receiver, selector, obj, arg);
    }
}

- (NSArray *)arrayWithPrefix:(NSString *)prefix {
    NSEnumerator *enumerator = [self objectEnumerator];
    id obj;
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];

    while (obj = [enumerator nextObject]) {
        [result addObject:[prefix stringByAppendingString:[obj description]]];
    }

    return result;
}

- (NSArray *)arrayWithSuffix:(NSString *)suffix {
    NSEnumerator *enumerator = [self objectEnumerator];
    id obj;
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];

    while (obj = [enumerator nextObject]) {
        [result addObject:[[obj description] stringByAppendingString:suffix]];
    }

    return result;
}

- (int)countEqualObject:(id)object {
    NSEnumerator *enumerator = [self objectEnumerator];
    id obj;
    int result = 0;

    while (obj = [enumerator nextObject]) {
        if ([obj isEqualTo:object]) result++;
    }

    return result;
}

- (int)countAssertSelector:(SEL)selector onTarget:(id)target {
    if (![target respondsToSelector:selector]) return 0;

    NSEnumerator *enumerator = [self objectEnumerator];
    id obj;
    int result = 0;

    while (obj = [enumerator nextObject]) {
        if (objc_msgSend(target, selector, obj)) result++;
    }

    return result;
}

+ (id)arrayWithReverseArray:(NSArray *)array {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[array count]];
    NSEnumerator *enumerator = [array reverseObjectEnumerator];
    id item;

    while ((item = [enumerator nextObject]) != nil) {
        [result addObject:item];
    }

    return [NSArray arrayWithArray:result];
}

+ (NSArray *)arrayWithColor:(NSColor*)color {
    double red, green, blue, alpha;

    [color getRed:&red green:&green blue:&blue alpha:&alpha];

    return [self arrayWithObjects:[NSNumber numberWithDouble:red], [NSNumber numberWithDouble:green],
            [NSNumber numberWithDouble:blue], [NSNumber numberWithDouble:alpha], nil];
}

- (NSColor *)colorValue {
    double red, green, blue, alpha = 1.0;

    red = [[self objectAtIndex:0] doubleValue];
    green = [[self objectAtIndex:1] doubleValue];
    blue = [[self objectAtIndex:2] doubleValue];
    if( [self count] > 3 )
        alpha = [[self objectAtIndex:3] doubleValue];

    return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
}

@end
