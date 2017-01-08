//
//  YACYAMLKeyedArchiver.m
//  YACYAML
//
//  Created by James Montgomerie on 17/05/2012.
//  Copyright (c) 2012 James Montgomerie. All rights reserved.
//

#import "YACYAMLKeyedArchiver.h"
#import "YACYAMLKeyedArchiver_Package.h"

#import "YACYAMLConstants.h"

#import "YACYAMLArchivingObject.h"

#import <libYAML/yaml.h>

@implementation YACYAMLKeyedArchiver {
    NSMutableData *_dataForWriting;
    FILE *_fileForWriting;
    
    BOOL _scalarAnchorsAllowed;
    
    YACYAMLArchivingObject *_rootObject;
    NSMutableArray *_archivingObjectStack;

    CFMutableDictionaryRef _archivedObjectToItem;
    NSMutableArray *_nonAnchoringObjects;
    
    NSUInteger _generatedAnchorCount;
}

@synthesize scalarAnchorsAllowed = _scalarAnchorsAllowed;


#pragma mark - Convenince methods

+ (NSData *)archivedDataWithRootObject:(id)rootObject options:(YACYAMLKeyedArchiverOptions)options
{
    NSMutableData *ret = [[NSMutableData alloc] init];
    YACYAMLKeyedArchiver *archiver = [[[self class] alloc] initForWritingWithMutableData:ret options:options];
    [archiver encodeRootObject:rootObject];
    [archiver finishEncoding];
    return ret;
}

+ (NSData *)archivedDataWithRootObject:(id)rootObject
{
    return [self archivedDataWithRootObject:rootObject 
                                    options:YACYAMLKeyedArchiverOptionNone];
}

+ (NSString *)archivedStringWithRootObject:(id)rootObject options:(YACYAMLKeyedArchiverOptions)options
{
    return [[NSString alloc] initWithData:[self archivedDataWithRootObject:rootObject 
                                                                   options:options]
                                 encoding:NSUTF8StringEncoding];
}

+ (NSString *)archivedStringWithRootObject:(id)rootObject
{
    return [self archivedStringWithRootObject:rootObject
                                      options:YACYAMLKeyedArchiverOptionNone];
}

+ (BOOL)archiveRootObject:(id)rootObject 
                   toFile:(NSString *)path
                  options:(YACYAMLKeyedArchiverOptions)options
{
    BOOL success = NO;
    YACYAMLKeyedArchiver *archiver = [[[self class] alloc] initForWritingToFile:path options:options];
    if(archiver) {
        [archiver encodeRootObject:rootObject];
        [archiver finishEncoding];
        success = YES;
    }
    return success;
}

+ (BOOL)archiveRootObject:(id)rootObject toFile:(NSString *)path
{
    return [self archiveRootObject:rootObject toFile:path options:YACYAMLKeyedArchiverOptionNone];
}


#pragma mark - Initialization/destruction

- (void)_setupForWritingWithOptions:(YACYAMLKeyedArchiverOptions)options
{
    _rootObject = [[YACYAMLArchivingObject alloc] initWithRepresentedObject:nil
                                                                forArchiver:self];
    _archivingObjectStack = [[NSMutableArray alloc] init];
    [_archivingObjectStack addObject:_rootObject];
    
    
    // Don't retain the key here - it's the representedObject that's stored
    // in the YACYAMLArchivingObject that's the value.
    // Also, set up the equality and hash operations to the correct thing
    // to implements the user's choice of using object equality 
    // vs pointer equality (via the
    // YACYAMLKeyedArchiverOptionDontUseObjectEquality option).
    _archivedObjectToItem = CFDictionaryCreateMutable(kCFAllocatorDefault,
                                                      0,
                                                      &(const CFDictionaryKeyCallBacks) {
                                                          0,
                                                          NULL,
                                                          NULL,
                                                          kCFTypeDictionaryKeyCallBacks.copyDescription,
                                                          (options & YACYAMLKeyedArchiverOptionDontUseObjectEquality) == YACYAMLKeyedArchiverOptionDontUseObjectEquality ?
                                                            NULL : kCFTypeDictionaryKeyCallBacks.equal,
                                                          (options & YACYAMLKeyedArchiverOptionDontUseObjectEquality) == YACYAMLKeyedArchiverOptionDontUseObjectEquality ?
                                                            NULL : kCFTypeDictionaryKeyCallBacks.hash,
                                                      },
                                                      &kCFTypeDictionaryValueCallBacks);
    
    // Use to store objects that are not allowed to be used as anchors,
    // since they won't be retained in the _archivedObjectToItem dictionary.
    _nonAnchoringObjects = [[NSMutableArray alloc] init];
    
    _scalarAnchorsAllowed = ((options & YACYAMLKeyedArchiverOptionDontUseObjectEquality) == YACYAMLKeyedArchiverOptionAllowScalarAnchors);
}

- (id)initForWritingWithMutableData:(NSMutableData *)mdata options:(YACYAMLKeyedArchiverOptions)options
{
    if((self = [super init])) {
        _dataForWriting = mdata;
        [self _setupForWritingWithOptions:options];
    }
    return self;
}

- (id)initForWritingWithMutableData:(NSMutableData *)data
{
    return [self initForWritingWithMutableData:data options:YACYAMLKeyedArchiverOptionNone];
}


- (id)initForWritingToFile:(NSString *)path options:(YACYAMLKeyedArchiverOptions)options
{
    if((self = [super init])) {
        _fileForWriting = fopen([path fileSystemRepresentation], "w");
        if(_fileForWriting) {
            [self _setupForWritingWithOptions:options];
        } else {
            self = nil;
        }
    }
    return self;

}

- (id)initForWritingToFile:(NSString *)path
{
    return [self initForWritingToFile:path options:YACYAMLKeyedArchiverOptionNone];
}

- (void)dealloc
{
    CFBridgingRelease(_archivedObjectToItem);
}

static int EmitToNSMutableData(void *ext, unsigned char *buffer, size_t size)
{
    [(__bridge NSMutableData *)ext appendBytes:buffer length:size];
    return 1;
}

- (void)finishEncoding 
{
    yaml_emitter_t emitter;
    yaml_emitter_initialize(&emitter);
    
    // Wonder should expose some of these options should be exposed?
    yaml_emitter_set_encoding(&emitter, YAML_UTF8_ENCODING);
    yaml_emitter_set_unicode(&emitter, 1);
    yaml_emitter_set_width(&emitter, 72);
    
    if(_fileForWriting) {
        yaml_emitter_set_output_file(&emitter, _fileForWriting); 
    } else {
        yaml_emitter_set_output(&emitter, EmitToNSMutableData, (__bridge void *)_dataForWriting);  
    }
    
    yaml_event_t event;
    
    yaml_stream_start_event_initialize(&event, YAML_UTF8_ENCODING);
    yaml_emitter_emit(&emitter, &event);
    
    [_rootObject emitWithEmitter:&emitter];
    
    yaml_stream_end_event_initialize(&event);
    yaml_emitter_emit(&emitter, &event);
    
    yaml_emitter_delete(&emitter);
    
    
    if(_fileForWriting) {
        fclose(_fileForWriting);
        _fileForWriting = NULL;
    }
}


#pragma mark - Package scope, used by YACYAMLUnarchivingObject during unarchiving

- (void)pushArchivingObject:(YACYAMLArchivingObject *)archivingObject
{
    CFDictionaryAddValue(_archivedObjectToItem,
                         (__bridge void *)(archivingObject.representedObject),
                         (__bridge void *)archivingObject);
    [_archivingObjectStack addObject:archivingObject];
}

- (void)popArchivingObject
{
    [_archivingObjectStack removeLastObject];
}

- (void)noteNonAnchoringObject:(YACYAMLArchivingObject *)archivingObject
{
    [_nonAnchoringObjects addObject:archivingObject];
}

- (YACYAMLArchivingObject *)previouslySeenArchivingObjectForObject:(id)object
{
    return (__bridge YACYAMLArchivingObject *)CFDictionaryGetValue(_archivedObjectToItem, (__bridge void *)object);
}

- (NSString *)_anchorStringForNumber:(NSUInteger)number
{
    /*
      a = 0
      z = 25
      A = 26
      Z = 51
     aa = 52
     ab = 53 etc.
    */    
    
    NSString *converted = nil;

    NSUInteger value = number;
    do {
        int remainder = value % 52;
        
        if (converted && value < 53) {
            remainder--;
        }
        
        unichar ch;
        if(remainder < 26) {
            ch = 'a' + remainder;
        } else {
            ch = 'A' + (remainder - 26);
        }
        
        value = (value - remainder) / 52;
        
        if(converted) {
            converted = [NSString stringWithFormat:@"%c%@", ch, converted];
        } else {
            converted = [NSString stringWithCharacters:&ch length:1];
        }
    } while (value != 0);
    
    return converted;
}

- (NSString *)generateAnchor
{
    return [self _anchorStringForNumber:_generatedAnchorCount++];
}


#pragma mark - NSCoder

- (BOOL)allowsKeyedCoding
{
	return YES;
}

- (unsigned)systemVersion
{
    [NSException raise:YACYAMLUnsupportedMethodException 
                format:@"YACYAML archving does not support the systemVersion method"];
    return 0;
}


#pragma mark - Keyed archiving

- (void)encodeObject:(id)obj forKey:(nonnull NSString *)key
{
    [[_archivingObjectStack lastObject] encodeChild:obj ?: [NSNull null]
                                             forKey:key];
}

- (void)encodeConditionalObject:(id)objv forKey:(NSString *)key
{
    [self encodeObject:objv forKey:key];
}

- (void)encodeBool:(BOOL)boolv forKey:(NSString *)key
{
    [self encodeObject:(__bridge id)(boolv ? kCFBooleanTrue : kCFBooleanFalse) 
                forKey:key];
}

- (void)encodeInt:(int)intv forKey:(NSString *)key
{
    [self encodeObject:[NSNumber numberWithInt:intv] forKey:key];
}

- (void)encodeInt32:(int32_t)intv forKey:(NSString *)key
{
    [self encodeObject:[NSNumber numberWithInt:intv] forKey:key];
}

- (void)encodeInt64:(int64_t)intv forKey:(NSString *)key
{
    [self encodeObject:[NSNumber numberWithLongLong:intv] forKey:key];
}

- (void)encodeFloat:(float)realv forKey:(NSString *)key
{
    [self encodeObject:[NSNumber numberWithFloat:realv] forKey:key];
}

- (void)encodeDouble:(double)realv forKey:(NSString *)key
{
    [self encodeObject:[NSNumber numberWithDouble:realv] forKey:key];
}

- (void)encodeBytes:(const uint8_t *)bytesp length:(NSUInteger)lenv forKey:(NSString *)key
{
    [self encodeObject:[NSData dataWithBytes:bytesp length:lenv] forKey:key];
}

- (void)encodeInteger:(NSInteger)intv forKey:(NSString *)key
{
    [self encodeObject:[NSNumber numberWithInteger:intv] forKey:key];
}


#pragma mark - Old-school non-keyed archiving

- (void)encodeValueOfObjCType:(const char *)type at:(const void *)addr
{
    id toEncode = nil;
    
    switch(type[0])
	{
		case '@': // object
		case '#': // class
			toEncode = (__bridge id)*((void **)addr);
			break;
		case '*': // (char *) string
            toEncode = [NSData dataWithBytes:*(const char **)addr 
                                      length:strlen(*(const char **)addr) + 1];
			break;
		case ':': // SEL
			toEncode = NSStringFromSelector(*((SEL *)addr));
			break;
        case 'c': // A char
            toEncode = [NSNumber numberWithChar:*(char *)addr];
            break;
        case 's': // A short
            toEncode = [NSNumber numberWithShort:*(char *)addr];
            break;
        case 'i': // An int
        case 'l': // A long (treated as a 32-bit quantity on 64-bit).
            toEncode = [NSNumber numberWithInt:*(int *)addr];
            break;
        case 'q': // A long long
            toEncode = [NSNumber numberWithLongLong:*(int *)addr];
            break;
        case 'C': // An unsigned char
            toEncode = [NSNumber numberWithUnsignedChar:*(char *)addr];
            break;
        case 'S': // An unsigned short
            toEncode = [NSNumber numberWithUnsignedShort:*(char *)addr];
            break;
        case 'I': // An unsigned int
        case 'L': // An unsigned long
            toEncode = [NSNumber numberWithUnsignedInt:*(int *)addr];
            break;
        case 'Q': // An unsigned long long
            toEncode = [NSNumber numberWithUnsignedLongLong:*(int *)addr];
            break;
        case 'f': // A float
            toEncode = [NSNumber numberWithFloat:*(float *)addr];
            break;
        case 'd': // A double
            toEncode = [NSNumber numberWithDouble:*(double *)addr];
            break;
        case 'B': // A C++ bool or a C99 _Bool
            toEncode = (__bridge id)(*(_Bool *)addr ? kCFBooleanTrue : kCFBooleanFalse);
            break;
		default: 
            [NSException raise:YACYAMLUnsupportedTypeException format:@"Tried to encode value of unhandled type"];
	}
    
    NSString *n = nil;
    [self encodeObject:toEncode forKey:n];
}

- (void)encodeDataObject:(NSData *)data
{
    NSString *n = nil;
    [self encodeObject:data forKey:n];
}

@end
