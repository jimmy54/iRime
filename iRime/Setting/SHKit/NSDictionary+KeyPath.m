//
//  NSDictionary+KeyPath.m
//  SHKit
//
//  Created by Neo on 1/2/13.
//  Copyright (c) 2013 Paradigm X. All rights reserved.
//

#import "NSDictionary+KeyPath.h"

@implementation NSDictionary (KeyPath)


- (id)objectForKeyPath:(NSString *)keyPath {
    NSArray *keyPathArray = [keyPath componentsSeparatedByString:@"."];
    return [self objectForKeyPathArray:keyPathArray];
}

- (id)objectForKeyPathArray:(NSArray *)keyPathArray {
    NSUInteger i, j, n = [keyPathArray count], m;
    
    id currentContainer = self;
    
    for (i = 0; i < n; i++) {
        NSString *currentPathItem = [keyPathArray objectAtIndex:i];
        NSArray *indices = [currentPathItem componentsSeparatedByString:@"["];
        m = [indices count];
        
        if (m == 1) { // no [ -> object is a dict or a leave
            currentContainer = [currentContainer objectForKey:currentPathItem];
        }
        else {
            // Indices is an array of string "arrayKeyName" "i1]" "i2]" "i3]"
            // arrayKeyName equals to curPathItem
            if (![currentContainer isKindOfClass:[NSDictionary class]])
                return nil;
            
            currentPathItem = [currentPathItem substringToIndex:[currentPathItem rangeOfString:@"["].location];
            currentContainer = [currentContainer objectForKey:currentPathItem];
            
            for(j = 1; j < m; j++) {
                int index = [[indices objectAtIndex:j] intValue];
                if (![currentContainer isKindOfClass:[NSArray class]])
                    return nil;
                if (index >= [currentContainer count])
                    return nil;
                
                currentContainer = [currentContainer objectAtIndex:index];
            }
        }
    }
    
    return currentContainer;
}

@end

@implementation NSMutableDictionary (KeyPath)

- (void)setObject:(id)value forKeyPath:(NSString *)keyPath {
    NSArray *keyPathArray = [keyPath componentsSeparatedByString:@"."];
    [self setObject:value forKeyPathArray:keyPathArray];
}

- (void)setObject:(id)value forKeyPathArray:(NSArray *)keyPathArray {
    NSUInteger i, j, n = [keyPathArray count], m;
    
    id containerContainer = nil;
    id currentContainer = self;
    NSString *currentPathItem = nil;
    
    NSArray *indices;
    int index = 0;
    BOOL needArray = NO;
    
    for (i = 0; i < n; i++) {
        currentPathItem = [keyPathArray objectAtIndex:i];
        indices = [currentPathItem componentsSeparatedByString:@"["];
        m = [indices count];
        
        if (m == 1) {
            if ([currentContainer isKindOfClass:[NSNull class]]) {
                currentContainer = [NSMutableDictionary dictionary];
                if (needArray) {
                    [containerContainer replaceObjectAtIndex:index withObject:currentContainer];
                }
                else    {
                    [containerContainer setObject:currentContainer forKey:currentPathItem];
                }
            }
            
            containerContainer = currentContainer;
            currentContainer = [currentContainer objectForKey:currentPathItem];
            
            needArray = NO;
            if (![containerContainer isKindOfClass:[NSDictionary class]])
                [NSException raise:@"Path item not a dictionary" format:@"(keyPathArray %@ - offending %@)", keyPathArray, currentPathItem];
            
            if (currentContainer == nil) {
                currentContainer = [NSMutableDictionary dictionary];
                [containerContainer setObject:currentContainer forKey:currentPathItem];
            }
        }
        else {
            needArray = YES;
            // indices is an array of string "arrayKeyName" "i1]" "i2]" "i3]"
            // arrayKeyName equal to curPathItem
            currentPathItem = [currentPathItem substringToIndex:[currentPathItem rangeOfString:@"["].location];
            
            containerContainer = currentContainer;
            currentContainer = [currentContainer objectForKey:currentPathItem];
            
            if (currentContainer == nil) {
                currentContainer = [NSMutableArray array];
                [containerContainer setObject:currentContainer forKey:currentPathItem];
            }
            
            if (![currentContainer isKindOfClass:[NSArray class]])
                [NSException raise:@"Path item not an array" format:@"(keyPathArray %@ - offending %@)", keyPathArray, currentPathItem];
            
            for (j = 1; j < m-1; j++) {
                index = [[indices objectAtIndex:j] intValue];
                
                containerContainer = currentContainer;
                currentContainer = [currentContainer objectAtIndex:index];
                if ([currentContainer isKindOfClass:[NSNull class]]) {
                    currentContainer = [NSMutableArray array];
                    [containerContainer replaceObjectAtIndex:index withObject:currentContainer];
                }
                else if (![currentContainer isKindOfClass:[NSArray class]])
                    [NSException raise:@"Path item not an array" format:@"(keyPathArray %@ - offending %@ index %lu)", keyPathArray, currentPathItem, j-1];
            }
            
            index = [[indices objectAtIndex:m-1] intValue];
            
            if (index >= [currentContainer count]) {
                NSUInteger k;
                
                for (k = [currentContainer count]; k <= index; k++)
                    [currentContainer addObject:[NSNull null]];
            }
            
            containerContainer = currentContainer;
            currentContainer = [currentContainer objectAtIndex:index];
        }
        
    }
    
    if (needArray) { // containerContainer must be an array
        if (![containerContainer isKindOfClass:[NSArray class]])
            [NSException raise:@"Last path item is not an array" format:@"(keyPathArray %@)", keyPathArray];
        [containerContainer replaceObjectAtIndex:index withObject:value];
    }
    else {
        if (![containerContainer isKindOfClass:[NSDictionary class]])
            [NSException raise:@"Before-last path item is not a dictionary" format:@"(keyPathArray %@)", keyPathArray];
        
        [containerContainer setObject:value forKey:currentPathItem];
    }
}

@end
