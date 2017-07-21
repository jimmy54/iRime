//
//  PlaySound.m
//  iRime
//
//  Created by jimmy on 21/07/2017.
//  Copyright © 2017 jimmy54. All rights reserved.
//

#import "PlaySound.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CoreFoundation/CoreFoundation.h>
#import "NSString+Path.h"


static SystemSoundID sSoundID = -1;
static NSString *sSoundPath = nil;

@implementation PlaySound



//当音频播放完毕会调用这个函数
static void SoundFinished(SystemSoundID soundID,void* sample){
    /*播放全部结束，因此释放所有资源 */
//    AudioServicesDisposeSystemSoundID(sample);
//    CFRelease(sample);
//    CFRunLoopStop(CFRunLoopGetCurrent());
}

+(void)setSoundPath:(NSString*)path
{
    sSoundPath = path;
}


+(void)playSound
{
    //test
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", [NSString rimeResource], @"default.caf"];
    sSoundPath = path;
    //
    
    [PlaySound playSoundWithFile:sSoundPath];
}



+(BOOL)playSoundWithFile:(NSString *)soundPath
{
    
    if ([soundPath isEqualToString:sSoundPath] && soundPath != nil) {
        if (sSoundID != -1) {
            AudioServicesPlaySystemSound(sSoundID);
            return YES;
        }
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:soundPath] == NO) {
        NSLog(@"sound path is no exist");
        return NO;
    }
    
    sSoundPath = soundPath;
    /*系统音频ID，用来注册我们将要播放的声音*/
    
//    SystemSoundID soundID;
    NSURL* sample = [[NSURL alloc]initWithString:soundPath];
    
    OSStatus err = AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(sample), &sSoundID);
    if (err) {
        NSLog(@"Error occurred assigning system sound!");
        return NO;
    }
    /*添加音频结束时的回调*/
    AudioServicesAddSystemSoundCompletion(sSoundID, NULL, NULL, SoundFinished,(__bridge void * _Nullable)(sample));
    /*开始播放*/
    AudioServicesPlaySystemSound(sSoundID);
//    CFRunLoopRun();

    return YES;

}


+(void)playDefaultSound
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [NSString rimeResource], @"default.caf"];
    [PlaySound playSoundWithFile:path];
    
}

@end
