//
//  YACYAMLUnarchivingObject.m
//  YACYAML
//
//  Created by James Montgomerie on 24/05/2012.
//  Copyright (c) 2012 James Montgomerie. All rights reserved.
//

#import "YACYAML_Package.h"

#import "YACYAMLUnarchivingObject.h"
#import "YACYAMLKeyedUnarchiver.h"
#import "YACYAMLKeyedUnarchiver_Package.h"
#import "YACYAMLUnarchivingExtensions.h"

#import <libYAML/yaml.h>
#import <objc/message.h>

@implementation YACYAMLUnarchivingObject {
    __unsafe_unretained YACYAMLKeyedUnarchiver *_unarchiver;
        
    NSArray *_unkeyedChildren;
    NSDictionary *_keyedChildren;
        
    NSUInteger _unkeyedChildIndex;
    
    // See comments in _parseWithParser:... for the purpose of this ivar.
    void *_uninitializedRepresentedObject;
    id _representedObject;
}

- (id)representedObject
{
    // See comments in _parseWithParser:...
    return _representedObject ?: (__bridge id)_uninitializedRepresentedObject;
}

- (id)initWithParser:(struct yaml_parser_s *)parser
       forUnarchiver:(YACYAMLKeyedUnarchiver *)unarchiver;
{
    if((self = [super init])) {
        _unarchiver = unarchiver;
        
        yaml_event_t event; 
        int worked = yaml_parser_parse(parser, &event);
        if(worked) {
            switch(event.type) {
                case YAML_STREAM_START_EVENT:
                    NSLog(@"Warning: Unexpected stream start event from YAML parser.");
                    // Fall through, process as sequence.
                case YAML_DOCUMENT_START_EVENT:
                    [self _parseWithParser:parser 
                            forEventOfType:event.type
                                       tag:nil
                                    anchor:nil];
                    break;
                case YAML_SEQUENCE_START_EVENT:
                    [self _parseWithParser:parser
                            forEventOfType:event.type
                                       tag:event.data.sequence_start.tag
                                    anchor:event.data.sequence_start.anchor];
                    break;
                                        
                case YAML_MAPPING_START_EVENT:
                    [self _parseWithParser:parser    
                            forEventOfType:event.type
                                       tag:event.data.mapping_start.tag
                                    anchor:event.data.mapping_start.anchor];

                    break;
                    
                case YAML_SCALAR_EVENT:
                    [self _parseScalarEvent:&event];
                    break; 
                    
                case YAML_ALIAS_EVENT:
                    self = [_unarchiver previouslyInstantiatedUnarchivingObjectForAnchor:[NSString stringWithUTF8String:(const char *)event.data.alias.anchor]];
                    break;
                    
                default:
                    // Probably an end event.
                    self = nil;
                    break;
            }
            
            yaml_event_delete(&event);
        } else {
            self = nil;
        }
    }
    return self;
}

- (void)_parseScalarEvent:(yaml_event_t *)event
{
    
    Class representedClass = nil;
    
    if(event->data.scalar.tag) {
        NSString *tagString = [NSString stringWithUTF8String:(const char *)event->data.scalar.tag];
        representedClass = [[_unarchiver class] classForYAMLTag:tagString];
        if(representedClass) {
            if([representedClass respondsToSelector:@selector(objectWithYACYAMLScalarUTF8String:length:)]) {
                _representedObject = [representedClass objectWithYACYAMLScalarUTF8String:(const char *)event->data.scalar.value
                                                                                  length:event->data.scalar.length];
            }
        }
    }
    
    if(!_representedObject) {
        NSString *scalarString = (__bridge_transfer NSString *)CFStringCreateWithBytes(kCFAllocatorDefault,
                                                                                       event->data.scalar.value,
                                                                                       event->data.scalar.length,
                                                                                       kCFStringEncodingUTF8,
                                                                                       NO);
        
        if(!representedClass && event->data.scalar.plain_implicit) {
            representedClass = [[_unarchiver class] classForYAMLScalarString:scalarString];
        }

        if([representedClass respondsToSelector:@selector(objectWithYACYAMLScalarString:)]) {
            _representedObject = [representedClass objectWithYACYAMLScalarString:scalarString];
        } else {
            _representedObject = scalarString;
        }
    }
    
    const char *anchor = (const char *)event->data.scalar.anchor;
    if(anchor) {
        [_unarchiver setUnarchivingObject:self
                                forAnchor:[NSString stringWithUTF8String:anchor]];
    }
}


- (void)_parseWithParser:(yaml_parser_t *)parser
          forEventOfType:(yaml_event_type_t)type
                     tag:(const yaml_char_t *)tag
                  anchor:(const yaml_char_t *)anchor
{
    YACYAMLUnarchivingObject *keyAndData[2];
    NSUInteger index = 0;
        
    NSString *anchorString = nil;
    if(anchor) {
        anchorString = [NSString stringWithUTF8String:(const char *)anchor];
    }
    
    Class representedClass = nil;
    if(tag) {
        NSString *tagString = [NSString stringWithUTF8String:(const char *)tag];
        representedClass = [[_unarchiver class] classForYAMLTag:tagString];
    }
    if(!representedClass) {
        if(type == YAML_MAPPING_START_EVENT) {
            representedClass = [NSDictionary class];
        } else {
            representedClass = [NSArray class];
        }
    }
    
    if(type == YAML_MAPPING_START_EVENT && 
       [representedClass instancesRespondToSelector:@selector(YACYAMLUnarchivingSetObject:forKey:)]) {
        _representedObject = [representedClass objectForYACYAMLUnarchiving];
    } else if([representedClass instancesRespondToSelector:@selector(YACYAMLUnarchivingAddObject:)]) {
        _representedObject = [representedClass objectForYACYAMLUnarchiving];
    } else {
        if(!_unarchiver.isInitWithCoderDisallowed) {
            // No init.  We'll call initWithCoder later (see further comments
            // lower in the method).
            
            // ARC seems to get confused if we strongly store an alloced object,
            // but its -initWithCoder: method, when we later call it, returns a
            // different object.  CALayer in particular seems to do this a lot.
            // We therefore bypass ARC when calling -alloc, and assign the
            // uninitialized object temporarity to an void * ivar, safe in the
            // knowledge that its retain count is still +1.  We only assign to a
            // strongly retained ivar later, after calling -initWithCoder: on
            // the unretained ivar.
            _uninitializedRepresentedObject = (__bridge void *)((id(*)(id,SEL))objc_msgSend)(representedClass, @selector(alloc));
        } else {
            // -initWithCoder: is disallowed.  Just present these as a simple
            // mapping or sequence in an NSDictionary or NSArray.
            if(type == YAML_MAPPING_START_EVENT) {
                representedClass = [NSDictionary class];
            } else {
                representedClass = [NSArray class];
            }     
            _representedObject = [representedClass objectForYACYAMLUnarchiving];
        } 
    }
    
    if(anchorString) {
        // This is an invalid thing to do if the -initWithCoder: later returns
        // a different object to the one that alloc returns, but I can't
        // see a way to decode cyclic structures without doing it - we need
        // to be able to return a valid object for an anchor that refers to 
        // this object from 'inside' it, eve though it's not fully 
        // initialized yet.
        //
        // Presumably, the system NSCoder classes do a similar thing.  The
        // only widely used open source one, MAKeyedArchiver, certainly 
        // does, and the GNUStep one seems to too.
        //
        // It looks like, with NSKeyedArchiver, perhaps the client is meant
        // to fix things up by listening for 
        // unarchiver:willReplaceObject:withObject: delegate messages (I'd
        // bet that none do though).  Perhaps a similar delegate method
        // could be implemented in the future for this.
        
        [_unarchiver setUnarchivingObject:self
                                forAnchor:anchorString];
    }
    
    if(type == YAML_MAPPING_START_EVENT) {
        NSMutableDictionary *buildKeyedChildren = nil;
        id<YACYAMLUnarchivingMapping> mappingElements;
        
        if([representedClass instancesRespondToSelector:@selector(YACYAMLUnarchivingSetObject:forKey:)]) {
            mappingElements = _representedObject;
        } else {
            buildKeyedChildren = [[NSMutableDictionary alloc] init];
            mappingElements = buildKeyedChildren;
        }
        
        YACYAMLUnarchivingObject *nextEventObject = nil;
        while((nextEventObject = [[YACYAMLUnarchivingObject alloc] initWithParser:parser 
                                                                    forUnarchiver:_unarchiver])) {
            keyAndData[index++] = nextEventObject;
            if(index == 2) {
                [mappingElements YACYAMLUnarchivingSetObject:keyAndData[1].representedObject
                                                      forKey:keyAndData[0].representedObject];
                index = 0;
            }
        }
        
        if(index != 0) {
            NSLog(@"Warning: Unexpected non-even number of children in parsed YAML mapping");
        }
        
        if(buildKeyedChildren) {
            NSArray *unkeyedChildren = [buildKeyedChildren objectForKey:YACYAMLUnkeyedChildrenKey];
            if(unkeyedChildren) {
                _unkeyedChildren = unkeyedChildren;
                [buildKeyedChildren removeObjectForKey:YACYAMLUnkeyedChildrenKey];
            }
            
            _keyedChildren = buildKeyedChildren;
        } 
    } else {
        NSMutableArray *buildUnkeyedChildren = nil;
        id<YACYAMLUnarchivingSequence> sequenceElements;
        
        if([representedClass instancesRespondToSelector:@selector(YACYAMLUnarchivingAddObject:)]) {
            sequenceElements = _representedObject;
        } else {
            buildUnkeyedChildren = [[NSMutableArray alloc] init];
            sequenceElements = buildUnkeyedChildren;
        }
        
        YACYAMLUnarchivingObject *nextEventObject = nil;
        while((nextEventObject = [[YACYAMLUnarchivingObject alloc] initWithParser:parser 
                                                                    forUnarchiver:_unarchiver])) {
            [sequenceElements YACYAMLUnarchivingAddObject:nextEventObject.representedObject];
        }
        
        if(buildUnkeyedChildren) {
            _unkeyedChildren = buildUnkeyedChildren;
        }
    }
    
    // The representedObject was allocated above (ick! - see comment above).
    if(_keyedChildren || _unkeyedChildren) {
        [_unarchiver pushUnarchivingObject:self];
        void * initializedObject = (__bridge void *)((id(*)(id,SEL,id))objc_msgSend)((__bridge id)_uninitializedRepresentedObject, @selector(initWithCoder:), _unarchiver);
        _uninitializedRepresentedObject = nil;
        _representedObject = (__bridge_transfer id)initializedObject;
        [_unarchiver popUnarchivingObject];
    }
    
    // This is a hack that ensures that we can both return the represented 
    // object for these events as an array, and that nextUnkeyedObject
    // will also work on them.
    if(type == YAML_STREAM_START_EVENT || type == YAML_DOCUMENT_START_EVENT) {
        _unkeyedChildren = _representedObject;
        _representedObject = nil;
    }
}

- (id)nextUnkeyedObject
{
    if(_unkeyedChildIndex < _unkeyedChildren.count) {
        return [_unkeyedChildren objectAtIndex:_unkeyedChildIndex++];
    }
    return nil;
}

- (id)keyedObjectForKey:(id)key
{
    return [_keyedChildren objectForKey:key];
}

@end
