//
//  iRSymbolBoardContentView.swift
//  iRime
//
//  Created by 王宇 on 2017/7/18.
//  Copyright © 2017年 jimmy54. All rights reserved.
//  符号键盘最底层的容器view

import UIKit

let arrayCoupleSymbols:[String] = [ "“”","（）", "《》","〈〉","［］","｛｝","【】","〖〗","〔〕", "『』","「」","()","<>","{}","[]"];

extension String {
    
    func ifCoupleSymbols() -> Bool {
        
        if arrayCoupleSymbols.contains(self)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    var isCouple:Bool  { return self.ifCoupleSymbols() }
}



class iRSymbolBoardContentView: UIView,iRSymbolBoardLeftControlViewProtocol {
    
    static var width_iRSymbolBoardLeftControlView:CGFloat = 70
    static var height_line_iRSymbolBoardLeftControlView:CGFloat = 45
    var sizeOfItemNormal:CGSize = {
        let width = (screenWidthIR()-iRSymbolBoardContentView.width_iRSymbolBoardLeftControlView)*0.2
        
        return CGSize.init(width: width, height: iRSymbolBoardContentView.height_line_iRSymbolBoardLeftControlView)
        
    }()
    var sizeOfItemLong:CGSize = {
        let width = (screenWidthIR()-iRSymbolBoardContentView.width_iRSymbolBoardLeftControlView)*0.5
        
        return CGSize.init(width: width, height: iRSymbolBoardContentView.height_line_iRSymbolBoardLeftControlView-onePixel())
        
    }()
    
    
    var modelMain:iRsymbolsModel = iRsymbolsModel()
    lazy var viewLeft:iRSymbolBoardLeftControlView = { () -> iRSymbolBoardLeftControlView in
        let viewLeft:iRSymbolBoardLeftControlView = iRSymbolBoardLeftControlView.init(frame: CGRect.null)
        viewLeft.delegateCallBack = self
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
            make.width.mas_equalTo()(iRSymbolBoardContentView.width_iRSymbolBoardLeftControlView)
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
        
        viewRight.modelSymbolItem = modelMain.arrayModels?.first
        viewRight.collectionView.reloadData()
    }
    
    //MARK:代理回调
    func didSelectedOneCell(modelSelected:iRsymbolsItemModel,indexPath:NSIndexPath) -> Void
    {
        viewRight.modelSymbolItem = modelMain.arrayModels?[indexPath.row]
        viewRight.collectionView.reloadData()
        viewRight.collectionView.contentOffset = CGPoint.zero
    }
    func getNeedData() -> Void {
        modelMain.arrayModels = Array()
       
        //1.常用符号
        let modelSymbol_changyong:iRsymbolsItemModel = iRsymbolsItemModel()
        modelMain.arrayModels?.append(modelSymbol_changyong)
        modelSymbol_changyong.name = "常用"
        modelSymbol_changyong.isSelected = true
        modelSymbol_changyong.sizeOfItem = self.sizeOfItemNormal
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
        //2.中文文符号
        let modelSymbol_zhongwen:iRsymbolsItemModel = iRsymbolsItemModel()
        modelMain.arrayModels?.append(modelSymbol_zhongwen)
        modelSymbol_zhongwen.name = "中文"
        modelSymbol_zhongwen.sizeOfItem = self.sizeOfItemNormal
        modelSymbol_zhongwen.arraySymbols = [
            "，",
            "。",
            "？",
            "！",
            "：",
            "；",
            "……",
            "～",
            "“”",
            "“",
            "”",
            "、",
            "（）",
            "（",
            "）",
            "——",
            "‘’",
            "‘",
            "’",
            "·",
            "＠",
            "＆",
            "＊",
            "＃",
            "《》",
            "〈〉",
            "＄",
            "￥",
            "［］",
            "［",
            "］",
            "￡",
            "｛｝",
            "｛",
            "｝",
            "￠",
            "【】",
            "【",
            "】",
            "％",
            "〖〗",
            "〖",
            "〗",
            "／",
            "〔〕",
            "〔",
            "〕",
            "＼",
            "『』",
            "『",
            "』",
            "＾",
            "「」",
            "「",
            "」",
           " ．",
            "﹁",
            "﹂",
            "｀",
            "．"
        ]
        //3.英文文符号
        let modelSymbol_yingwen:iRsymbolsItemModel = iRsymbolsItemModel()
        modelMain.arrayModels?.append(modelSymbol_yingwen)
        modelSymbol_yingwen.name = "英文"
        modelSymbol_yingwen.sizeOfItem = self.sizeOfItemNormal
        modelSymbol_yingwen.arraySymbols = [
            ",",
            ".",
            "?",
            "!",
            ":",
            ";",
            "…",
            "~",
            "_",
            "-",
            "\"\"",
            "'",
            "/",
            "@",
            "*",
            "+",
            "()",
            "<>",
            "{}",
            "[]",
            "=",
            "%",
            "&",
            "$",
            "|",
            "\\",
            "♀",
            "♂",
            "#",
            "¥",
            "£",
            "¢",
            "€",
            "\"",
            "^",
            "`"
        ]
        
        print(modelMain)
    }
   

    
}










































