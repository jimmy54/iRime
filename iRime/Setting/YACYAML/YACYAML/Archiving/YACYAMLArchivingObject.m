//
//  YACYAMLArchivingObject.m
//  YACYAML
//
//  Created by James Montgomerie on 18/05/2012.
//  Copyright (c) 2012 James Montgomerie. All rights reserved.
//

#import <libYAML/yaml.h>

#import "YACYAML_Package.h"

#import "YACYAMLKeyedArchiver.h"
#import "YACYAMLKeyedArchiver_Package.h"
#import "YACYAMLKeyedUnarchiver.h"
#import "YACYAMLKeyedUnarchiver_Package.h"

#import "YACYAMLArchivingObject.h"
#import "YACYAMLArchivingExtensions.h"

#import "YACYAMLConstants.h"

@interface YACYAMLArchivingObject ()
@property (nonatomic, assign) BOOL needsAnchor;
@end

@implementation YACYAMLArchivingObject {
    __unsafe_unretained YACYAMLKeyedArchiver *_archiver;
    id _representedObject;
    
    // These hold our child YACYAMLArchivingObjects.  We use CFArrays here
    // instead of NSArrays so that we can create them with custom retain
    // and release callbacks, so that they don't retain their contents.
    // We can be sure that the YACYAMLKeyedArchiver is retaining the child
    // objects, so we don't need to retain them here. By not doing so we also
    // avoid retain cycles if the user encodes cyclic objects.
    CFMutableArrayRef _unkeyedChildren;
    CFMutableArrayRef _keyedChildren;
    
    BOOL _needsAnchor;
    NSString *_emittedAnchor;
}

@synthesize representedObject = _representedObject;
@synthesize needsAnchor = _needsAnchor;

- (id)initWithRepresentedObject:(id)representedObject
                    forArchiver:(YACYAMLKeyedArchiver *)archiver
{
    if((self = [super init])) {
        _representedObject = representedObject;
        _archiver = archiver;
    }
    return self;
}

- (void)dealloc
{
    CFBridgingRelease(_unkeyedChildren);
    CFBridgingRelease(_keyedChildren);
}

- (BOOL)allowsKeyedCoding
{
    return YES;
}

- (YACYAMLArchivingObject *)_archivingObjectForObject:(id)obj
{
    YACYAMLArchivingObject *archivingObject = [_archiver previouslySeenArchivingObjectForObject:obj];
    if(archivingObject) {
        // We've already seen this object, don't archive it again, but mark it
        // as needing an anchor in the emitted YAML so that we know to emit one
        // when we come to writing the file.
        archivingObject.needsAnchor = YES;
    } else {
        archivingObject = [[YACYAMLArchivingObject alloc] initWithRepresentedObject:obj
                                                                        forArchiver:_archiver];
        
        if([obj respondsToSelector:@selector(YACYAMLScalarString)]) {
            if(_archiver.scalarAnchorsAllowed) {
                [_archiver pushArchivingObject:archivingObject];
                [_archiver popArchivingObject];
            } else {
                [_archiver noteNonAnchoringObject:archivingObject];
            }
        } else {
            [_archiver pushArchivingObject:archivingObject];
            [obj YACYAMLEncodeWithCoder:_archiver];
            [_archiver popArchivingObject];
        }
    }
    return archivingObject;
}

static CFMutableArrayRef CreateNonRetainingArray(void)
{
    return CFArrayCreateMutable(kCFAllocatorDefault,
                                0, 
                                &(CFArrayCallBacks) {
                                    0,
                                    NULL,
                                    NULL,
                                    kCFTypeArrayCallBacks.copyDescription,
                                    kCFTypeArrayCallBacks.equal,
                                });
}

- (void)encodeChild:(id)obj forKey:(id)key
{
    // See comments above, at ivar declarations, for why we're using
    // CFMutableArrays that don't retain their contents here insead of
    // regular contents-retaining NSMutableArrays.
    
    YACYAMLArchivingObject *archivingObject = [self _archivingObjectForObject:obj];
    if(key) {
        if(!_keyedChildren) {
            _keyedChildren = CreateNonRetainingArray();
        }
        CFArrayAppendValue(_keyedChildren, (__bridge CFTypeRef)[self _archivingObjectForObject:key]);
        CFArrayAppendValue(_keyedChildren, (__bridge CFTypeRef)archivingObject);
    } else {
        if(!_unkeyedChildren) {
            _unkeyedChildren = CreateNonRetainingArray();
        }
        CFArrayAppendValue(_unkeyedChildren, (__bridge CFTypeRef)archivingObject);
    }
}

- (void)emitWithEmitter:(yaml_emitter_t *)emitter;
{
    yaml_event_t event = {};
    id obj = self.representedObject;
    
    if(obj) {
        if(_emittedAnchor) {
            // An anchor has already been emitted for this object,
            // so just refer to it rather than emitting again.
            yaml_alias_event_initialize(&event, (yaml_char_t *)_emittedAnchor.UTF8String);
            yaml_emitter_emit(emitter, &event);
        } else {
            yaml_char_t *anchor = NULL;
            if(_needsAnchor) {
                // We know that this object will be referred to again later in
                // the archive, so generate an anchor for it.
                _emittedAnchor = [_archiver generateAnchor];
                anchor = (yaml_char_t *)_emittedAnchor.UTF8String;
            }
            
            NSString *customTag = [obj YACYAMLArchivingTag];
            
            if([obj respondsToSelector:@selector(YACYAMLScalarString)]) {
                // This is a scalar object.  Emit it.
                NSString *string = [(id<YACYAMLArchivingCustomEncoding>)obj YACYAMLScalarString];
                            
                const char *stringChars;
                size_t stringCharsLength;
                yaml_scalar_style_t style;

                // The below deals with the difference between an empty
                // string and NULL.
                if(string) {
                    // This is non-NULL.
                    stringChars = [string UTF8String];
                    stringCharsLength = strlen(stringChars);
                    if(stringCharsLength) {
                        if(!customTag &&
                           [YACYAMLKeyedUnarchiver classForYAMLScalarString:string]) {
                            // If this is a string that would be implicitly decoded 
                            // into another type, we need to quote it.
                            style = YAML_SINGLE_QUOTED_SCALAR_STYLE;
                        } else {
                            style = YAML_ANY_SCALAR_STYLE;
                        }
                    } else {
                        style = YAML_SINGLE_QUOTED_SCALAR_STYLE;
                    }
                } else {
                    // This is a NULL.
                    stringChars = "";
                    stringCharsLength = 0;
                    style = YAML_PLAIN_SCALAR_STYLE;
                }
                
                if(stringCharsLength >= INT_MAX) {
                    [NSException raise:YACYAMLUnsupportedObjectException format:@"Attempt made to encode string too large for YAML"];
                }
                
                yaml_scalar_event_initialize(&event,
                                             anchor,
                                             customTag ? (yaml_char_t *) 
                                                (yaml_char_t *)customTag.UTF8String : 
                                                (yaml_char_t *)YAML_STR_TAG, 
                                             (yaml_char_t *)stringChars,
                                             (int)stringCharsLength,
                                             [obj YACYAMLArchivingTagCanBePlainImplicit],
                                             [obj YACYAMLArchivingTagCanBeQuotedImplicit],
                                             style);
                yaml_emitter_emit(emitter, &event);
            } else {
                // This is an obect with children.
                if(_keyedChildren) {
                    // This object has keyed chidren, so we use a map to 
                    // represent it.
                    yaml_mapping_start_event_initialize(&event, 
                                                        anchor,
                                                        customTag ? 
                                                            (yaml_char_t *)customTag.UTF8String :
                                                            (yaml_char_t *)YAML_MAP_TAG, 
                                                        [obj YACYAMLArchivingTagCanBePlainImplicit], 
                                                        YAML_ANY_MAPPING_STYLE);
                    yaml_emitter_emit(emitter, &event);
                    
                    if(_unkeyedChildren) {
                        // This object has keyed children /and/ unkeyed
                        // children.  Put the unkeyed children in a sequence 
                        // under a special key.
                        yaml_scalar_event_initialize(&event,
                                                     NULL,
                                                     (yaml_char_t *)YAML_STR_TAG, 
                                                     (yaml_char_t *)YACYAMLUnkeyedChildrenKeyChars,
                                                     YACYAMLUnkeyedChildrenKeyCharsLength,
                                                     1,
                                                     1,
                                                     YAML_ANY_SCALAR_STYLE);
                        yaml_emitter_emit(emitter, &event);
                    }
                }
                if(_unkeyedChildren || !_keyedChildren) {
                    // Emit a sequence for the unkeyed children.
                    // Note that, in the case that there are no keyed children,
                    // we emit this even if there's no unkeyed children, so a 
                    // non-scalar object with no children is represented as an
                    // empty sequence.
                    yaml_sequence_start_event_initialize(&event,
                                                         _keyedChildren ? 
                                                            NULL : 
                                                            anchor,
                                                         (!_keyedChildren && customTag) ? 
                                                            (yaml_char_t *)customTag.UTF8String : 
                                                            (yaml_char_t *)YAML_SEQ_TAG,
                                                         _keyedChildren ?
                                                             1 :
                                                             [obj YACYAMLArchivingTagCanBePlainImplicit], 
                                                         YAML_ANY_SEQUENCE_STYLE);
                    yaml_emitter_emit(emitter, &event);
                    
                    for(YACYAMLArchivingObject *child in (__bridge NSArray *)_unkeyedChildren) {
                        [child emitWithEmitter:emitter];
                    }
                    
                    yaml_sequence_end_event_initialize(&event);
                    yaml_emitter_emit(emitter, &event);
                }
                if(_keyedChildren) {
                    NSParameterAssert((CFArrayGetCount(_keyedChildren) % 2) == 0);
                    
                    // Emit the keyed children (the mapping we're emitting these
                    // into was started above, before we dealt with any
                    // potential unkeyed children).
                    for(YACYAMLArchivingObject *key in (__bridge NSArray *)_keyedChildren) {
                        [key emitWithEmitter:emitter];
                    }

                    // All keyed children emitted, close the mapping.
                    yaml_mapping_end_event_initialize(&event);
                    yaml_emitter_emit(emitter, &event);
                }
            }
        }
    } else {
        // No represented object means we're the root of the tree.
        for(YACYAMLArchivingObject *child in (__bridge NSArray *)_unkeyedChildren) {
            yaml_document_start_event_initialize(&event, 
                                                 NULL, 
                                                 NULL, 
                                                 NULL,
                                                 1);
            yaml_emitter_emit(emitter, &event);

            [child emitWithEmitter:emitter];

            yaml_document_end_event_initialize(&event, 1);
            yaml_emitter_emit(emitter, &event);
        }
    }
}

@end
