//
//  iRSymbolBoardContentView.swift
//  iRime
//
//  Created by 王宇 on 2017/7/18.
//  Copyright © 2017年 jimmy54. All rights reserved.
//  符号键盘最底层的容器view

import UIKit

let arrayCoupleSymbols:[String] = [ "“”","（）", "《》","〈〉","［］","｛｝","【】","〖〗","〔〕", "『』","「」","()","<>","{}","[]"];



@objc protocol iRSymbolBoardContentViewProtocol:NSObjectProtocol {
    
    func presentTextFromSymbolBoard(_ text:String) -> Void
    func deleteBackwardOfiRSymbolBoardContentView() -> Void
}



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
    weak var delegateAction:iRSymbolBoardContentViewProtocol?
        {
            didSet
                {
                   viewRight.delegateAction = delegateAction
                   viewBottom.delegateCallBack = delegateAction as? iRSymbolBoardBottomControlViewProtocol
                }
        }
    
    
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
       
        //MARK:1.常用符号
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
        //MARK:2.中文文符号
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
        //MARK:3.英文文符号
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
        
        //MARK:4.网址符号
        let modelSymbol_wangzhi:iRsymbolsItemModel = iRsymbolsItemModel()
        modelMain.arrayModels?.append(modelSymbol_wangzhi)
        modelSymbol_wangzhi.name = "网址"
        modelSymbol_wangzhi.sizeOfItem = self.sizeOfItemLong
        modelSymbol_wangzhi.arraySymbols = [
            ".",
            ":",
            "/",
            "@",
            "-",
            "_",
            "www.",
            "wap.",
            ".com",
            ".cn.",
            "com.cn",
            ".net",
            ".org",
            ".edu",
            ".cn",
            "bbs.",
            "news.",
            "blog.",
            "http://",
            "https://",
            "ftp://",
            "3g.",
            "sports.",
            "baidu.com",
            "google.com.hk",
            "sina.com.cn",
            "weibo.com",
            "tianya.cn",
            "tieba.com",
            "taobao.com",
            "tmall.com",
            "mop.com",
            "sohu.com"
        ]
        //MARK:5.邮箱符号
        let modelSymbol_youxiang:iRsymbolsItemModel = iRsymbolsItemModel()
        modelMain.arrayModels?.append(modelSymbol_youxiang)
        modelSymbol_youxiang.name = "邮箱"
        modelSymbol_youxiang.sizeOfItem = self.sizeOfItemLong
        modelSymbol_youxiang.arraySymbols = [
            "@",
            ".",
            "-",
            "_",
            "@qq.com",
            "@126.com",
            "@163.com",
            "@139.com",
            "@gmail.com",
            "@hotmail.com",
            "@sohu.com",
            "@sina.com",
            "@sina.cn",
            "@yeah.net",
            "@live.cn",
            "@msn.com",
            "@yahoo.com.cn",
            "@foxmail.com",
            "@188.com",
            "@189.cn",
            "@2980.com",
            "@tom.com",
            "@aliyun.com",
            "@outlook.com"
        ]
        //MARK:6.数学符号
        let modelSymbol_shuxue:iRsymbolsItemModel = iRsymbolsItemModel()
        modelMain.arrayModels?.append(modelSymbol_shuxue)
        modelSymbol_shuxue.name = "数学"
        modelSymbol_shuxue.sizeOfItem = self.sizeOfItemNormal
        modelSymbol_shuxue.arraySymbols = [
            "=",
            "≠",
            "≈",
            "±",
            "+",
            "－",
            "×",
            "÷",
            ">",
            "<",
            "≥",
            "≤",
            "/",
            "√",
            "%",
            "‰",
            "π",
            "³√",
            "℃",
            "℉",
            "㎎",
            "㎏",
            "㎜",
            "㎝",
            "㎞",
            "㎡",
            "m³",
            "㏄",
            "°",
            "¹",
            "²",
            "³",
            "ⁿ",
            "′",
            "〃",
            "∞",
            "㏒",
            "㏑",
            "㏕",
            "∑",
            "∈",
            "≡",
            "⊥",
            "∏",
            "↔",
            ":",
            "=",
            "¬",
            "⊕",
            "￠",
            "Ψ",
            "f'",
            "∥",
            "≮",
            "≯",
            "∝",
            "∠",
            "∽",
            "≌",
            "∵",
            "∴",
            "∫",
            "∮",
            "∶",
            "∷",
            "∧",
            "∨",
            "∩",
            "∪",
            "⌒",
            "⊿",
            "△",
            "Δ",
            "½",
            "⅓",
            "¼",
            "⅛",
            "¾",
            "⅜",
            "℅",
            "≒",
            "()",
            "{}",
            "[]",
            "||",
            "sin",
            "cos",
            "tan",
            "cot",
            "⊂",
            "⊃",
            "⊆",
            "⊇",
            "∃",
            "∃!",
            "∅",
            "∉",
            "⇒",
            "⇔",
            "∂",
            "∀",
            "sec",
            "csc",
            "arc",
            "sin",
            "arc",
            "cos",
            "arc",
            "tan",
            "arc",
            "cot"
        ]
        //MARK:7.特殊符号
        let modelSymbol_teshu:iRsymbolsItemModel = iRsymbolsItemModel()
        modelMain.arrayModels?.append(modelSymbol_teshu)
        modelSymbol_teshu.name = "特殊"
        modelSymbol_teshu.sizeOfItem = self.sizeOfItemNormal
        modelSymbol_teshu.arraySymbols = [
            "♞",
            "♟",
            "↣",
            "♚",
            "♛",
            "♝",
            "✘",
            "✔",
            "♤",
            "♧",
            "♡",
            "♢",
            "♩",
            "♪",
            "♫",
            "♬",
            "¶",
            "‖",
            "♯",
            "♭",
            "★",
            "☆",
            "■",
            "□",
            "●",
            "○",
            "♀",
            "♂",
            "↓",
            "↑",
            "←",
            "→",
            "↖",
            "↗",
            "↙",
            "↘",
            "△",
            "▲",
            "◇",
            "◆",
            "▽",
            "▼",
            "※",
            "§",
            "ᝰ",
            "ᨐ",
            "꧁",
            "꧂",
            "◎",
            "⊙",
            "㊣",
            "⊕",
            "®",
            "©",
            "№",
            "℡",
            "↕",
            "↔",
            "卍",
            "™",
            "♥",
            "♠",
            "♣",
            "♦",
            "㈱",
            "囍",
            "卐",
            "◈",
            "◢",
            "◣",
            "◤",
            "◥",
            "«",
            "»",
            "︽",
            "︾",
            "☜",
            "☞",
            "▓",
            "♪",
            "⇔",
            "/",
            "╳",
            "＾",
            "ˇ",
            "︵",
            "╭",
            "╮",
            "⌒",
            "︶",
            "╰",
            "╯",
            "︹",
            "︺",
            "︿",
            "﹀",
            "﹁",
            "﹂",
            "﹃",
            "﹄",
            "︻",
            "︼",
            "︷",
            "︸",
            "﹏",
            "―",
            "￣",
            "︴",
            "﹌",
            "﹉",
            "﹊",
            "﹍",
            "﹎",
            "Š",
            "Õ",
            "‡",
            "†",
            "〓",
            "¤",
            "Ψ",
            "∮",
            "￡",
            "↹",
            "Θ",
            "€",
            "‥",
            "✎",
            "✐",
            "✁",
            "✄",
            "➴",
            "➵",
            "۞",
            "۩",
            "❀",
            "❂",
            "❦",
            "❧",
            "✲",
            "❈",
            "v❉",
            "✪",
            "✍",
            "๑",
            "¶",
            "✙"
        ]
        //MARK:8.序号符号
        let modelSymbol_xuhao:iRsymbolsItemModel = iRsymbolsItemModel()
        modelMain.arrayModels?.append(modelSymbol_xuhao)
        modelSymbol_xuhao.name = "序号"
        modelSymbol_xuhao.sizeOfItem = self.sizeOfItemNormal
        modelSymbol_xuhao.arraySymbols = [
            "①",
            "②",
            "③",
            "④",
            "⑤",
            "⑥",
            "⑦",
            "⑧",
            "⑨",
            "⑩",
            "❶",
            "❷",
            "❸",
            "❹",
            "❺",
            "❻",
            "❼",
            "❽",
            "❾",
            "❿",
            "Ⅰ",
            "Ⅱ",
            "Ⅲ",
            "Ⅳ",
            "Ⅴ",
            "Ⅵ",
            "Ⅶ",
            "Ⅷ",
            "Ⅸ",
            "Ⅹ",
            "⒈",
            "⒉",
            "⒊",
            "⒋",
            "⒌",
            "⒍",
            "⒎",
            "⒏",
            "⒐",
            "⒑",
            "０",
            "１",
            "２",
            "３",
            "４",
            "５",
            "６",
            "７",
            "８",
            "９",
            "㈠",
            "㈡",
            "㈢",
            "㈣",
            "㈤",
            "㈥",
            "㈦",
            "㈧",
            "㈨",
            "㈩",
            "⑴",
            "⑵",
            "⑶",
            "⑷",
            "⑸",
            "⑹",
            "⑺",
            "⑻",
            "⑼",
            "⑽",
            "壹",
            "贰",
            "叁",
            "肆",
            "伍",
            "陆",
            "柒",
            "捌",
            "玖",
            "拾",
            "佰",
            "仟",
            "萬",
            "億"
        ]

        print(modelMain)
    }
   

    
}










































