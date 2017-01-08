//
//  YACYAMLUnarchivingObject.h
//  YACYAML
//
//  Created by James Montgomerie on 24/05/2012.
//  Copyright (c) 2012 James Montgomerie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YACYAMLKeyedUnarchiver;

struct yaml_parser_s;
struct yaml_event_s;

@interface YACYAMLUnarchivingObject : NSObject

- (id)initWithParser:(struct yaml_parser_s *)parser
       forUnarchiver:(YACYAMLKeyedUnarchiver *)unarchiver;

@property (nonatomic, strong, readonly) id representedObject;

- (id)nextUnkeyedObject;
- (id)keyedObjectForKey:(id)key;

@end
