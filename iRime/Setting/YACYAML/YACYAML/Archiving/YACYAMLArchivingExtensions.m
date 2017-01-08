//
//  YACYAMLArchivingExtensions.m
//  YACYAML
//
//  Created by James Montgomerie on 18/05/2012.
//  Copyright (c) 2012 James Montgomerie. All rights reserved.
//

#import "YACYAMLArchivingExtensions.h"

#import <resolv.h>

@implementation NSObject (YACYAMLArchivingExtensions)

- (void)YACYAMLEncodeWithCoder:(YACYAMLKeyedArchiver *)coder
{
    [(id<NSCoding>)self encodeWithCoder:coder];
}

- (BOOL)YACYAMLArchivingTagCanBePlainImplicit
{
    return NO;
}

- (BOOL)YACYAMLArchivingTagCanBeQuotedImplicit
{
    return NO;
}

- (NSString *)YACYAMLArchivingTag
{
    return [@"!" stringByAppendingString:NSStringFromClass([self class])];
}

@end


@implementation NSString (YACYAMLArchivingExtensions)

- (BOOL)YACYAMLArchivingTagCanBePlainImplicit
{
    return YES;
}

- (BOOL)YACYAMLArchivingTagCanBeQuotedImplicit
{
    return YES;
}

- (NSString *)YACYAMLArchivingTag
{
    return nil;
}

- (NSString *)YACYAMLScalarString
{
    return self;
}

@end



@implementation NSNumber (YACYAMLArchivingExtensions)

- (BOOL)YACYAMLArchivingTagCanBePlainImplicit
{
    return YES;
}

- (BOOL)YACYAMLArchivingTagCanBeQuotedImplicit
{
    return NO;
}

- (BOOL)YACYAMLArchivingExtensions_isBoolean
{
    const char *objCType = self.objCType;
    if(objCType[0] == 'B' && !objCType[1]) {
        return YES;
    } 

    if([NSStringFromClass([self class]) rangeOfString:@"Boolean"].location != NSNotFound) {
        // This is a hack.  At least on 32-bit runtimes - including iOS - 
        // booleans are not specifically encoded when stored in NSNumbers. 
        // NSNumbers created with e.g. [NSNumber numberWithBool:] report their
        // objCType as /char/.  Correct at machine level, but not correct as
        // far as human-readable-output is concerned.  The class they're stored
        // as, however, reports its name as '__NSCFBoolean', so we look at the 
        // class name.  This is a bit fragile, but the worst that will happen
        // is that if Apple renames the __NSCFBoolean class, this will start
        // reporting NO, and we'll encode as char, which is where we'd be anyway
        // without this check.
        
        return YES;
    }

    return NO;
}

- (NSString *)YACYAMLArchivingTag
{
    NSString *tag = nil;

    if([self YACYAMLArchivingExtensions_isBoolean]) {
        tag = @"tag:yaml.org,2002:bool";
    } else {
        const char *objCType = self.objCType;
        
        if(objCType[0] && !objCType[1]) {
            switch(objCType[0]) {
                {
                default: 
                    NSLog(@"Warning: Unknown ObjC type encountered in number, %s, encoding as double", objCType);
                    // Fall through.
                    
                case 'f': // A float
                case 'd': // A double
                    tag = @"tag:yaml.org,2002:float";
                    break;

                case 'c': // A char
                case 's': // A short
                case 'i': // An int
                case 'l': // A long (treated as a 32-bit quantity on 64-bit).
                case 'q': // A long long
                case 'C': // An unsigned char
                case 'S': // An unsigned short
                case 'I': // An unsigned int
                case 'L': // An unsigned long
                case 'Q': // An unsigned long long
                    tag = @"tag:yaml.org,2002:int";
                    break;

                case 'B': // A C++ bool or a C99 _Bool
                    tag = @"tag:yaml.org,2002:bool";
                    break;
                }
            }
        }
        
        if(!tag) {
            NSLog(@"Warning: Unknown ObjC type encountered in number, %s, encoding as string", objCType);
            tag = @"tag:yaml.org,2002:str";
        }
    }
    
    return tag;
}

- (NSString *)YACYAMLScalarString
{
    if([self YACYAMLArchivingExtensions_isBoolean]) {
        // Previously, was using 'y'/'n', but 'true'/'false' are canonical
        // YAML 1.2, and valid YAML 1.1.
        return self.boolValue ? @"true" : @"false";
    } if([self isEqualToNumber:(__bridge NSNumber *)kCFNumberPositiveInfinity]) {
        return @".inf";
    } else if([self isEqualToNumber:(__bridge NSNumber *)kCFNumberNegativeInfinity]) {
        return @"-.inf";
    } else if([self isEqualToNumber:(__bridge NSNumber *)kCFNumberNaN]) {
        return @".nan";
    } else {
        return [self stringValue];
    }
}

@end


@implementation NSDate (YACYAMLArchivingExtensions)

- (BOOL)YACYAMLArchivingTagCanBePlainImplicit
{
    return YES;
}

- (BOOL)YACYAMLArchivingTagCanBeQuotedImplicit
{
    return NO;
}

- (NSString *)YACYAMLArchivingTag
{
    return @"tag:yaml.org,2002:timestamp";
}

- (NSString *)YACYAMLScalarString
{
    NSString *ret = nil;
    
    NSUInteger units =  NSCalendarUnitYear | 
                        NSCalendarUnitMonth |  
                        NSCalendarUnitDay | 
                        NSCalendarUnitHour | 
                        NSCalendarUnitMinute | 
                        NSCalendarUnitSecond |
                        NSCalendarUnitTimeZone;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
     
    NSDateComponents *components = [calendar components:units fromDate:self];
    
    long year =   [components year];
    long month =  [components month];
    long day =    [components day];
    
    long hour =   [components hour];
    long minute = [components minute];
    long second = [components second];

    NSTimeZone *timeZone = components.timeZone;
    long timeZoneOffset = timeZone.secondsFromGMT;

    NSString *dateString = [NSString stringWithFormat:@"%04ld-%02ld-%02ld", year, month, day];

    if(hour == 0 && minute == 0 && second == 0 && 
       timeZoneOffset == 0) {
     
        ret = dateString;
    } else {
        NSMutableString *buildTimestamp = [dateString mutableCopy];
        [buildTimestamp appendFormat:@"T%02ld:%02ld:%02ld", hour, minute, second];
        
        double fraction = modf([self timeIntervalSinceReferenceDate], (double[]){0.0});
        if(fraction) {
            [buildTimestamp appendFormat:@".%ld", (long)round(fraction * 1000.0)];
        }
        
        if(timeZoneOffset == 0) {
            [buildTimestamp appendString:@"Z"];
        } else {
            [buildTimestamp appendFormat:@"%+02ld:%02ld", timeZoneOffset / 3600, (timeZoneOffset / 60) % 60];
        }
    
        ret = buildTimestamp;
    }
    
    return ret;
}

@end



@implementation NSArray (YACYAMLArchivingExtensions) 

- (BOOL)YACYAMLArchivingTagCanBePlainImplicit
{
    return YES;
}

- (BOOL)YACYAMLArchivingTagCanBeQuotedImplicit
{
    return NO;
}

- (NSString *)YACYAMLArchivingTag
{
    return @"tag:yaml.org,2002:seq";
}

- (void)YACYAMLEncodeWithCoder:(YACYAMLKeyedArchiver *)coder
{
    for(id obj in self) {
        [coder encodeObject:obj];
    }
}

@end



@implementation NSDictionary (YACYAMLArchivingExtensions) 

- (BOOL)YACYAMLArchivingTagCanBePlainImplicit
{
    return YES;
}

- (BOOL)YACYAMLArchivingTagCanBeQuotedImplicit
{
    return NO;
}

- (NSString *)YACYAMLArchivingTag
{
    return @"tag:yaml.org,2002:map";
}

- (void)YACYAMLEncodeWithCoder:(YACYAMLKeyedArchiver *)coder
{
    // Note that NSCoder requires our keys to be strings, but we know that,
    // underneath, a YACYAMLArchivingObject can deal with keys of arbitraty 
    // types, so we take advantege of that when we store NSDictionaries as
    // native YAML mappings.
    for(id key in [self keyEnumerator]) {
        [coder encodeObject:[self objectForKey:key]
                     forKey:key];
    }
}

@end


@implementation NSNull (YACYAMLArchivingExtensions)

- (NSString *)YACYAMLArchivingTag
{
    return @"tag:yaml.org,2002:null";
}

- (BOOL)YACYAMLArchivingTagCanBePlainImplicit
{
    return YES;
}

- (BOOL)YACYAMLArchivingTagCanBeQuotedImplicit
{
    return YES;
}

- (NSString *)YACYAMLScalarString
{
    return nil;
}

@end


@implementation NSSet (YACYAMLArchivingExtensions) 

- (BOOL)YACYAMLArchivingTagCanBePlainImplicit
{
    return NO;
}

- (BOOL)YACYAMLArchivingTagCanBeQuotedImplicit
{
    return NO;
}

- (NSString *)YACYAMLArchivingTag
{
    return @"tag:yaml.org,2002:set";
}

- (void)YACYAMLEncodeWithCoder:(YACYAMLKeyedArchiver *)coder
{
    // In YAML, a set is a mapping with all-null objects.
    for(id object in self) {
        [coder encodeObject:[NSNull null]
                     forKey:object];
    }
}

@end


@implementation NSData (YACYAMLArchivingExtensions)

- (BOOL)YACYAMLArchivingTagCanBePlainImplicit
{
    return NO;
}

- (BOOL)YACYAMLArchivingTagCanBeQuotedImplicit
{
    return NO;
}

- (NSString *)YACYAMLArchivingTag
{
    return @"tag:yaml.org,2002:binary";
}

- (NSString *)YACYAMLScalarString
{
    NSString *encodedString= nil;
    
    NSUInteger dataToEncodeLength = self.length;
    
    // Last +1 below to accommodate trailing '\0':
    NSUInteger encodedBufferLength = ((dataToEncodeLength + 2) / 3) * 4 + 1; 
    
    char *encodedBuffer = malloc(encodedBufferLength);
    
    int encodedRealLength = b64_ntop(self.bytes, dataToEncodeLength, 
                                     encodedBuffer, encodedBufferLength);
    
    if(encodedRealLength >= 0) {
        encodedString = [[NSString alloc] initWithBytesNoCopy:encodedBuffer
                                                       length:encodedRealLength
                                                     encoding:NSASCIIStringEncoding
                                                 freeWhenDone:YES];
    } else {
        free(encodedBuffer);
    }    
    
    return encodedString;
}

@end
