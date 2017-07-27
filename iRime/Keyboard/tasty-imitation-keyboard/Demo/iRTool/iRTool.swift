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


extension UIColor {
    //返回随机颜色
    open class var randomColor:UIColor{
        get
        {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    
    public convenience init(hexString: UInt32, alpha: CGFloat = 1.0) {
        let red     = CGFloat((hexString & 0xFF0000) >> 16) / 255.0
        let green   = CGFloat((hexString & 0x00FF00) >> 8 ) / 255.0
        let blue    = CGFloat((hexString & 0x0000FF)      ) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
/** RGB色值设置
 * parameter r: 红色色值
 * parameter g: 绿色色值
 * parameter b: 蓝色色值
 * parameter a: 透明度
 */
func RGB (r:CGFloat,
          g:CGFloat,
          b:CGFloat
          ) -> UIColor
{
    return UIColor (red: r/225.0, green: g/225.0, blue: b/225.0, alpha: 1)
}

func RGBA (r:CGFloat,
          g:CGFloat,
          b:CGFloat,
          alpha:CGFloat
    ) -> UIColor
{
    return UIColor (red: r/225.0, green: g/225.0, blue: b/225.0, alpha: alpha)
}


func onePixel() -> CGFloat {
    return 1/UIScreen.main.scale
}

/** 判断字符串是否为空 */
func isEmptyStringIR(string: String) -> Bool {
    if string.isEmpty || string == "" {
        return true
    }else {
        return false
    }
}
/** 屏幕的宽 */
func screenWidthIR() -> CGFloat {
    // swift 2.3
    //    return UIScreen.mainScreen().bounds.width
    // swift 3.0
    return UIScreen.main.bounds.width
}

/** 屏幕的高 */
func screenHeightIR() -> CGFloat {
    // swift 2.3
    //    return UIScreen.mainScreen().bounds.height
    // swift 3.0
    return UIScreen.main.bounds.height
}






