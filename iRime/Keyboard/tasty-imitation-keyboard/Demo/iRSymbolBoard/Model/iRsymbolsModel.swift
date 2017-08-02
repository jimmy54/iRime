//
//  iRsymbolsModel.swift
//  iRime
//
//  Created by 王宇 on 2017/7/19.
//  Copyright © 2017年 jimmy54. All rights reserved.
//

import UIKit

//class iRsymbolStringModel: NSObject {
//    var stringContent:String?
//    var isCoupleString:Bool = false  //!<true == 成对的符号例如:(),此时光标应该自动回退
//    
//}

class iRsymbolsItemModel: NSObject {
    var name:String?
    var arraySymbols:[String]?
//    var arraySymbolModels:[iRsymbolStringModel]?
    var sizeOfItem:CGSize?
    //--控制字段
    var isSelected:Bool = false
    
    
}


class iRsymbolsModel: NSObject {
    var arrayModels:[iRsymbolsItemModel]?
    
    
}
