//
//  YACYAMLUnarchivingExtensions.m
//  YACYAML
//
//  Created by James Montgomerie on 29/05/2012.
//  Copyright (c) 2012 James Montgomerie. All rights reserved.
//

#import "YACYAMLUnarchivingExtensions.h"

#include <xlocale.h>
#include <resolv.h>


@interface YACYAMLMergeKey : NSObject
@end

static YACYAMLMergeKey *sSharedYACYAMLMergeKey;

/*
@implementation NSString (YACYAMLArchivingExtensions)
@end
*/

void YACYAMLUnarchivingExtensionsRegister(void)
{
    [YACYAMLKeyedUnarchiver registerUnarchivingClass:[NSArray class]];
    [YACYAMLKeyedUnarchiver registerUnarchivingClass:[NSDictionary class]];
    [YACYAMLKeyedUnarchiver registerUnarchivingClass:[NSNumber class]];
    [YACYAMLKeyedUnarchiver registerUnarchivingClass:[NSData class]];
    [YACYAMLKeyedUnarchiver registerUnarchivingClass:[NSSet class]];
    [YACYAMLKeyedUnarchiver registerUnarchivingClass:[NSNull class]];
    [YACYAMLKeyedUnarchiver registerUnarchivingClass:[NSDate class]];
    [YACYAMLKeyedUnarchiver registerUnarchivingClass:[YACYAMLMergeKey class]];
}

@implementation NSNumber (YACYAMLUnarchivingExtensions)

+ (NSArray *)YACYAMLUnarchivingTags
{
    return [[NSArray alloc] initWithObjects:
            @"tag:yaml.org,2002:float",
            @"tag:yaml.org,2002:int",
            @"tag:yaml.org,2002:bool",
            nil];
}

static NSRegularExpression *YACYAMLIntRegularExpression(void)
{
    // http://yaml.org/type/int.html
    // [-+]?0b[0-1_]+ # (base 2)
    // |[-+]?0[0-7_]+ # (base 8)
    // |[-+]?(0|[1-9][0-9_]*) # (base 10)
    // |[-+]?0x[0-9a-fA-F_]+ # (base 16)
    // |[-+]?[1-9][0-9_]*(:[0-5]?[0-9])+ # (base 60)
    
    static NSRegularExpression *expression;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        expression = [NSRegularExpression regularExpressionWithPattern:@"^([-+]?0b[0-1_]+|[-+]?0[0-7_]+|[-+]?(0|[1-9][0-9_]*)|[-+]?0x[0-9a-fA-F_]+|[-+]?[1-9][0-9_]*(:[0-5]?[0-9])+)$"
                                                               options:0
                                                                 error:nil];
    });
    
    return expression;
}


static NSRegularExpression *YACYAMLFloatRegularExpression(void)
{
    // http://yaml.org/type/float.html
    // [-+]?([0-9][0-9_]*)?\.[0-9.]*([eE][-+][0-9]+)? (base 10)
    // |[-+]?[0-9][0-9_]*(:[0-5]?[0-9])+\.[0-9_]* (base 60)
    
    static NSRegularExpression *expression;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        expression = [NSRegularExpression regularExpressionWithPattern:@"^([-+]?([0-9][0-9_]*)?\\.[0-9.]*([eE][-+][0-9]+)?|[-+]?[0-9][0-9_]*(:[0-5]?[0-9])+\\.[0-9_]*)$"
                                                               options:0
                                                                 error:nil];
    });
    
    return expression;
}

static NSSet *YACYAMLInfinitySet(void)
{
    // http://yaml.org/type/float.html
    // [-+]?\.(inf|Inf|INF) # (infinity)
    
    static NSSet *set;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        set = [NSSet setWithObjects:@".inf", @".Inf", @".INF",
                                    @"-.inf", @"-.Inf", @"-.INF",
                                    @"+.inf", @"+.Inf", @"+.INF",
                                    nil];
    });
    
    return set;
}

static NSSet *YACYAMLNotANumberSet(void)
{
    // http://yaml.org/type/float.html
    // \.(nan|NaN|NAN)
    
    static NSSet *set;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        set = [NSSet setWithObjects:@".nan", @".NaN", @".NAN", nil];
    });
    
    return set;
}

static NSSet *YACYAMLBoolTrueSet(void)
{
    // http://yaml.org/type/bool.html
    // y|Y|yes|Yes|YES|n|N|no|No|NO
    // |true|True|TRUE|false|False|FALSE
    // |on|On|ON|off|Off|OFF
    
    static NSSet *set;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        set = [NSSet setWithObjects:@"y", @"Y", @"yes", @"Yes", @"YES",
                                    @"true", @"True", @"TRUE",
                                    @"on", @"On", @"ON",
                                    nil];
    });
    
    return set;
}

static NSSet *YACYAMLBoolFalseSet(void)
{
    // http://yaml.org/type/bool.html
    // y|Y|yes|Yes|YES|n|N|no|No|NO
    // |true|True|TRUE|false|False|FALSE
    // |on|On|ON|off|Off|OFF
    
    static NSSet *set;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        set = [NSSet setWithObjects:@"n", @"N", @"no", @"No", @"NO",
                                    @"false", @"false", @"FALSE",
                                    @"off", @"Off", @"OFF",
                                    nil];
    });
    
    return set;
}


+ (BOOL)YACYAMLImplicitlyMatchesScalarString:(NSString *)scalarString;
{
    NSRange scalarStringRange = NSMakeRange(0, scalarString.length);
    return [YACYAMLIntRegularExpression() rangeOfFirstMatchInString:scalarString
                                                            options:0
                                                              range:scalarStringRange].location != NSNotFound ||
           [YACYAMLFloatRegularExpression() rangeOfFirstMatchInString:scalarString
                                                              options:0
                                                                range:scalarStringRange].location != NSNotFound ||
           [YACYAMLInfinitySet() containsObject:scalarString] ||
           [YACYAMLNotANumberSet() containsObject:scalarString] ||
           [YACYAMLBoolTrueSet() containsObject:scalarString] ||
           [YACYAMLBoolFalseSet() containsObject:scalarString];
}


+ (id)objectWithYACYAMLScalarString:(NSString *)string
{
    NSRange stringRange = NSMakeRange(0, string.length);
    if([YACYAMLIntRegularExpression() rangeOfFirstMatchInString:string
                                                        options:0
                                                          range:stringRange].location != NSNotFound) {
        NSNumber *numberObject = nil;
        
        const char *chars = [string UTF8String];
        const char *cursor = chars;            

        if(*cursor) {
            if(strchr(chars, ':') != NULL) {
                long long signedInteger = 0;

                BOOL negative = NO;
                
                if(*cursor == '-') {
                    negative = YES;
                    ++cursor;
                } else if(*cursor == '+') {
                    ++cursor;
                }
                
                long long last60part = 0;
                while(*cursor && *cursor != '.') {
                    if(*cursor != '_') {
                        if(*cursor == ':') {
                            last60part *= 60;
                            last60part += signedInteger;
                            signedInteger = 0;
                        } else {
                            signedInteger *= 10;
                            signedInteger += *cursor - '0';
                        }
                    }
                    ++cursor;
                }
                
                last60part *= 60;
                signedInteger += last60part;
                
                if(negative) {
                    signedInteger = -signedInteger;
                }
                
                numberObject = [NSNumber numberWithLongLong:signedInteger];
            } else {
                BOOL isBinary = NO;
                
                // Strip out '_' characters, which YAML allows for spacing.
                char *canonicalString = calloc(strlen(cursor) + 1, 1);
                char *canonicalCursor = canonicalString;
                while(*cursor) {
                    if(*cursor != '_') {
                        if(*cursor == 'b') {
                            isBinary = YES;
                        } else {
                            *canonicalCursor++ = *cursor;
                        }
                    }
                    ++cursor;
                } 
                
                // Explicitly pass the base in if we know it's binary,
                // otherwise let strtoll_l parse the base.
                long long signedInteger = strtoll_l(canonicalString, NULL, isBinary ? 2 : 0, _c_locale);
                if(signedInteger == LLONG_MAX && errno == ERANGE) {
                    // A positive value larger than LLONG_MAX (can't fit in a signed long long).
                    // We'll try decoding it into an unsigned long long.
                    unsigned long long unsignedInteger = strtoull_l(canonicalString, NULL, isBinary ? 2 : 0, _c_locale);
                    numberObject = [NSNumber numberWithUnsignedLongLong:unsignedInteger];
                } else {
                    numberObject = [NSNumber numberWithLongLong:signedInteger];
                }
                
                free(canonicalString);
            }
        }
        
        return numberObject  ?: [NSNumber numberWithInteger:0];
    } else if([YACYAMLFloatRegularExpression() rangeOfFirstMatchInString:string
                                                                 options:0
                                                                   range:stringRange].location != NSNotFound) {
        const char *chars = [string UTF8String];
        const char *cursor = chars;            

        // YAML allows the part before the decimal point to be
        // in 'base 60' - e.g. 190:20:30.15 == 685230.15.
        // Here, we work out the base 60 part if necessary, before
        // leaving the C library to do the conversion for the rest of
        // the number.  We'll add the two numebrs together at the end.
        double base60Part = 0;
        if(strchr(chars, ':') != NULL) {
            BOOL negative = NO;
            
            if(*cursor == '-') {
                negative = YES;
                ++cursor;
            } else if(*cursor == '+') {
                ++cursor;
            }
            
            double last60part = 0;
            while(*cursor && *cursor != '.') {
                if(*cursor != '_') {
                    if(*cursor == ':') {
                        last60part *= 60;
                        last60part += base60Part;
                        base60Part = 0;
                    } else {
                        base60Part *= 10;
                        base60Part += *cursor - '0';
                    }
                }
                ++cursor;
            }
            
            last60part *= 60;
            base60Part += last60part;
            
            if(negative) {
                base60Part = -base60Part;
            }
        }

        double d = 0;
        if(*cursor) {
            // Use strtod to do the conversion so that we don't need to worry
            // about canonical string -> double conversion ourselves.
            // First, we strip out '_' characters, which YAML allows for
            // spacing.
            char *canonicalString = calloc(strlen(cursor) + 1, 1);
            char *canonicalCursor = canonicalString;
            while(*cursor) {
                if(*cursor != '_') {
                    *canonicalCursor++ = *cursor;
                }
                ++cursor;
            }
            d = strtod_l(canonicalString, NULL, _c_locale);
            free(canonicalString);
        }
        
        if(base60Part) {
            if(base60Part < 0) {
                d = base60Part - d;
            } else {
                d += base60Part;
            }
        }
        
        return [NSNumber numberWithDouble:d];
    } else if([YACYAMLInfinitySet() containsObject:string]) {
        if([string characterAtIndex:0] == '-') {
            return (__bridge NSNumber *)kCFNumberNegativeInfinity;
        } else {
            return (__bridge NSNumber *)kCFNumberPositiveInfinity;
        }
    } else if([YACYAMLNotANumberSet() containsObject:string]) {
        return (__bridge NSNumber *)kCFNumberNaN;
    } else if([YACYAMLBoolTrueSet() containsObject:string]) {
        return (__bridge NSNumber *)kCFBooleanTrue;
    } else if([YACYAMLBoolFalseSet() containsObject:string]) {
        return (__bridge NSNumber *)kCFBooleanFalse;
    } else {
        NSLog(@"Warning: Could not parse string \"%@\" to NSNumber, using string as-is", string);
        return string;
    }
}

@end


@implementation NSDate (YACYAMLUnarchivingExtensions)

+ (NSArray *)YACYAMLUnarchivingTags
{
    return [[NSArray alloc] initWithObjects:
            @"tag:yaml.org,2002:timestamp",
            nil];
}

static NSRegularExpression *YACYAMLTimestampYMDRegularExpression(void)
{
    // http://yaml.org/type/timestamp.html
    // [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] # (ymd)
    
    static NSRegularExpression *expression;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        expression = [NSRegularExpression regularExpressionWithPattern:@"^([0-9][0-9][0-9][0-9])-([0-9][0-9])-([0-9][0-9])$"
                                                               options:0 
                                                                 error:nil];        
    });
    
    return expression;
}

static NSRegularExpression *YACYAMLTimestampComplicatedRegularExpression(void)
{
    // http://yaml.org/type/timestamp.html
    // [0-9][0-9][0-9][0-9] # (year)
    // -[0-9][0-9]? # (month)
    // -[0-9][0-9]? # (day)
    // ([Tt]|[ \t]+)[0-9][0-9]? # (hour)
    // :[0-9][0-9] # (minute)
    // :[0-9][0-9] # (second)
    // (\.[0-9]*)? # (fraction)
    // (([ \t]*)Z|[-+][0-9][0-9]?(:[0-9][0-9])?)? # (time zone)

    
    static NSRegularExpression *expression;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        expression = [NSRegularExpression regularExpressionWithPattern:@"^"
                      "([0-9][0-9][0-9][0-9])"                           // (year)
                      "-([0-9][0-9]?)"                                   // (month)
                      "-([0-9][0-9]?)"                                   // (day)
                      "(([Tt]|[ \\t]+)([0-9][0-9]?))"                    // (hour)
                      ":([0-9][0-9])"                                    // (minute)
                      ":([0-9][0-9])"                                    // (second)
                      "(\\.[0-9]*)?"                                     // (fraction)
                      "(([ \t]*)(Z|([-+][0-9][0-9]?)(:([0-9][0-9]))?))?" // (time zone)
                      "$"
                                                               options:0 
                                                                 error:nil];        
    });
    
    return expression;
}


+ (BOOL)YACYAMLImplicitlyMatchesScalarString:(NSString *)scalarString;
{
    NSRange scalarStringRange = NSMakeRange(0, scalarString.length);
    return [YACYAMLTimestampYMDRegularExpression() rangeOfFirstMatchInString:scalarString
                                                                     options:0
                                                                       range:scalarStringRange].location != NSNotFound ||
           [YACYAMLTimestampComplicatedRegularExpression() rangeOfFirstMatchInString:scalarString
                                                                             options:0
                                                                               range:scalarStringRange].location != NSNotFound;
}

+ (id)objectWithYACYAMLScalarString:(NSString *)string
{
    NSRange stringRange = NSMakeRange(0, string.length);

    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    NSTextCheckingResult *ymdMatch = [YACYAMLTimestampYMDRegularExpression() firstMatchInString:string  
                                                                                        options:0
                                                                                          range:stringRange];
    
    NSTimeInterval secondsFraction = 0;
    
    if(ymdMatch) {
        dateComponents.year =  [[string substringWithRange:[ymdMatch rangeAtIndex:1]] integerValue];
        dateComponents.month = [[string substringWithRange:[ymdMatch rangeAtIndex:2]] integerValue];
        dateComponents.day =   [[string substringWithRange:[ymdMatch rangeAtIndex:3]] integerValue];
        dateComponents.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    } else {
         NSTextCheckingResult *match = [YACYAMLTimestampComplicatedRegularExpression() firstMatchInString:string  
                                                                                                     options:0
                                                                                                    range:stringRange];
        
        dateComponents.year =    [[string substringWithRange:[match rangeAtIndex:1]] integerValue];
        dateComponents.month =   [[string substringWithRange:[match rangeAtIndex:2]] integerValue];
        dateComponents.day =     [[string substringWithRange:[match rangeAtIndex:3]] integerValue];
        dateComponents.hour =    [[string substringWithRange:[match rangeAtIndex:6]] integerValue];
        dateComponents.minute =  [[string substringWithRange:[match rangeAtIndex:7]] integerValue];
        dateComponents.second =  [[string substringWithRange:[match rangeAtIndex:8]] integerValue];
        
        NSRange secondsFractionRange = [match rangeAtIndex:9];
        if(secondsFractionRange.length) {
            secondsFraction = [[string substringWithRange:secondsFractionRange] doubleValue]; 
        }
        
        NSInteger secondsFromGMT = 0;
        if([match rangeAtIndex:10].length) {
            NSRange timeZoneHoursOffsetRange = [match rangeAtIndex:13];

            if(timeZoneHoursOffsetRange.length) {
                NSInteger timeZoneHoursOffset = [[string substringWithRange:timeZoneHoursOffsetRange] integerValue];

                secondsFromGMT = timeZoneHoursOffset * 60 * 60;
                
                NSRange timeZoneMinutesOffsetRange = [match rangeAtIndex:15];
                if(timeZoneMinutesOffsetRange.length) {
                    NSInteger timeZoneMinutesOffset = [[string substringWithRange:timeZoneMinutesOffsetRange] integerValue];
                    secondsFromGMT += timeZoneMinutesOffset * 60;
                }
            } 
        } 
        dateComponents.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:secondsFromGMT];
    }
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calender.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    NSDate *ret = [calender dateFromComponents:dateComponents];
    if(secondsFraction) {
        ret = [ret dateByAddingTimeInterval:secondsFraction];
    }
    return ret;
}

@end


@implementation NSData (YACYAMLUnarchivingExtensions)

+ (NSArray *)YACYAMLUnarchivingTags
{
    return [[NSArray alloc] initWithObjects:
            @"tag:yaml.org,2002:binary",
            nil];
}

+ (id)objectWithYACYAMLScalarUTF8String:(const char *)UTF8String length:(NSUInteger)length
{
    NSData *decodedData = nil;
    
    NSUInteger decodedBufferLength = length * 3 / 4;
    uint8_t* decodedBuffer = malloc(decodedBufferLength);
    
    int decodedBufferRealLength = b64_pton(UTF8String, 
                                           decodedBuffer, 
                                           decodedBufferLength);
    
    if(decodedBufferRealLength >= 0) {
        decodedData = [[NSData alloc] initWithBytesNoCopy:decodedBuffer 
                                                   length:decodedBufferRealLength 
                                             freeWhenDone:YES];
    } else {
        free(decodedBuffer);
    }    
    
    return decodedData;
}

@end

@implementation NSNull (YACYAMLUnarchivingExtensions)

+ (NSArray *)YACYAMLUnarchivingTags
{
    return [[NSArray alloc] initWithObjects:
            @"tag:yaml.org,2002:null",
            nil];
}

static NSSet *YACYAMLNullSet(void)
{
    // http://yaml.org/type/null.html
    // ~ # (canonical)
    // |null|Null|NULL # (English)
    // | # (Empty)
    
    static NSSet *set;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        set = [NSSet setWithObjects:@"~",
                                    @"null", @"Null", @"NULL",
                                    @"",
                                    nil];
    });
    
    return set;
}


+ (BOOL)YACYAMLImplicitlyMatchesScalarString:(NSString *)scalarString;
{
    return [YACYAMLNullSet() containsObject:scalarString];
}

+ (id)objectWithYACYAMLScalarString:(NSString *)string;
{
    return (__bridge NSNull *)kCFNull;
}

@end

@implementation NSArray (YACYAMLUnarchivingExtensions)

+ (NSArray *)YACYAMLUnarchivingTags
{
    return [[NSArray alloc] initWithObjects:
            @"tag:yaml.org,2002:seq",
            nil];
}

+ (id)objectForYACYAMLUnarchiving
{
    return [[NSMutableArray alloc] init];
}

- (void)YACYAMLUnarchivingAddObject:(id)object
{
    // Note that althouth this category is on NSArray, we know that this 
    // instance is guaranteed to be one returned by 
    // +objectForYACYAMLUnarchiving.
    [(NSMutableArray *)self addObject:object];
}

@end

@implementation NSDictionary (YACYAMLUnarchivingExtensions)

+ (NSArray *)YACYAMLUnarchivingTags
{
    return [[NSArray alloc] initWithObjects:
            @"tag:yaml.org,2002:map",
            nil];
}

+ (id)objectForYACYAMLUnarchiving
{
    // We use a CFMutableDictionary rather than an NSMutableDictionary so that
    // we can retain the decoded keys, rather than copying them as 
    // NSMutableDictionary insists on.
    // See comments below in this class's YACYAMLUnarchivingSetObject:forKey:
    return (__bridge_transfer id)CFDictionaryCreateMutable(kCFAllocatorDefault, 
                                                          0, 
                                                          &kCFTypeDictionaryKeyCallBacks, 
                                                          &kCFTypeDictionaryValueCallBacks);
}

static void YACYAMLCFDictionaryMergeFromOtherDictionary(const void *key, const void *value, void *context) 
{
    CFDictionarySetValue((CFMutableDictionaryRef)context, key,  value);
}

- (void)YACYAMLUnarchivingSetObject:(id)object forKey:(id)key
{
    BOOL mappingHandled = NO;
    
    if(key == sSharedYACYAMLMergeKey) {
        if([object isKindOfClass:[NSDictionary class]]) {
            CFDictionaryApplyFunction((__bridge void *)object,
                                      YACYAMLCFDictionaryMergeFromOtherDictionary,
                                      (__bridge CFMutableDictionaryRef)self);
            mappingHandled = YES;
        } else if([object isKindOfClass:[NSArray class]]) {
            // Enumerate in reverse because "Keys in mapping nodes earlier in
            // the sequence override keys specified in later mapping nodes"
            for(NSDictionary *mapping in ((NSArray *)object).reverseObjectEnumerator) {
                [self YACYAMLUnarchivingSetObject:mapping forKey:sSharedYACYAMLMergeKey];
            }
            mappingHandled = YES;
        } else {
            // We can't handle this merge - it is corrupt.
            // Turn the key back into a string so that something sensible
            // is created.
            key = @"<<";
        }
    }
        
    if(!mappingHandled) {
        // Again, using the CF method to avoid NSMutableDictionary's copying of
        // the key.  This matches the YAML spec when aliases are used as keys
        // (the exact anchored object the alias references will be used), and also
        // allows the use of objects that don't conform to NSCopying as keys, which
        // is possible in a YAML document (if not very plausible that it'll happen
        // in real life).
        // Note that although this category is on NSDictionary, we know that this
        // instance is guaranteed to be one returned by
        // +objectForYACYAMLUnarchiving.
        CFDictionarySetValue((__bridge CFMutableDictionaryRef)self,
                             (__bridge CFTypeRef)key,
                             (__bridge CFTypeRef)object);
    }
}

@end

@implementation NSSet (YACYAMLUnarchivingExtensions)

+ (NSArray *)YACYAMLUnarchivingTags
{
    return [[NSArray alloc] initWithObjects:
            @"tag:yaml.org,2002:set",
            nil];
}

+ (id)objectForYACYAMLUnarchiving
{
    // We use a CFMutableSet rather than an NSMutableSet because testing has
    // shown it to be /slightly/ faster than NSMutableSet when loading
    // large (multi-megabyte) sets.  This might be simply due to less
    // implicit retain/releasing by ARC in the YACYAMLUnarchivingSetObject:...
    // method, below.
    return (__bridge_transfer id)CFSetCreateMutable(kCFAllocatorDefault,
                                                    0,
                                                    &kCFTypeSetCallBacks);
}

- (void)YACYAMLUnarchivingSetObject:(id)object forKey:(id)key
{
    // YAML represents sets as mappings of the contents to nil objects.
    // Note that althouth this category is on NSSet, we know that this 
    // instance is guaranteed to be one returned by
    // +objectForYACYAMLUnarchiving.
    CFSetAddValue((__bridge CFMutableSetRef)self,
                  (__bridge CFTypeRef)key);
}

@end

@implementation YACYAMLMergeKey

+ (void)initialize
{
    if(self == [YACYAMLMergeKey class]) {
        sSharedYACYAMLMergeKey = [[self alloc] init];
    }
}

+ (NSArray *)YACYAMLUnarchivingTags
{
    return [[NSArray alloc] initWithObjects:
            @"tag:yaml.org,2002:merge",
            nil];
}

+ (BOOL)YACYAMLImplicitlyMatchesScalarString:(NSString *)scalarString;
{
    return [scalarString isEqualToString:@"<<"];
}

+ (id)objectWithYACYAMLScalarString:(NSString *)string
{
    return sSharedYACYAMLMergeKey;
}

@end

