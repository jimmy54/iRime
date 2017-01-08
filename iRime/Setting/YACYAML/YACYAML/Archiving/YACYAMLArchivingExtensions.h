//
//  YACYAMLArchivingExtensions.h
//  YACYAML
//
//  Created by James Montgomerie on 18/05/2012.
//  Copyright (c) 2012 James Montgomerie. All rights reserved.
//

#import "YACYAMLKeyedArchiver.h"


@interface NSObject (YACYAMLArchivingExtensions) <YACYAMLArchivingCustomEncoding>
@end


@interface NSString (YACYAMLArchivingExtensions) <YACYAMLArchivingCustomEncoding>
@end

@interface NSNumber (YACYAMLArchivingExtensions) <YACYAMLArchivingCustomEncoding>
@end

@interface NSDate (YACYAMLArchivingExtensions) <YACYAMLArchivingCustomEncoding>
@end


@interface NSArray (YACYAMLArchivingExtensions) <YACYAMLArchivingCustomEncoding>
@end

@interface NSDictionary (YACYAMLArchivingExtensions) <YACYAMLArchivingCustomEncoding>
@end

@interface NSNull (YACYAMLArchivingExtensions) <YACYAMLArchivingCustomEncoding>
@end

@interface NSSet (YACYAMLArchivingExtensions) <YACYAMLArchivingCustomEncoding>
@end


@interface NSData (YACYAMLArchivingExtensions) <YACYAMLArchivingCustomEncoding>
@end