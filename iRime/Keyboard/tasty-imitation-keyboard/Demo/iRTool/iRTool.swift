//
//  iRTool.swift
//  iRime
//
//  Created by 王宇 on 2017/7/18.
//  Copyright © 2017年 jimmy54. All rights reserved.
//

import Foundation
//封装的日志输出功能（T表示不指定日志信息参数类型）
func logIrime<T>(_ message:T, file:String = #file, function:String = #function,line:Int = #line)
{
    #if DEBUG 
        //获取文件名
        let fileName = (file as NSString).lastPathComponent
        //打印日志内容
        print("\(fileName):\(line) \(function) | \(message)")
    #endif
}


//class iRTool: NSObject {
//   
//}
