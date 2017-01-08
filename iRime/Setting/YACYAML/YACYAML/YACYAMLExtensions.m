//
//  YACYAMLExtensions.m
//  YACYAML
//
//  Created by James Montgomerie on 31/05/2012.
//  Copyright (c) 2012 James Montgomerie. All rights reserved.
//

#import "YACYAMLExtensions.h"
#import "YACYAMLKeyedArchiver.h"
#import "YACYAMLKeyedUnarchiver.h"

@implementation NSObject (YACYAMLExtensions)

- (NSString *)YACYAMLEncodedString
{
    return [YACYAMLKeyedArchiver archivedStringWithRootObject:self];
}

- (NSData *)YACYAMLEncodedData
{
    return [YACYAMLKeyedArchiver archivedDataWithRootObject:self];
}

@end

            
@implementation NSString (YACYAMLExtensions)

- (id)YACYAMLDecode
{
    return [self YACYAMLDecodeBasic];
}

- (id)YACYAMLDecodeBasic
{
    return [YACYAMLKeyedUnarchiver unarchiveObjectWithString:self options:YACYAMLKeyedUnarchiverOptionDisallowInitWithCoder];
}

- (id)YACYAMLDecodeAll
{
    return [YACYAMLKeyedUnarchiver unarchiveObjectWithString:self];
}

@end

            
@implementation NSData (YACYAMLExtensions)

- (id)YACYAMLDecode
{
    return [self YACYAMLDecodeBasic];
}

- (id)YACYAMLDecodeBasic
{
    return [YACYAMLKeyedUnarchiver unarchiveObjectWithData:self options:YACYAMLKeyedUnarchiverOptionDisallowInitWithCoder];
}

- (id)YACYAMLDecodeAll
{
    return [YACYAMLKeyedUnarchiver unarchiveObjectWithData:self];
}

@end
