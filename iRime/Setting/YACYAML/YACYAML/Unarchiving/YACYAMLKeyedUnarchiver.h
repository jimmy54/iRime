//
//  YACYAMLKeyedUnarchiver.h
//  YACYAML
//
//  Created by James Montgomerie on 24/05/2012.
//  Copyright (c) 2012 James Montgomerie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum YACYAMLKeyedUnarchiverOptions {    
    YACYAMLKeyedUnarchiverOptionNone                    = 0x00,
    
    // Usually, the first (perhaps implicit) document in the YAML file is read
    // and its contents are presented as the top-level contents of the archive.
    // This matches the behaviour of YACYAMLKeyedArchiver, which places the 
    // archived contents into an implicit single document.  
    // If you're using this class to parse YAML that will have mutiple documents
    // in a stream, switching this on causes each document to be a top-level
    // object, instantiated as an NSArray.
    YACYAMLKeyedUnarchiverOptionPresentDocumentsAsArray = 0x01,
    
    // You whould set this to YES if the YAML file you're parsing is from an 
    // unknown source, and you don't want the unarchiver to be instantiating
    // objects of arbitraty types and calling initWithCoder: on them (of course,
    // a better strategy might be to make sure all your initWithCoder: methods
    // are safe...).
    YACYAMLKeyedUnarchiverOptionDisallowInitWithCoder   = 0x02,
} YACYAMLKeyedUnarchiverOptions;


@interface YACYAMLKeyedUnarchiver : NSCoder

// See comments in YACYAMLKeyedUnarchiverOptions.
@property (nonatomic, readonly, getter = isInitWithCoderDisallowed) BOOL initWithCoderDisallowed;

+ (id)unarchiveObjectWithString:(NSString *)string;
+ (id)unarchiveObjectWithString:(NSString *)data options:(YACYAMLKeyedUnarchiverOptions)options;

+ (id)unarchiveObjectWithData:(NSData *)data;
+ (id)unarchiveObjectWithData:(NSData *)data options:(YACYAMLKeyedUnarchiverOptions)options;

+ (id)unarchiveObjectWithFile:(NSString *)path;
+ (id)unarchiveObjectWithFile:(NSString *)path options:(YACYAMLKeyedUnarchiverOptions)options;

- (id)initForReadingWithData:(NSData *)data;
- (id)initForReadingWithData:(NSData *)data options:(YACYAMLKeyedUnarchiverOptions)options;

- (id)initForReadingWithFile:(NSString *)path;
- (id)initForReadingWithFile:(NSString *)path options:(YACYAMLKeyedUnarchiverOptions)options;


// Use this to register classes that should be handled specially by the 
// unarchiver (see below).
+ (void)registerUnarchivingClass:(Class)unarchivingClass;

@end


// The below can be implemented in any classes you want to instantiate for 
// specific YAML tags.  Note that for application-specific classes encoded with 
// the encodeWithCoder: methods, it it _not_ necessary to implement these! 
// They're intended to give more specific control only if necessary.
// Remember to call [YACYAMLUnarchiver registerUnarchivingClass:] for any 
// classes you implement these on before trying to decode!

@protocol YACYAMLUnarchivingSequence

// This class will be instantiated for any YAML tags in this array.
// For example, to handle YAML sequences, a category is defined on 
// NSMutableArray that returns:
//     [NSArray arrayWithObject: @"tag:yaml.org,2002:seq"];
// Then, for any YAML entity that has the @"tag:yaml.org,2002:seq" tag, 
// an NSMutableArray is instantiated, and its elements are set with the 
// YACYAMLUnarchivingSetObject... instance method, below.
+ (NSArray *)YACYAMLUnarchivingTags;

// Should construct and return an object that YACYAMLUnarchivingAddObject: can 
// be called on to add elements.
+ (id)objectForYACYAMLUnarchiving;

// Called for each decoded child of the sequence.
- (void)YACYAMLUnarchivingAddObject:(id)object;

@end

// Similar to the above, but for classes represented by YAML mappings.
@protocol YACYAMLUnarchivingMapping

+ (NSArray *)YACYAMLUnarchivingTags;


// Should construct and return an object that YACYAMLUnarchivingSetObject:forKey:
// can be called on to add elements. 
+ (id)objectForYACYAMLUnarchiving;

// Called for each decoded child of the sequence. For fully spec-compliant YAML
// decoding, this should /not/ copy the keys as a normal NSDictionary's
// setObject:forKey: would.
- (void)YACYAMLUnarchivingSetObject:(id)object
                             forKey:(id)key;

@end


// Used to provide support for mapping YAML scalars to ObjC objects.
@protocol YACYAMLUnarchivingScalar

// This class will be instantiated for any YAML tags in this array.
// For example, to handle YAML sequences, a category is defined on NSData
// that returns:
//     [NSArray arrayWithObject: @"tag:yaml.org,2002:binary"];
// Then, for any YAML entity that has the @"tag:yaml.org,2002:binary" tag, 
// an NSMutableArray is instantiated, and its elements are set with the 
// init methods defined below.
+ (NSArray *)YACYAMLUnarchivingTags;

@optional

// Should this class be instantiated for a given scalar string with no tag?
// For example, a class representing YAML's "tag:yaml.org,2002:float" scalar
// would return YES for strings matching a
//     [-+]?([0-9][0-9_]*)?\\.[0-9.]*([eE][-+][0-9]+)?|[-+]?[0-9][0-9_]*(:[0-5]?[0-9])+\\.[0-9_]*
// regex (as specified in the YAML spec).
// [Note that, in reality, "tag:yaml.org,2002:float" is already handled by a 
// category on NSNumber].
+ (BOOL)YACYAMLImplicitlyMatchesScalarString:(NSString *)scalarString;

// Used to construct objects matching the YAML tag or scalars with strings
// matching the NSPredicate, above.
+ (id)objectWithYACYAMLScalarString:(NSString *)string;
+ (id)objectWithYACYAMLScalarUTF8String:(const char *)UTF8String length:(NSUInteger)length;

@end