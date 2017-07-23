//
//  iRsymbolsModel.swift
//  iRime
//
//  Created by 王宇 on 2017/7/19.
//  Copyright © 2017年 jimmy54. All rights reserved.
//

import UIKit

class iRsymbolsItemModel: NSObject {
    var name:String?
    var arraySymbols:[String]?
    
    //--控制字段
    var isSelected:Bool = false
    
    
}


class iRsymbolsModel: NSObject {
    var arrayModels:[iRsymbolsItemModel]?
    
}
