//
//  YACYAMLExtensions.h
//  YACYAML
//
//  Created by James Montgomerie on 31/05/2012.
//  Copyright (c) 2012 James Montgomerie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (YACYAMLExtensions)

// Will return the results of encding this object with a YACYAMLKeyedArchiver.
// Like e.g. Ruby's "to_yaml".
- (NSString *)YACYAMLEncodedString;
- (NSData *)YACYAMLEncodedData;

@end

@interface NSString (YACYAMLExtensions)

// These are synonyms.  Will return the result of using a YACYAMLKeyedUnarchiver
// on the contents of the string, with the 
// YACYAMLKeyedUnarchiverOptionDisallowInitWithCoder option turned on (so it
// will not instantiate objects using initWithCoder:)
- (id)YACYAMLDecode;
- (id)YACYAMLDecodeBasic;

// Will return the result of using a YACYAMLKeyedUnarchiver
// on the contents of the string, with the defaultOptions (so it _will_
// instantiate objects using initWithCoder:).
- (id)YACYAMLDecodeAll;

@end

@interface NSData (YACYAMLExtensions)

// These are synonyms.  Will return the result of using a YACYAMLKeyedUnarchiver
// on the contents of the string, with the 
// YACYAMLKeyedUnarchiverOptionDisallowInitWithCoder option turned on (so it
// will not instantiate objects using initWithCoder:)
- (id)YACYAMLDecode;
- (id)YACYAMLDecodeBasic;

// Will return the result of using a YACYAMLKeyedUnarchiver
// on the contents of the string, with the defaultOptions (so it _will_
// instantiate objects using initWithCoder:).
- (id)YACYAMLDecodeAll;

@end
