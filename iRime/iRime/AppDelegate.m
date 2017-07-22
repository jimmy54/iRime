//
//  AppDelegate.m
//  Rime
//
//  Created by jimmy54 on 5/30/16.
//  Copyright © 2016 jimmy54. All rights reserved.
//

#import "AppDelegate.h"
//#import "RimeWrapper.h"
#import "rime_api.h"
#import "SHUIKit.h"

#import <UMMobClick/MobClick.h>
#import "NSString+Path.h"



#import <SVProgressHUD.h>


#import "FileManger.h"

#import <UIAlertView+Blocks.h>


#define UMENG_KEY @"57aff5d267e58ec99c001744"


//
#define JSPATCH_KEY @"1bdd98ec14063b9c"
//
//
//
//#ifdef DEBUG
//#import <PgySDK/PgyManager.h>
//
//#define PGYTER_APPID @"f7b4ca2b283e8c232ede5780ec6236f2"
//#endif

#import "RimeConfigController.h"

@interface AppDelegate (){
}



@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // Set Rime notification handler
    
    /**
     *  umeng
     */
    UMConfigInstance.appKey = UMENG_KEY;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    

    
//
//#ifdef DEBUG
//    /**
//     *  PGYER TEST
//     */
//    
//    //启动基本SDK
//    [[PgyManager sharedPgyManager] startManagerWithAppId:PGYTER_APPID];
//#endif
    
    
    FileManger *fm = [FileManger new];
    
    fm.endBlock = ^{
        
//        [[RimeConfigController sharedInstance] loadConfig];
    
    };
    
    [fm initSettingFile];
    
    
    
    
    [SVProgressHUD setBackgroundColor:[UIColor darkGrayColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
    
    

//    [RimeWrapper startService];
    
    
    //create the dir
    
    
    NSString *rimePath = nil;
    NSString *userPath = nil;
    
    rimePath = [NSString rimeResource];
    userPath = [NSString userPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *err = nil;
    if (![fileManager fileExistsAtPath:rimePath]) {
        if (![fileManager createDirectoryAtPath:rimePath withIntermediateDirectories:YES attributes:nil error:&err]) {
            NSLog(@"Failed to create rime data directory. err:%@", err);
            return NO;
        }
    }
    
    if (![fileManager fileExistsAtPath:userPath]) {
        if (![fileManager createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:&err]) {
            NSLog(@"Failed to create user data directory.  err :%@", err);
            return NO;
        }
    }
    
    
    

    
    return YES;
}






- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // Stop Rime service
//    [RimeWrapper stopService];
    
    // Destroy IMKServer
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    if ([url.absoluteString hasSuffix:@"create.iRime.dir"]) {
        
        [UIAlertView showWithTitle:@"提示" message:@"第一次使用需要部署一下" cancelButtonTitle:nil otherButtonTitles:@[@"确认"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                [SVProgressHUD showSuccessWithStatus:@"部署成功！可以返回使用iRime输入法了"];
            }
        ];
        
    }

        
        
    
    return YES;
}


#pragma mark Key Up Event Handler

//- (RimeConfigController *)configController {
//    if (!_configController) {
//        RimeConfigError *error;
//        
//        _configController = [[RimeConfigController alloc] init:&error];
//        
//        if (!_configController) {
//            NSString *message;
//            NSString *info;
//            
//            switch ([error errorType]) {
//                case RimeConfigFolderNotExistsError:
//                    message = NSLocalizedString(@"Rime configuration folder does not exist", nil);
//                    info = [NSString stringWithFormat:NSLocalizedString(@"Should run the Deploy command with file path", nil), [RimeConfigController rimeFolder]];
//                    break;
//                case RimeConfigFileNotExistsError:
//                    message = NSLocalizedString(@"Rime configuration file does not exist", nil);
//                    info = [NSString stringWithFormat:NSLocalizedString(@"Should run the Deploy command with file path", nil), [error configFile]];
//                    break;
//                default:
//                    message = NSLocalizedString(@"Rime configuration loading failed", nil);
//                    info = NSLocalizedString(@"Should run the Deploy command with further info", nil);
//                    break;
//            }
//            NSString *buttonLabel = NSLocalizedString(@"OK", nil);
////            [SHUIKit alertWithMessage:message info:info cancelButton:buttonLabel];
//            
//            return nil;
//        }
//    }
//    
//    return _configController;
//}


@end
