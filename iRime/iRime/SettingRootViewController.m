//
//  ViewController.m
//  iRime
//
//  Created by jimmy54 on 6/15/16.
//  Copyright © 2016 jimmy54. All rights reserved.
//

#import "SettingRootViewController.h"

#import "IASKSettingsReader.h"
#import "IASKSettingsStoreUserDefaults.h"

#import "RimeWrapper.h"
#import "rime_api.h"

#import <UIAlertView+Blocks.h>
#import "FileManger.h"


#import <UIKit/UIKit.h>

#import <TUSafariActivity.h>
#import <ARChromeActivity.h>

#import <AFWebViewController.h>


#import "RimeConfigController.h"
#import "NSString+Path.h"
#import "common.h"



@interface SettingRootViewController ()<IASKSettingsDelegate>


@end

@implementation SettingRootViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.delegate = self;
    self.showCreditsFooter = NO;
    
//    [self setupSchemaList];
    
    
    self.title = @"iRime输入法";
    
    
}

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingDidChange:) name:kIASKAppSettingChanged object:nil];
}





#pragma mark kIASKAppSettingChanged notification
- (void)settingDidChange:(NSNotification*)notification
{
    
    NSLog(@"%@", notification);
    NSNumber *n = [notification.userInfo objectForKey:@"CC"];
    if (n) {
        
        NSUserDefaults *df = [NSString userDefaultsInGroup];
        [df setObject:n forKey:CURRENT_CC];
        
    }
    
    
    

}

#pragma mark -
- (void)settingsViewController:(IASKAppSettingsViewController*)sender buttonTappedForSpecifier:(IASKSpecifier*)specifier {
    
    if ([specifier.key isEqualToString:@"recoverSetting"]) {
        
        
        [UIAlertView showWithTitle:@"警告" message:@"即将还原所有配置？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            
            
            if (buttonIndex == 1) {
                
                FileManger *fm = [FileManger new];
                
                fm.endBlock = ^{
                    
                    
                    [[RimeConfigController sharedInstance] loadConfig];
                    
                
                };
                
                [fm recoverSetting];
                
            }
            
            
        }];

    }else if ([specifier.key isEqualToString:@"shareToFriend"]){
        
        NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/irime-shu-ru-fa/id1142623977?l=en&mt=8"];
        if (url) {
            // More activities should be added in the future
            
            NSString *title = @"Rime安全好用，能DIY的输入法";
            UIImage *icon = [UIImage imageNamed:@"icon"];
            
            NSArray *activities = @[[TUSafariActivity new], [ARChromeActivity new]];
            if ([[url absoluteString] hasPrefix:@"file:///"]) {
                UIDocumentInteractionController *documentController = [UIDocumentInteractionController interactionControllerWithURL:url];
                [documentController presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
            }
            else {
                UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[title, icon, url] applicationActivities:activities];
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    UIPopoverPresentationController *popover = activityController.popoverPresentationController;
                    popover.sourceView = self.view;
//                    popover.barButtonItem = sender;
                }
                
                [self presentViewController:activityController animated:YES completion:NULL];
            }
        }
    }else if ([specifier.key isEqualToString:@"feedback"]){
        
        
        
        AFWebViewController *af = [AFWebViewController webViewControllerWithAddress:@"http://tieba.baidu.com/p/4753235744"];
        [self.navigationController pushViewController:af animated:YES];
        
        
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark -- setting delegate

- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender
{
    NSLog(@"%@", sender);
}



@end
