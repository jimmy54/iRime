//
//  GuideViewController.m
//  iRime
//
//  Created by jimmy54 on 8/27/16.
//  Copyright © 2016 jimmy54. All rights reserved.
//
#import "SettingFileViewController.h"
#ifdef USES_IASK_STATIC_LIBRARY
#import "InAppSettingsKit/IASKSpecifier.h"
#else
#import "IASKSpecifier.h"
#endif

#import "GuideViewController.h"

#define url @"http://rime.im/docs/"


@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"使用教程";
}


- (id)initWithFile:(NSString*)file specifier:(IASKSpecifier*)specifier {
    
    
    self = [super initWithAddress:url];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
