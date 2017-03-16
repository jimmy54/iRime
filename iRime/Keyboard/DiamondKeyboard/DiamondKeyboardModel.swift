//
//  DiamondKeyboardModel.swift
//  iRime
//
//  Created by hanbing on 2017/3/15.
//  Copyright © 2017年 jimmy54. All rights reserved.
//

import Foundation

class DiamondKeyboardModel: NSObject {
    
    var defaultArray:NSArray?
    var letterArray:NSArray?
    var bottomArray:NSArray?
    
    override init() {
        super.init()
        self.configData()
    }
    
    func configData() {
        self.defaultArray = self.configDefaultDatasource()
        self.letterArray = self.configLetterDatasource()
        self.bottomArray = self.configBottomDatasource()
    }
    
    func configBottomDatasource() -> NSArray {
        let firstDatasource:NSMutableArray = NSMutableArray.init(capacity: 8)
        
        let key1:DiamondKey = DiamondKey.init(style: 0)
        key1.firstText = "符"
        firstDatasource.addObject(key1)
        
        let key2:DiamondKey = DiamondKey.init(style: 0)
        key2.firstText = "123"
        firstDatasource.addObject(key2)
        
        let key3:DiamondKey = DiamondKey.init(style: 1)
        key3.imageName = "空格"
        firstDatasource.addObject(key3)
        
        let key4:DiamondKey = DiamondKey.init(style: 3)
        key4.imageName = "图标"
        key4.text("中", secondText: "英")
        firstDatasource.addObject(key4)
        
        let key5:DiamondKey = DiamondKey.init(style: 0)
        key5.firstText = "换行"
        firstDatasource.addObject(key5)
        
        return NSArray.init(array: firstDatasource)
    }
    
    func configDefaultDatasource() -> NSArray {
        let firstDatasource:NSMutableArray = NSMutableArray.init(capacity: 8)
        
        let key1:DiamondKey = DiamondKey.init(style: 0)
        key1.firstText = "，"
        firstDatasource.addObject(key1)
        
        let key2:DiamondKey = DiamondKey.init(style: 0)
        key2.firstText = "。"
        firstDatasource.addObject(key2)
        
        let key3:DiamondKey = DiamondKey.init(style: 0)
        key3.firstText = "？"
        firstDatasource.addObject(key3)
        
        let key4:DiamondKey = DiamondKey.init(style: 0)
        key4.firstText = "！"
        firstDatasource.addObject(key4)
        
        let key5:DiamondKey = DiamondKey.init(style: 0)
        key5.firstText = "..."
        firstDatasource.addObject(key5)
        
        let key6:DiamondKey = DiamondKey.init(style: 0)
        key6.firstText = "~"
        firstDatasource.addObject(key6)
        
        let key7:DiamondKey = DiamondKey.init(style: 0)
        key7.firstText = "'"
        firstDatasource.addObject(key7)
        
        let key8:DiamondKey = DiamondKey.init(style: 0)
        key8.firstText = "、"
        firstDatasource.addObject(key8)
        
        return NSArray.init(array: firstDatasource)
    }
    func configLetterDatasource() -> NSArray{
        let firstDatasource:NSMutableArray = NSMutableArray.init(capacity: 12)
        
        let key1:DiamondKey = DiamondKey.init(style: 2)
        key1.text("1", secondText: "@/.")
        firstDatasource.addObject(key1)
        
        let key2:DiamondKey = DiamondKey.init(style: 2)
        key2.text("2", secondText: "ABC")
        firstDatasource.addObject(key2)
        
        let key3:DiamondKey = DiamondKey.init(style: 2)
        key3.text("3", secondText: "DEF")
        firstDatasource.addObject(key3)
        
        let key4:DiamondKey = DiamondKey.init(style: 1)
        key4.imageName = "删除"
        firstDatasource.addObject(key4)
        
        let key5:DiamondKey = DiamondKey.init(style: 2)
        key5.text("4", secondText: "GHI")
        firstDatasource.addObject(key5)
        
        let key6:DiamondKey = DiamondKey.init(style: 2)
        key6.text("5", secondText: "JKL")
        firstDatasource.addObject(key6)
        
        let key7:DiamondKey = DiamondKey.init(style: 2)
        key7.text("6", secondText: "MNO")
        firstDatasource.addObject(key7)
        
        let key8:DiamondKey = DiamondKey.init(style: 0)
        key8.firstText = "换行"
        firstDatasource.addObject(key8)
        
        let key9:DiamondKey = DiamondKey.init(style: 2)
        key9.text("7", secondText: "PQRS")
        firstDatasource.addObject(key9)
        
        let key10:DiamondKey = DiamondKey.init(style: 2)
        key10.text("8", secondText: "TUV")
        firstDatasource.addObject(key10)
        
        let key11:DiamondKey = DiamondKey.init(style: 2)
        key11.text("9", secondText: "WXYZ")
        firstDatasource.addObject(key11)
        
        let key12:DiamondKey = DiamondKey.init(style: 0)
        key12.firstText = "0"
        firstDatasource.addObject(key12)
        
        return NSArray.init(array: firstDatasource)
    }
}

class DiamondKey:NSObject {
    /**
     style 
     0 普通的显示文案
     1 显示单独的图片
     2 数字+字母
     3 图片+文案
 */
    var style:NSInteger?
    var firstText:NSString?
    var secondText:NSString?
    var imageName:NSString?
    var letterArray:NSArray?
    
    init(style:NSInteger) {
        super.init()
        self.style = style
    }
    
    func text(firstText:NSString,secondText:NSString) {
        self.firstText = firstText
        self.secondText = secondText
    }
}
