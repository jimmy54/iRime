//
//  OpenCCService.h
//  OpenCC
//
//  Created by gelosie on 12/4/15.
//

#import <Foundation/Foundation.h>

//s2t.json Simplified Chinese to Traditional Chinese 簡體到繁體
//t2s.json Traditional Chinese to Simplified Chinese 繁體到簡體
//s2tw.json Simplified Chinese to Traditional Chinese (Taiwan Standard) 簡體到臺灣正體
//tw2s.json Traditional Chinese (Taiwan Standard) to Simplified Chinese 臺灣正體到簡體
//s2hk.json Simplified Chinese to Traditional Chinese (Hong Kong Standard) 簡體到香港繁體（香港小學學習字詞表標準）
//hk2s.json Traditional Chinese (Hong Kong Standard) to Simplified Chinese 香港繁體（香港小學學習字詞表標準）到簡體
//s2twp.json Simplified Chinese to Traditional Chinese (Taiwan Standard) with Taiwanese idiom 簡體到繁體（臺灣正體標準）並轉換爲臺灣常用詞彙
//tw2sp.json Traditional Chinese (Taiwan Standard) to Simplified Chinese with Mainland Chinese idiom 繁體（臺灣正體標準）到簡體並轉換爲中國大陸常用詞彙
//t2hk.json Traditional Chinese to Traditional Chinese (Hong Kong Standard) 繁體到香港繁體（香港小學學習字詞表標準）
//t2tw.json Traditional Chinese to Traditional Chinese (Taiwan Standard) 繁體臺灣正體

typedef NS_ENUM (NSUInteger, OpenCCServiceConverterType) {
    OpenCCServiceConverterTypeNone = 0,
    OpenCCServiceConverterTypeS2T = 1,
    OpenCCServiceConverterTypeT2S = 2,
    OpenCCServiceConverterTypeS2TW = 3,
    OpenCCServiceConverterTypeTW2S = 4,
    OpenCCServiceConverterTypeS2HK = 5,
    OpenCCServiceConverterTypeHK2S = 6,
    OpenCCServiceConverterTypeS2TWP = 7,
    OpenCCServiceConverterTypeTW2SP = 8,
    OpenCCServiceConverterTypeT2HK = 9,
    OpenCCServiceConverterTypeT2TW = 10,
};

@interface OpenCCService : NSObject
-(instancetype)initWithConverterType:(OpenCCServiceConverterType)converterType;
- (NSString *)convert:(NSString *)str;
@end
