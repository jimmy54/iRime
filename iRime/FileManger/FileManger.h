//
//  FileManger.h
//  iRime
//
//  Created by jimmy54 on 8/26/16.
//  Copyright © 2016 jimmy54. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void(^initSettingFileStartBlock)(void);
typedef void(^initSettingFileEndBlock)(void);


@interface FileManger : NSObject


@property(nonatomic, strong)initSettingFileStartBlock startBlock;
@property(nonatomic, strong)initSettingFileEndBlock endBlock;

-(BOOL)checkSettingFileAavid;
-(void)initSettingFile;
-(void)recoverSetting;




@end
