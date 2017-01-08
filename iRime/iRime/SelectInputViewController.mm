//
//  SelectInputViewController.m
//  iRime
//
//  Created by jimmy54 on 8/15/16.
//  Copyright © 2016 jimmy54. All rights reserved.
//

#import "SelectInputViewController.h"
#import "IASKSpecifier.h"


#import "IASKSettingsReader.h"
#import "IASKSettingsStoreUserDefaults.h"

#import "NSString+Path.h"


#import "RimeConfigController.h"
#import "RimeConfigSchema.h"






@interface SelectInputViewController ()<UITableViewDelegate, UITableViewDataSource>{
}


@property(nonatomic, strong)NSArray *schemaConfigs;
@property(nonatomic, strong)NSString *currentSchema;





@end

@implementation SelectInputViewController


- (id)initWithFile:(NSString*)file specifier:(IASKSpecifier*)specifier {
    if ((self = [super init])) {
        // custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"选择你喜欢的输入法";
    
    self.schemaConfigs = [RimeConfigController sharedInstance].schemata;
    _currentSchema = [RimeConfigController sharedInstance].currentSchema;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setCurrentSchema:(NSString *)currentSchema
{
    _currentSchema = currentSchema;
    [[RimeConfigController sharedInstance] setCurrentSchema:currentSchema];
    
}




#pragma mark -- table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.schemaConfigs.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"schemaCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"schemaCell"];
    }
    
    
    RimeConfigSchema *schema = [self.schemaConfigs objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = schema.name;
    
    if ([schema.schemaId isEqualToString:self.currentSchema]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    
    RimeConfigSchema *schema = [self.schemaConfigs objectAtIndex:[indexPath row]];
    self.currentSchema = schema.schemaId;

    [tableView reloadData];
    
}


@end
