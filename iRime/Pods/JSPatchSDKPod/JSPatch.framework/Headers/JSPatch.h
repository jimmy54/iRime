//
//  JSPatch.h
//  JSPatch SDK version 1.6
//
//  Created by bang on 15/7/28.
//  Copyright (c) 2015 bang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JPCallbackType){
    JPCallbackTypeUnknow        = 0,
    JPCallbackTypeRunScript     = 1,    //执行脚本
    JPCallbackTypeUpdate        = 2,    //脚本有更新
    JPCallbackTypeUpdateDone    = 3,    //已拉取新脚本
    JPCallbackTypeCondition     = 4,    //条件下发
    JPCallbackTypeGray          = 5,    //灰度下发
    JPCallbackTypeUpdateFail    = 6,    //脚本拉取错误
};

@interface JSPatch : NSObject

#pragma mark - 主要API

/*
 传入在平台申请的 appKey。会自动执行已下载到本地的 patch 脚本。
 建议在 -application:didFinishLaunchingWithOptions: 开头处调用
 */
+ (void)startWithAppKey:(NSString *)aAppKey;

/*
 与 JSPatch 平台后台同步，发请求询问后台是否有 patch 更新，如果有更新会自动下载并执行
 可调用多次（App启动时调用或App唤醒时调）
 */
+ (void)sync;

/*
 用于发布前测试脚本。先把脚本放入项目中，调用后，会在当前项目的 bundle 里寻找 main.js 文件执行
 测试完成后请删除，改为调用 +startWithAppKey: 和 +sync
 */
+ (void)testScriptInBundle;


#pragma mark - 设置

/*
 自定义log，使用方法：
 [JSPatch setLogger:^(NSString *msg) {
    //msg 是 JSPatch log 字符串，用你自定义的logger打出
 }];
 在 `+startWithAppKey:` 之前调用
 */
+ (void)setupLogger:(void (^)(NSString *))logger;

/*
 定义用户属性
 用于条件下发，例如: 
    [JSPatch setupUserData:@{@"userId": @"100867", @"location": @"guangdong"}];
 详见在线文档
 在 `+sync:` 之前调用
 */
+ (void)setupUserData:(NSDictionary *)userData;


/*
 事件回调
   type: 事件类型，详见 JPCallbackType 定义
   data: 回调数据
   error: 事件错误
 在 `+startWithAppKey:` 之前调用
 */
+ (void)setupCallback:(void (^)(JPCallbackType type, NSDictionary *data, NSError *error))callback;

/*
 自定义RSA key
 publicKey: 平台上传脚本时 privateKey 对应的 publicKey
 在 `+sync:` 之前调用，详见 JSPatch 平台文档
 */
+ (void)setupRSAPublicKey:(NSString *)publicKey;


/*
 进入开发模式
 平台下发补丁时选择开发预览模式，会只对调用了这个方法的客户端生效。
 在 `+sync:` 之前调用，建议在 #ifdef DEBUG 里调。
 */
+ (void)setupDevelopment;


/*
 使用https请求
 速度会比不使用https慢。脚本内容已经经过多重加密，不使用https也不会有安全问题。
 在 `+sync:` 之前调用。
 */
+ (void)setupHttps;





#pragma mark - 在线参数
/***************** 在线参数 ******************/
/*
 请求在线参数
 */
+ (void)updateConfigWithAppKey:(NSString *)appKey;

/*
 获取已缓存在本地的所有在线参数
 */
+ (NSDictionary *)getConfigParams;

/*
 根据键值获取已缓存在本地的一个在线参数
 */
+ (NSString *)getConfigParam:(NSString *)key;

/*
 设置在线参数请求间隔
 默认请求间隔为30分钟，即30分钟内多次调用 +updateConfigWithAppKey: 接口只请求一次
 在 +updateConfigWithAppKey: 之前调用
 */
+ (void)setupConfigInterval:(NSTimeInterval)configInterval;

/*
 设置在线参数请求完成的回调
 */
+ (void)setupUpdatedConfigCallback:(void (^)(NSDictionary *configs, NSError *error))cb;
@end