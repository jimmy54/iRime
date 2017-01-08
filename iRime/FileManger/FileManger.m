//
//  FileManger.m
//  iRime
//
//  Created by jimmy54 on 8/26/16.
//  Copyright © 2016 jimmy54. All rights reserved.
//

#import "FileManger.h"
#import <ZipArchive/ZipArchive.h>
#import <SVProgressHUD.h>
#import "NSString+Path.h"

typedef void(^initSettingFileCompleteBlock)(void);
typedef void(^recoverSettingFileCompleteBlock)(void);




@interface FileManger ()


@property(nonatomic, strong)ZipArchive *zip;


@property(nonatomic, assign)dispatch_source_t source;

@end

@implementation FileManger


-(instancetype)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

-(void)monitorWithPath:(NSString*)path
{
   
    NSURL *directoryURL = [NSURL URLWithString:path];
    
    int const fd =
    open([[directoryURL path] fileSystemRepresentation], O_EVTONLY);
    if (fd < 0) {
        
        NSLog(@"Unable to open the path = %@", [directoryURL path]);
        return;
    }
    dispatch_source_t source =
    dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, fd,
                           DISPATCH_VNODE_WRITE | DISPATCH_VNODE_RENAME,
                           DISPATCH_TARGET_QUEUE_DEFAULT);
    dispatch_source_set_event_handler(source, ^() {
        unsigned long const type = dispatch_source_get_data(source);
        
        switch (type) {
            case DISPATCH_VNODE_WRITE: {
                NSLog(@"目录内容改变!!!");
                break;
            }
            case DISPATCH_VNODE_RENAME: {
                NSLog(@"目录被重命名!!!");
                break;
            }
                
            default:
                break;
        }
    });
    dispatch_source_set_cancel_handler(source, ^() { close(fd); });
    self.source = source;
    dispatch_resume(self.source);
}




-(BOOL)checkSettingFileAavid
{
    
    NSFileManager *fg = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    BOOL res = [fg fileExistsAtPath:[NSString rimeResource] isDirectory:&isDir];
    if (res == YES && isDir == YES) {
        return YES;
    }else{
        [fg createDirectoryAtPath:[NSString rimeResource] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return res;
    
}


-(void)initSettingFile
{
    
     if (self.startBlock) {
        self.startBlock();
    }   
    
    if ([self checkSettingFileAavid]) {
        if (self.endBlock) {
            self.endBlock();
        }
        return;
    }
    
    
    initSettingFileCompleteBlock complete = ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD showInfoWithStatus:@"恭喜你，还原配置成功"];
            
            if (self.endBlock) {
                self.endBlock();
            }
            
        });
    
    };
    
    

    
    [SVProgressHUD showWithStatus:@"初始化数据中，请稍候..." maskType:SVProgressHUDMaskTypeBlack];
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        
        
        NSFileManager *fg = [NSFileManager defaultManager];
        BOOL res = NO;
        //    文件不存在，重新拷贝文件到DOCUMENTS目录
        NSString *path = [NSString zipFile];
        
        if (self.zip == nil) {
            self.zip = [[ZipArchive alloc] initWithFileManager:fg];
        }
        
        
        res = [self.zip UnzipOpenFile:path];
        if (res == NO) {
            NSLog(@"压缩文件出错");
            return;
        }
        
        res = [self.zip UnzipFileTo:[NSString groupRime] overWrite:YES];
        if (res == NO) {
            NSLog(@"解压文件出错了");
            return;
        }
        
        self.zip.progressBlock = ^(int percentage, int filesProcessed, unsigned long numFiles){
            
            NSLog(@"per:%d  fpro:%d   num:%lu", percentage, filesProcessed, numFiles);
            
        };
        
        [self.zip UnzipCloseFile];
            
        
        complete();
    
    });
    
}


-(void)recoverSetting
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *err = nil;
    BOOL res = [fm removeItemAtPath:[NSString rimeResource] error:&err];
    
    if (res == NO) {
        NSLog(@"删除配置文件出错了%@", err);
    }
    
    
    [self initSettingFile];
}








@end
