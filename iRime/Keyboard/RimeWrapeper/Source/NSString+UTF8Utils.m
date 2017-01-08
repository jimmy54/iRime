//
//  NSString+UTF8Utils.m
//  XIME
//
//  Created by Stackia <jsq2627@gmail.com> on 10/22/14.
//  Copyright (c) 2014 Stackia. All rights reserved.
//

#import "NSString+UTF8Utils.h"

static const unsigned char vUTF8codeUnitNum[256] = { // Lookup table for code unit count of a UTF-8 byte
    // 1-byte: 0xxxxxxx
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    
    // Trailing: 10xxxxxx
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    
    // 2-byte leading: 110xxxxx
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    
    // 3-byte leading: 1110xxxx
    // 4-byte leading: 11110xxx
    // Invalid: 11111xxx
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,0,0,0,0,0,0,0,0
};

@implementation NSString (UTF8Utils)

+ (int)NSStringPosFromUTF8Pos:(int)vUTF8Pos string:(const char *)string strictMode:(BOOL)strictMode {
    if (!string) {
        return 0;
    }
    const unsigned char *uString = (const unsigned char *)string;
    size_t len = strlen(string);
    if (vUTF8Pos >= len) {
        if (strictMode) {
            vUTF8Pos = (int)len - 1;
        } else {
            vUTF8Pos = (int)len;
        }
    }
    int pos = -1;
    for (int i = 0; i <= vUTF8Pos; ++i) {
        pos += vUTF8codeUnitNum[uString[i]];
    }
    return pos;
}

+ (int)NSStringLengthOfUTF8String:(const char *)string {
    if (!string) {
        return 0;
    }
    const unsigned char *uString = (const unsigned char *)string;
    size_t ulen = strlen(string);
    int len = 0;
    for (int i = 0; i < ulen; ++i) {
        len += vUTF8codeUnitNum[uString[i]];
    }
    return len;
}

@end
