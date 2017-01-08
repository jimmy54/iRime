//
//  NSString+UTF8Utils.h
//  XIME
//
//  Created by Stackia <jsq2627@gmail.com> on 10/22/14.
//  Copyright (c) 2014 Stackia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UTF8Utils)

/// Get UTF-16 code unit position from a UTF-8 byte position
+ (int)NSStringPosFromUTF8Pos:(int)vUTF8Pos string:(const char *)string strictMode:(BOOL)strictMode;

/// Get the number of UTF-16 code unit in a UTF-8 string
+ (int)NSStringLengthOfUTF8String:(const char *)string;

@end
