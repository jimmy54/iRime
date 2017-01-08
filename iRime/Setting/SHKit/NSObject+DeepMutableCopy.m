//
//  NSObject+DeepMutableCopy.m
//  SHKit
//
//  Created by Neo on 1/2/13.
//  Copyright (c) 2013 Paradigm X. All rights reserved.
//

#import "NSObject+DeepMutableCopy.h"

@implementation NSObject (DeepMutableCopy)

- (id)deepMutableCopy {
	if ([self isKindOfClass:[NSDictionary class]]) {
		NSMutableDictionary *dict = [self mutableCopy];
		for (NSString *key in [dict allKeys]) {
			[dict setObject:[[dict objectForKey:key] deepMutableCopy] forKey:key];
		}
		return dict;
	}
	else if ([self isKindOfClass:[NSArray class]]) {
		NSMutableArray* array = [self mutableCopy];
		for (int i = 0; i < [array count]; i++)
		{
			[array replaceObjectAtIndex:i withObject:[[array objectAtIndex:i] deepMutableCopy]];
		}
		return array;
	}
	else if ([self isKindOfClass:[NSString class]])
		return [NSMutableString stringWithString:( NSString *)self];
    
	return self;
}

@end
