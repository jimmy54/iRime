//
//  iRSymbolBoardContentView.swift
//  iRime
//
//  Created by 王宇 on 2017/7/18.
//  Copyright © 2017年 jimmy54. All rights reserved.
//  符号键盘最底层的容器view

import UIKit

let arrayCoupleSymbols:[String] = ["\"\"","“”","''","‘’","（）", "《》","〈〉","［］","｛｝","【】","〖〗","〔〕", "『』","「」","()","<>","{}","[]"];

let identifyLock_iRSymbolBoard = "identifyLock_iRSymbolBoard"


@objc protocol iRSymbolBoardContentViewProtocol:NSObjectProtocol {
    
    func presentTextFromSymbolBoard(_ text:String) -> Void
    func deleteBackwardOfiRSymbolBoardContentView() -> Void
    func tapToCheckIfNeedToHideSymbolBoard() -> Void  //--点击一次输入以后监测是否需要隐藏键盘,如果未加锁,那么关闭键盘
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
    
    deinit
    {
       NotificationCenter.default.removeObserver(self)
    }
    
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
        configNotification()
        configIndetify()
        createSubViews()
        getNeedData()
        configData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configNotification() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationChanged(notify:)), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
    }
    
    func orientationChanged(notify: NSNotification) {
        for model:iRsymbolsItemModel in modelMain.arrayModels!
        {
            if model.name == "网址"||model.name == "邮箱" {
                model.sizeOfItem = {
                    let width = (screenWidthIR()-iRSymbolBoardContentView.width_iRSymbolBoardLeftControlView)*0.5
                    
                    return CGSize.init(width: width, height: iRSymbolBoardContentView.height_line_iRSymbolBoardLeftControlView-onePixel())
                    
                }()
            }
            else
            {
                model.sizeOfItem = {
                    let width = (screenWidthIR()-iRSymbolBoardContentView.width_iRSymbolBoardLeftControlView)*0.2
                    
                    return CGSize.init(width: width, height: iRSymbolBoardContentView.height_line_iRSymbolBoardLeftControlView)
                    
                }()
            }
            
            
        }
        viewRight.collectionView.reloadData()
    }
    
    func configIndetify() -> Void {
        //TODO:初始化标识符,如果==0 锁是开启状态,为1是锁住状态
        if UserDefaults.standard.value(forKey: identifyLock_iRSymbolBoard) == nil{
            UserDefaults.standard.set("0", forKey: identifyLock_iRSymbolBoard)
            UserDefaults.standard.synchronize()
        }
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
        //MARK:2.中文符号
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
        //MARK:3.英文符号
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
        //MARK:9.希俄符号
        let modelSymbol_xie:iRsymbolsItemModel = iRsymbolsItemModel()
        modelMain.arrayModels?.append(modelSymbol_xie)
        modelSymbol_xie.name = "希俄"
        modelSymbol_xie.sizeOfItem = self.sizeOfItemNormal
        modelSymbol_xie.arraySymbols = [
            "α",
            "β",
            "γ",
            "δ",
            "ε",
            "ζ",
            "η",
            "θ",
            "ι",
            "κ",
            "λ",
            "μ",
            "ν",
            "ξ",
            "ο",
            "π",
            "ρ",
            "σ",
            "τ",
            "υ",
            "φ",
            "χ",
            "ψ",
            "ω",
            "Α",
            "Β",
            "Γ",
            "Δ",
            "Ε",
            "Ζ",
            "Η",
            "Θ",
            "Ι",
            "Κ",
            "Λ",
            "Μ",
            "Ν",
            "Ξ",
            "Ο",
            "Π",
            "Ρ",
            "Σ",
            "Τ",
            "Υ",
            "Φ",
            "Χ",
            "Ψ",
            "Ω",
            "а",
            "б",
            "в",
            "г",
            "д",
            "е",
            "ё",
            "ж",
            "з",
            "и",
            "й",
            "к",
            "л",
            "м",
            "н",
            "о",
            "п",
            "р",
            "с",
            "т",
            "у",
            "ф",
            "х",
            "ц",
            "ч",
            "ш",
            "щ",
            "ъ",
            "ы",
            "ь",
            "э",
            "ю",
            "я",
            "А",
            "Б",
            "В",
            "Г",
            "Д",
            "Е",
            "Ё",
            "Ж",
            "З",
            "И",
            "Й",
            "К",
            "Л",
            "М",
            "Н",
            "О",
            "П",
            "Р",
            "С",
            "Т",
            "У",
            "Ф",
            "Х",
            "Ц",
            "Ч",
            "Ш",
            "Щ",
            "Ъ",
            "Ы",
            "Ь",
            "Э",
            "Ю",
            "Я"
            ]
        //MARK:10.音标符号
        let modelSymbol_yinbiao:iRsymbolsItemModel = iRsymbolsItemModel()
        modelMain.arrayModels?.append(modelSymbol_yinbiao)
        modelSymbol_yinbiao.name = "音标"
        modelSymbol_yinbiao.sizeOfItem = self.sizeOfItemNormal
        modelSymbol_yinbiao.arraySymbols = [
            "i:",
            "ɜ:",
            "ɑ:",
            "ɔ:",
            "u:",
            "ɪ",
            "e",
            "æ",
            "ʌ",
            "ɒ",
            "ʊ",
            "ə",
            "e",
            "ɪ",
            "a",
            "ɪ",
            "ɔ",
            "ɪ",
            "ə",
            "ʊ",
            "a",
            "ʊ",
            "ɪ",
            "ə",
            "e",
            "ə",
            "ʊ",
            "ə",
            "p",
            "t",
            "k",
            "f",
            "θ",
            "s",
            "ʃ",
            "h",
            "t",
            "ʃ",
            "t",
            "s",
            "t",
            "r",
            "b",
            "d",
            "g",
            "v",
            "ð",
            "z",
            "ʒ",
            "r",
            "d",
            "ʒ",
            "d",
            "z",
            "d",
            "r",
            "j",
            "w",
            "m",
            "n",
            "ŋ",
            "l"
            ]
        //MARK:11.拼音符号
        let modelSymbol_pinyin:iRsymbolsItemModel = iRsymbolsItemModel()
        modelMain.arrayModels?.append(modelSymbol_pinyin)
        modelSymbol_pinyin.name = "拼音"
        modelSymbol_pinyin.sizeOfItem = self.sizeOfItemNormal
        modelSymbol_pinyin.arraySymbols = [
            "ā",
            "á",
            "ǎ",
            "à",
            "ō",
            "ó",
            "ǒ",
            "ò",
            "ē",
            "é",
            "ě",
            "è",
            "ī",
            "í",
            "ǐ",
            "ì",
            "ū",
            "ú",
            "ǔ",
            "ù",
            "ǖ",
            "ǘ",
            "ǚ",
            "ǜ",
            "ü",
            "ê",
            "ɑ",
            "ń",
            "ň",
            "ɡ"
            ]
        //MARK:12.注音符号
        let modelSymbol_zhuyin:iRsymbolsItemModel = iRsymbolsItemModel()
        modelMain.arrayModels?.append(modelSymbol_zhuyin)
        modelSymbol_zhuyin.name = "注音"
        modelSymbol_zhuyin.sizeOfItem = self.sizeOfItemNormal
        modelSymbol_zhuyin.arraySymbols = [
            "ㄅ",
            "ㄆ",
            "ㄇ",
            "ㄈ",
            "ㄉ",
            "ㄊ",
            "ㄋ",
            "ㄌ",
            "ㄍ",
            "ㄎ",
            "ㄏ",
            "ㄐ",
            "ㄑ",
            "ㄒ",
            "ㄓ",
            "ㄔ",
            "ㄕ",
            "ㄖ",
            "ㄗ",
            "ㄘ",
            "ㄙ",
            "ㄚ",
            "ㄛ",
            "ㄜ",
            "ㄝ",
            "ㄞ",
            "ㄟ",
            "ㄠ",
            "ㄡ",
            "ㄢ",
            "ㄣ",
            "ㄤ",
            "ㄥ",
            "ㄦ",
            "ㄧ",
            "丨",
            "ㄨ",
            "ㄩ"
        ]
        //MARK:13.部首符号
        let modelSymbol_bushou:iRsymbolsItemModel = iRsymbolsItemModel()
        modelMain.arrayModels?.append(modelSymbol_bushou)
        modelSymbol_bushou.name = "部首"
        modelSymbol_bushou.sizeOfItem = self.sizeOfItemNormal
        modelSymbol_bushou.arraySymbols = [
            "一",
            "丨",
            "丿",
            "丶",
            "乛",
            "乚",
            "匚",
            "刂",
            "冂",
            "亻",
            "丷",
            "勹",
            "亠",
            "冫",
            "冖",
            "讠",
            "卩",
            "阝",
            "凵",
            "厶",
            "廴",
            "扌",
            "艹",
            "廾",
            "尢",
            "囗",
            "彳",
            "彡",
            "犭",
            "夂",
            "饣",
            "忄",
            "氵",
            "宀",
            "辶",
            "彐",
            "彑",
            "巳",
            "孑",
            "屮",
            "纟",
            "幺",
            "巛",
            "攴",
            "牜",
            "攵",
            "爫",
            "殳",
            "灬",
            "礻",
            "肀",
            "爿",
            "氺",
            "罒",
            "钅",
            "疒",
            "衤",
            "疋",
            "癶",
            "耒",
            "虍",
            "糸",
            "豸",
            "隹"
            ]
        //MARK:14.竖标符号
        let modelSymbol_shubiao:iRsymbolsItemModel = iRsymbolsItemModel()
        modelMain.arrayModels?.append(modelSymbol_shubiao)
        modelSymbol_shubiao.name = "竖标"
        modelSymbol_shubiao.sizeOfItem = self.sizeOfItemNormal
        modelSymbol_shubiao.arraySymbols = [
            "︐",
            "︑",
            "︒",
            "︓",
            "︔",
            "︕",
            "︖",
            "︗",
            "︘",
            "︙"
        ]
        //MARK:15.标记符号
        let modelSymbol_biaoji:iRsymbolsItemModel = iRsymbolsItemModel()
        modelMain.arrayModels?.append(modelSymbol_biaoji)
        modelSymbol_biaoji.name = "标记"
        modelSymbol_biaoji.sizeOfItem = self.sizeOfItemNormal
        modelSymbol_biaoji.arraySymbols = [
            "º",
            "⁰",
            "¹",
            "²",
            "³",
            "⁴",
            "⁵",
            "⁶",
            "⁷",
            "⁸",
            "⁹",
            "ⁱ",
            "⁺",
            "⁻",
            "⁼",
            "⁽",
            "⁾",
            "ⁿ",
            "₀",
            "₁",
            "₂",
            "₃",
            "₄",
            "₅",
            "₆",
            "₇",
            "₈",
            "₉",
            "₊",
            "₋",
            "₌",
            "₍",
            "₎",
            "ₐ",
            "ₑ",
            "ₒ",
            "ₓ",
            "ₔ",
            "ᴬ",
            "ᴮ",
            "ᶜ",
            "ᴰ",
            "ᴱ",
            "ᶠ",
            "ᴳ",
            "ᴴ",
            "ᴵ",
            "ᴶ",
            "ᴷ",
            "ᴸ",
            "ᴹ",
            "ᴺ",
            "ᴼ",
            "ᴾ",
            "ᶞ",
            "ᴿ",
            "ˢ",
            "ᵀ",
            "ᵁ",
            "ᵛ",
            "ᵂ",
            "˟",
            "ʸ",
            "ᶻ"
        ]
        //MARK:16.平假符号
        let modelSymbol_pingjia:iRsymbolsItemModel = iRsymbolsItemModel()
        modelMain.arrayModels?.append(modelSymbol_pingjia)
        modelSymbol_pingjia.name = "平假"
        modelSymbol_pingjia.sizeOfItem = self.sizeOfItemNormal
        modelSymbol_pingjia.arraySymbols = [
            "あ",
            "い",
            "う",
            "え",
            "お",
            "ぁ",
            "ぃ",
            "ぅ",
            "ぇ",
            "ぉ",
            "か",
            "き",
            "く",
            "け",
            "こ",
            "が",
            "ぎ",
            "ぐ",
            "げ",
            "ご",
            "さ",
            "し",
            "す",
            "せ",
            "そ",
            "ざ",
            "じ",
            "ず",
            "ぜ",
            "ぞ",
            "た",
            "ち",
            "つ",
            "て",
            "と",
            "だ",
            "ぢ",
            "づ",
            "で",
            "ど",
            "っ",
            "な",
            "に",
            "ぬ",
            "ね",
            "の",
            "は",
            "ひ",
            "ふ",
            "へ",
            "ほ",
            "ば",
            "び",
            "ぶ",
            "べ",
            "ぼ",
            "ぱ",
            "ぴ",
            "ぷ",
            "ぺ",
            "ぽ",
            "ま",
            "み",
            "む",
            "め",
            "も",
            "や",
            "ゆ",
            "よ",
            "ゃ",
            "ゅ",
            "ょ",
            "ら",
            "り",
            "る",
            "れ",
            "ろ",
            "わ",
            "を",
            "ん",
            "ゎ"
            ]
        //MARK:17.片假符号
        let modelSymbol_pianjia:iRsymbolsItemModel = iRsymbolsItemModel()
        modelMain.arrayModels?.append(modelSymbol_pianjia)
        modelSymbol_pianjia.name = "片假"
        modelSymbol_pianjia.sizeOfItem = self.sizeOfItemNormal
        modelSymbol_pianjia.arraySymbols = [
            "ア",
            "イ",
            "ウ",
            "エ",
            "オ",
            "ァ",
            "ィ",
            "ゥ",
            "ェ",
            "ォ",
            "カ",
            "キ",
            "ク",
            "ケ",
            "コ",
            "ガ",
            "ギ",
            "グ",
            "ゲ",
            "ゴ",
            "サ",
            "シ",
            "ス",
            "セ",
            "ソ",
            "ザ",
            "ジ",
            "ズ",
            "ゼ",
            "ゾ",
            "タ",
            "チ",
            "ツ",
            "テ",
            "ト",
            "ダ",
            "ヂ",
            "ヅ",
            "デ",
            "ド",
            "ッ",
            "ナ",
            "ニ",
            "ヌ",
            "ネ",
            "ノ",
            "ハ",
            "ヒ",
            "フ",
            "ヘ",
            "ホ",
            "バ",
            "ビ",
            "ブ",
            "ベ",
            "ボ",
            "パ",
            "ピ",
            "プ",
            "ペ",
            "ポ",
            "マ",
            "ミ",
            "ム",
            "メ",
            "モ",
            "ャ",
            "ヤ",
            "ュ",
            "ユ",
            "ョ",
            "ヨ",
            "ラ",
            "リ",
            "ル",
            "レ",
            "ロ",
            "ワ",
            "ヰ",
            "ヱ",
            "ヲ",
            "ン",
            "ヴ",
            "ヵ",
            "ヶ",
            "ー"
            ]
        //MARK:18.制表符号
        let modelSymbol_zhibiao:iRsymbolsItemModel = iRsymbolsItemModel()
        modelMain.arrayModels?.append(modelSymbol_zhibiao)
        modelSymbol_zhibiao.name = "制表"
        modelSymbol_zhibiao.sizeOfItem = self.sizeOfItemNormal
        modelSymbol_zhibiao.arraySymbols = [
            "─",
            "━",
            "│",
            "┃",
            "┄",
            "┅",
            "┆",
            "┇",
            "┈",
            "┉",
            "┊",
            "┋",
            "┌",
            "┍",
            "┎",
            "┏",
            "┐",
            "┑",
            "┒",
            "┓",
            "└",
            "┕",
            "┖",
            "┗",
            "┘",
            "┙",
            "┚",
            "┛",
            "├",
            "┝",
            "┞",
            "┟",
            "┠",
            "┡",
            "┢",
            "┣",
            "┤",
            "┥",
            "┦",
            "┧",
            "┨",
            "┩",
            "┪",
            "┫",
            "┬",
            "┭",
            "┮",
            "┯",
            "┰",
            "┱",
            "┲",
            "┳",
            "┴",
            "┵",
            "┶",
            "┷",
            "┸",
            "┹",
            "┶",
            "┻",
            "┼",
            "┽",
            "┾",
            "┿",
            "╀",
            "╁",
            "╂",
            "╃",
            "╄",
            "╅",
            "╆",
            "╇",
            "╈",
            "╉",
            "╊",
            "╋",
            "═",
            "║",
            "╒",
            "╓",
            "╔",
            "╕",
            "╖",
            "╗",
            "╘",
            "╙",
            "╚",
            "╛",
            "╜",
            "╝",
            "╞",
            "╟",
            "╠",
            "╡",
            "╢",
            "╣",
            "╤",
            "╥",
            "╦",
            "╧",
            "╨",
            "╩",
            "╪",
            "╫",
            "╬",
            "╭",
            "╮",
            "╯",
            "╰",
            "╱",
            "╲",
            "╳"
            ]
        //MARK:19.拉丁符号
        let modelSymbol_lading:iRsymbolsItemModel = iRsymbolsItemModel()
        modelMain.arrayModels?.append(modelSymbol_lading)
        modelSymbol_lading.name = "拉丁"
        modelSymbol_lading.sizeOfItem = self.sizeOfItemNormal
        modelSymbol_lading.arraySymbols = [
            "Ä",
            "Æ",
            "Å",
            "À",
            "Á",
            "Â",
            "Ã",
            "Ç",
            "È",
            "É",
            "Ê",
            "Ë",
            "Ð",
            "Ì",
            "Í",
            "Î",
            "Ï",
            "Ö",
            "Ø",
            "Ò",
            "Ó",
            "Ô",
            "Õ",
            "Ñ",
            "Ù",
            "Ú",
            "Û",
            "Ü",
            "Ý",
            "Þ",
            "ä",
            "æ",
            "å",
            "à",
            "á",
            "â",
            "ã",
            "ç",
            "è",
            "é",
            "ê",
            "ë",
            "ð",
            "ì",
            "í",
            "î",
            "ï",
            "ö",
            "ø",
            "ò",
            "ó",
            "ô",
            "õ",
            "ñ",
            "ù",
            "ú",
            "û",
            "ü",
            "ý",
            "þ"
            ]
        print(modelMain)
    }
   

    
}










































