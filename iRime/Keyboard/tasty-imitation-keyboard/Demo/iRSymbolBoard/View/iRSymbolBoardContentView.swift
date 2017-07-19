//
//  iRSymbolBoardContentView.swift
//  iRime
//
//  Created by 王宇 on 2017/7/18.
//  Copyright © 2017年 jimmy54. All rights reserved.
//  符号键盘最底层的容器view

import UIKit

class iRSymbolBoardContentView: UIView {
    
    func getNeedData() -> Void {
//        let path = Bundle.main.path(forResource: "iRimeSymbols", ofType: "json")
//        let url:URL = URL(fileURLWithPath: path!)
//        var modelSymbol:iRsymbolsModel?
//        do{
//            
//            let data = try Data(contentsOf: url)
//            
//            let json:Any = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers)
//            
//            let jsonDic = json as!Dictionary<String,Any>
//            
//            let dictData =  jsonDic["arrayNeed"]
//            
//            modelSymbol = iRsymbolsModel.mj_object(withKeyValues: dictData)
//            
//            print(modelSymbol?.arrayModels! as Any)//输出数据
//            
//        }catch let erro as Error!{
//            
//            print("读取本地数据出现错误！",erro)
//            
//        }
        
       
        
    }
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
        getNeedData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
