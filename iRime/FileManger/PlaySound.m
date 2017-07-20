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


@implementation PlaySound



//当音频播放完毕会调用这个函数
static void SoundFinished(SystemSoundID soundID,void* sample){
    /*播放全部结束，因此释放所有资源 */
    AudioServicesDisposeSystemSoundID(sample);
    CFRelease(sample);
    CFRunLoopStop(CFRunLoopGetCurrent());
}


+(BOOL)playSound:(NSString *)soundPath
{
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:soundPath] == NO) {
        NSLog(@"sound path is no exist");
        return NO;
    }
    /*系统音频ID，用来注册我们将要播放的声音*/
    SystemSoundID soundID;
    NSURL* sample = [[NSURL alloc]initWithString:soundPath];
    
    OSStatus err = AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(sample), &soundID);
    if (err) {
        NSLog(@"Error occurred assigning system sound!");
        return NO;
    }
    /*添加音频结束时的回调*/
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, SoundFinished,(__bridge void * _Nullable)(sample));
    /*开始播放*/
    AudioServicesPlaySystemSound(soundID);
    CFRunLoopRun();
    return YES;

}


+(void)playDefaultSound
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [NSString rimeResource], @"default.caf"];
    [PlaySound playSound:path];
    
}

@end
