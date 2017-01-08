//
//  OpenCCService.m
//  OpenCC
//
//  Created by gelosie on 12/4/15.
//

#define OPENCC_EXPORT 

#import "OpenCCService.h"
#import <string>
#import "SimpleConverter.hpp"
#import "NSString+Path.h"

class SimpleConverter;

@interface OpenCCService (){
    @private opencc::SimpleConverter *simpleConverter;
}

@end

@implementation OpenCCService

-(instancetype)initWithConverterType:(OpenCCServiceConverterType)converterType{
    self = [super init];
    if(self){
        NSString *json = @"s2t.json";
        switch (converterType) {
            case OpenCCServiceConverterTypeS2T:
                json=@"s2t.json";
                break;
            case OpenCCServiceConverterTypeT2S:
                json=@"t2s.json";
                break;
            case OpenCCServiceConverterTypeS2TW:
                json=@"s2tw.json";
                break;
            case OpenCCServiceConverterTypeTW2S:
                json=@"tw2s.json";
                break;
            case OpenCCServiceConverterTypeS2HK:
                json=@"s2hk.json";
                break;
            case OpenCCServiceConverterTypeHK2S:
                json=@"hk2s.json";
                break;
            case OpenCCServiceConverterTypeS2TWP:
                json=@"s2twp.json";
                break;
            case OpenCCServiceConverterTypeTW2SP:
                json=@"tw2sp.json";
                break;
            case OpenCCServiceConverterTypeT2HK:
                json=@"t2hk.json";
                break;
            case OpenCCServiceConverterTypeT2TW:
                json=@"t2tw.json";
                break;
                
            default:json = @"s2t.json";break;
        }
        
//        NSString *config = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:json];
        NSString *config = [NSString appendingHostAppBundlePath:json];
        const std::string *c = new std::string([config UTF8String]);
        simpleConverter = new opencc::SimpleConverter(*c);
        delete c;
    }
    return self;
}

- (NSString *)convert:(NSString *)str {
    std::string st = simpleConverter->Convert([str UTF8String]);
    return [NSString stringWithCString:st.c_str() encoding:NSUTF8StringEncoding];
}

-(void)dealloc {
    delete simpleConverter;
}

@end
