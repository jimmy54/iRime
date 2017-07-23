//
//  iRSymbolBoardContentView.swift
//  iRime
//
//  Created by 王宇 on 2017/7/18.
//  Copyright © 2017年 jimmy54. All rights reserved.
//  符号键盘最底层的容器view

import UIKit

class iRSymbolBoardContentView: UIView {
    
    var modelMain:iRsymbolsModel = iRsymbolsModel()
    lazy var viewLeft:iRSymbolBoardLeftControlView = { () -> iRSymbolBoardLeftControlView in
        let viewLeft:iRSymbolBoardLeftControlView = iRSymbolBoardLeftControlView.init(frame: CGRect.null)
        
        return viewLeft
    }()
    
    lazy var viewRight:iRSymbolBoardRightWordsView = { () -> iRSymbolBoardRightWordsView in
        let viewRight:iRSymbolBoardRightWordsView = iRSymbolBoardRightWordsView.init(frame:CGRect.null)
        
        return viewRight
        
    }()
    
    lazy var viewBottom:iRSymbolBoardBottomControlView = { () -> iRSymbolBoardBottomControlView in
        let viewBottom:iRSymbolBoardBottomControlView = iRSymbolBoardBottomControlView.init(frame:CGRect.null)
        return viewBottom
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubViews()
        getNeedData()
        configData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubViews() -> Void {
        //1.底部侧控制条view
        self.addSubview(viewBottom)
        //--约束布局
        viewBottom.mas_makeConstraints { (maker:MASConstraintMaker!) in
            maker.bottom.equalTo()(self)
            maker.left.equalTo()(self)
            maker.right.equalTo()(self)
            maker.height.mas_equalTo()(45)
        }
        //2.左侧控制条view
        self.addSubview(viewLeft)
        //--约束布局
        viewLeft.mas_makeConstraints { (make:MASConstraintMaker!) in
            make.left.top().equalTo()(self);
            make.bottom.equalTo()(self.viewBottom.mas_top)
            make.width.mas_equalTo()(70)
        }
        //3.右侧容器view
        self.addSubview(viewRight)
        //--约束布局
        viewRight.mas_makeConstraints { (make:MASConstraintMaker!) in
            make.left.equalTo()(self.viewLeft.mas_right)
            make.bottom.equalTo()(self.viewBottom.mas_top)
            make.top.right().equalTo()(self)  
        }
    }
    
    func configData() -> Void {
        viewLeft.modelMain = modelMain
        viewLeft.tableView.reloadData()
    }
    
    
    func getNeedData() -> Void {
        //1.常用符号
        let modelSymbol_changyong:iRsymbolsItemModel = iRsymbolsItemModel()
        modelSymbol_changyong.name = "常用"
        modelSymbol_changyong.arraySymbols = [
            "，",
            "。",
            "？",
            "！",
            ".",
            "@",
            "、",
            "~",
            "……",
            "：",
            "-",
            "+",
            "_",
            "*",
            "』",
            "#",
            "www.",
            "…",
            ".com",
            "〔",
            ";",
            "/",
            "=",
            "$",
            "%",
            "（",
            "￥",
            "&",
            "┅",
            "＾",
            "『",
            "）"
        ]
        modelMain.arrayModels = Array()
        modelMain.arrayModels?.append(modelSymbol_changyong)
        
        print(modelMain)
    }
   

    
}










































