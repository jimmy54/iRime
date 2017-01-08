//
//  NSString+path.m
//  iRime
//
//  Created by jimmy54 on 8/9/16.
//  Copyright © 2016 jimmy54. All rights reserved.
//

#import "NSString+Path.h"




#define ZIP_FILE @"iRime"
#define USER_PATH @"user"
#define GROUP_ID @"group.Rime"


@implementation NSString (Path)

+(NSString*) hostAppBundlePath
{
    
    NSString *userDataDir = [[NSBundle mainBundle] executablePath];
    
    NSRange r = [userDataDir rangeOfString:@".app"];
    r = NSMakeRange(0, r.location + r.length);
    NSString *Dir = [userDataDir substringWithRange:r];
//    userDataDir = [NSString stringWithFormat:@"%@/%@", Dir, name];
    return  Dir;
}

+(NSString*) appendingHostAppBundlePath:(NSString*)name
{
    NSString *path = [NSString hostAppBundlePath];
    return [NSString stringWithFormat:@"%@/%@", path, name];
}


+(NSString*)zipFile
{
    
    return [NSString appendingHostAppBundlePath:[ZIP_FILE stringByAppendingString:@".zip"]];
    
}

+(NSString*)DocumentsPath:(NSString*)path
{
    
    NSString *p = [NSString stringWithFormat:@"%@/%@", SETTING_FILE_PATH, path];
    return p;
    
}

+ (NSString*)userPath
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *url = [fm containerURLForSecurityApplicationGroupIdentifier:GROUP_ID];
    
    NSString *path = [[url path] stringByAppendingString:[NSString stringWithFormat:@"/%@", USER_PATH]];
    return path;
}

+(NSString*)rimeResource
{
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *url = [fm containerURLForSecurityApplicationGroupIdentifier:GROUP_ID];
    
    NSString *path = [[url path] stringByAppendingString:[NSString stringWithFormat:@"/%@", ZIP_FILE]];
    return path;
}

+(NSString*)groupRime
{
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *url = [fm containerURLForSecurityApplicationGroupIdentifier:GROUP_ID];
    
    return url.path;
}

+(NSUserDefaults*)userDefaultsInGroup
{
    NSUserDefaults *df = [[NSUserDefaults alloc]initWithSuiteName:GROUP_ID];
    return df;
}

@end
