//
//  YACYAMLUnarchivingExtensions.h
//  YACYAML
//
//  Created by James Montgomerie on 29/05/2012.
//  Copyright (c) 2012 James Montgomerie. All rights reserved.
//

#import "YACYAMLKeyedUnarchiver.h"

void YACYAMLUnarchivingExtensionsRegister(void);

@interface NSNumber (YACYAMLUnarchivingExtensions) <YACYAMLUnarchivingScalar>
@end

@interface NSDate (YACYAMLUnarchivingExtensions) <YACYAMLUnarchivingScalar>
@end

@interface NSData (YACYAMLUnarchivingExtensions) <YACYAMLUnarchivingScalar>
@end

@interface NSNull (YACYAMLUnarchivingExtensions) <YACYAMLUnarchivingScalar>
@end



@interface NSArray (YACYAMLUnarchivingExtensions) <YACYAMLUnarchivingSequence>
@end

@interface NSDictionary (YACYAMLUnarchivingExtensions) <YACYAMLUnarchivingMapping>
@end

@interface NSSet (YACYAMLUnarchivingExtensions) <YACYAMLUnarchivingMapping>
@end

