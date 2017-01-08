//
//  YACYAMLKeyedArchiver.h
//  YACYAML
//
//  Created by James Montgomerie on 17/05/2012.
//  Copyright (c) 2012 James Montgomerie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum YACYAMLKeyedArchiverOptions {    
    YACYAMLKeyedArchiverOptionNone                      = 0x00,
    
    /*
     I'd like to implement this, and make it the default for the simple
     -YACYCAMLEncodedString and -YACYAMLEncodedData methods, but I can't
     work out a safe way to do it given that keys can me arbitrary objects
     of arbitrary classes, and might not implement -compare:, and even
     if they do, might not be comparabe to other keys.
     
    // Order output mapping elements by key, for human-readabiliy.
    YACYAMLKeyedArchiverOptionOrderMappingContentsByKey = 0x01,
    */
    
    // Objects that appear more than once in an archive are output only
    // once, with subsequent uses encoded as a reference to the first (this
    // is important to allow cycles to be encoded, but also saves space
    // in the general case).  By default, 'isEqual' is used to compare
    // objects.  If this option is specified, only pointer equality will
    // be considered. 
    YACYAMLKeyedArchiverOptionDontUseObjectEquality     = 0x02,
    
    // By default, to aid human readability, native scalars (strings, numbers 
    // etc.) are always be output in full in the encoded YAML, even if they 
    // compare equal to earlier scalars.
    // With this option switched on, anchors will be used to ensure
    // that unique strings are output only once, as for other classes of
    // object (although note  this option will interact with 
    // YACYAMLKeyedArchiverOptionDontUseObjectEquality).
    // It might be a good idea to switch this on if you're not intending
    // your archive to be human-readable.
    YACYAMLKeyedArchiverOptionAllowScalarAnchors        = 0x04,
} YACYAMLKeyedArchiverOptions;

@interface YACYAMLKeyedArchiver : NSCoder

+ (NSData *)archivedDataWithRootObject:(id)rootObject;
+ (NSData *)archivedDataWithRootObject:(id)rootObject options:(YACYAMLKeyedArchiverOptions)options;

+ (NSString *)archivedStringWithRootObject:(id)rootObject;
+ (NSString *)archivedStringWithRootObject:(id)rootObject options:(YACYAMLKeyedArchiverOptions)options;

+ (BOOL)archiveRootObject:(id)rootObject toFile:(NSString *)path;

- (id)initForWritingWithMutableData:(NSMutableData *)data;
- (id)initForWritingWithMutableData:(NSMutableData *)data options:(YACYAMLKeyedArchiverOptions)options;

- (id)initForWritingToFile:(NSString *)path;
- (id)initForWritingToFile:(NSString *)path options:(YACYAMLKeyedArchiverOptions)options;

- (void)finishEncoding;

@end


// The below can be implemented in any classes you want to instantiate for 
// specific YAML tags.  Note that for application-specific classes that are 
// intended to be encoded with the regular encodeWithCoder: methods, it it 
// _not_ necessary to implement these! 

@protocol YACYAMLArchivingCustomEncoding

// The YAML tag for this object.
// For example, NSArray will return "tag:yaml.org,2002:seq", NSNumber will
// return "tag:yaml.org,2002:int", "tag:yaml.org,2002:float" etc. as 
// appropriate.
@property (nonatomic, weak, readonly) NSString *YACYAMLArchivingTag;

// YES if the tag be skipped in non-quoted style output for this object.
@property (nonatomic, assign, readonly) BOOL YACYAMLArchivingTagCanBePlainImplicit;

// YES if the tag be skipped in quoted style output for this object.
@property (nonatomic, assign, readonly) BOOL YACYAMLArchivingTagCanBeQuotedImplicit;


@optional

// Implement this to encode a non-scalar object in a way that's custom to YAML.
// Will be called in place of encodeWithCoder:, if it's implemented.
// For example, an NSArray category overrides this to simple call:
// 
//  for(id obj in self) {
//      [coder encodeObject:obj];
//  }
- (void)YACYAMLEncodeWithCoder:(YACYAMLKeyedArchiver *)coder;

// Implement this to encode a scalar object in a way that's custom to YAML.
// Will be called in place of encodeWithCoder:, if it's implemented.
// For example, an NSNumber category overrides this to convert numbers to 
// YAML-spec-compliant string representations.
- (NSString *)YACYAMLScalarString; 

@end