//
//  NSString+path.h
//  iRime
//
//  Created by jimmy54 on 8/9/16.
//  Copyright © 2016 jimmy54. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SETTING_FILE_PATH  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface NSString (Path)



+(NSString*) hostAppBundlePath;

+(NSString*) appendingHostAppBundlePath:(NSString*)name;

+(NSString*)zipFile;

+(NSString*)DocumentsPath:(NSString*)path;

+ (NSString*)userPath;

+(NSString*)rimeResource;

+(NSString*)groupRime;


+(NSUserDefaults*)userDefaultsInGroup;
@end
