//
//  Catboard.swift
//  TransliteratingKeyboard
//
//  Created by Alexei Baboulevitch on 9/24/14.
//  Copyright (c) 2014 Alexei Baboulevitch ("Archagon"). All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


/*
This is the demo keyboard. If you're implementing your own keyboard, simply follow the example here and then
set the name of your KeyboardViewController subclass in the Info.plist file.
*/






//// /////////////////
var showTypingCellInExtraLine = getShowTypingCellInExtraLineFromSettings()

func updateShowTypingCellInExtraLine() {
    showTypingCellInExtraLine = getShowTypingCellInExtraLineFromSettings()
}

func getShowTypingCellInExtraLineFromSettings() -> Bool {
    return UserDefaults.standard.bool(forKey: "kShowTypingCellInExtraLine")    // If not exist, false will be returned.
}

func getEnableGestureFromSettings() -> Bool {
    return UserDefaults.standard.bool(forKey: "kGesture")    // If not exist, false will be returned.
}

var cornerBracketEnabled = getCornerBracketEnabledFromSettings()

func updateCornerBracketEnabled() {
    cornerBracketEnabled = getCornerBracketEnabledFromSettings()
}

func getCornerBracketEnabledFromSettings() -> Bool {
    return UserDefaults.standard.bool(forKey: "kCornerBracket")    // If not exist, false will be returned.
}

var candidatesBannerAppearanceIsDark = false

let indexPathZero = IndexPath(row: 0, section: 0)
let indexPathFirst = IndexPath(row: 1, section: 0)

var startTime: Date?


//// //////////






let kCatTypeEnabled = "kCatTypeEnabled"

class Catboard: KeyboardViewController,RimeNotificationDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource, AGEmojiKeyboardViewDataSource, AGEmojiKeyboardViewDelegate,iRNumberBoardFatherViewProtocol{
    
    lazy var viewNumberBoardView:iRNumberBoardFatherView = {
        let viewNumberBoard = iRNumberBoardFatherView.init(frame: CGRect.null)
        self.view.addSubview(viewNumberBoard)
        //--属性设置
        viewNumberBoard.delegateAction = self
        //--约束布局
        viewNumberBoard.mas_makeConstraints { (make:MASConstraintMaker!) in
            
            make.left.equalTo()(self.view)
            make.right.equalTo()(self.view)
            make.bottom.equalTo()(self.view)
            make.top.equalTo()(self.view)?.setOffset(self.bannerView!.frame.size.height)
        }
        return viewNumberBoard

    }()
    
    var rimeSessionId_ : RimeSessionId = 0
    var isChineseInput: Bool = true
    var switchInputView:KeyboardKey?
    var candidatesBanner: CandidatesBanner?
    
    let fm :FileManger = FileManger()
    
    var openCCServer: OpenCCService?
    
    var isShowEmojiView: Bool = false
    
    var candidateIndex : NSInteger = -1;
    var candidateCount : NSInteger = 50;
    var candidateList:[CandidateModel]! = Array<CandidateModel>(){

    
        
        
        willSet{
        
        }
        
        didSet{
            

        }
        
    }
    
    var modelQueue: [Int] = Array<Int>()
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        UserDefaults.standard.register(defaults: [kCatTypeEnabled: true])
        
        

        
       
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        print("----------------------------viewDidLoad--------------------");
        super.viewDidLoad()

        
        fm.startBlock = {
            ()->() in
            
            self.view.isUserInteractionEnabled = false
            
        }
        
        
        fm.endBlock = {
            ()->()in
            
            self.view.isUserInteractionEnabled = true
            
        }
        
        fm.initSettingFile()
        
        
        self.modePush(self.currentMode)
        
        
      print("----------------------------viewDidLoad--------------------");
        
    }

    
    func presentTextFromNumberPad(_ text:String) -> Void
    {
        self.textDocumentProxy.insertText(text);
        
        //play key sound
        self.playKeySound()
    }
    
    func deleteBackwardOfiRNumberBoardFatherView() -> Void
    {
        self.textDocumentProxy.deleteBackward()
        
        //play key sound
        self.playKeySound()
    }
    
    
    func getReturnKeyTitle() -> String {
        return self.getReturnKeyTitleString()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("------------------viewDidAppear---------------------")
        
        
        
        //open iRime
        //keyboard 没有权限，需要跳到iRime去创建目录
        let fm = FileManager.default.fileExists(atPath: NSString.rimeResource())
        if !fm {
            let iRimeURL = "iRime://create.iRime.dir";
            self.openURL(iRimeURL)
            return;
        }
        

        
        
         RimeWrapper .setNotificationDelegate(self)
        if RimeWrapper.startService() {
            
            print("start service success");
            
            
            //
            let curSchema = NSString.userDefaultsInGroup().string(forKey: CURRENT_SCHEMA_NAME)
//            print(curSchema);
            if curSchema == nil {
                print("当前默认输入法为空")
                NSString.userDefaultsInGroup().set(DEFAULT_SCHEMA_NAME, forKey:CURRENT_SCHEMA_NAME)
                
            }
            
            //
            
            
            openCCServer = nil
            let ud = NSString.userDefaultsInGroup()
            let CC = ud?.integer(forKey: CURRENT_CC)
            if CC != 0 {
                let unsignCC = UInt(CC!)
                
                let f = OpenCCServiceConverterType(rawValue: unsignCC)
                openCCServer = OpenCCService(converterType: f!)
                
            }
            
            
            //中文输入
            if !RimeWrapper.isSessionAlive(rimeSessionId_) {
                rimeSessionId_ = RimeWrapper.createSession()
                

            }
            
            
        }else{
            
            print("start service error");
            
        }
        
        
        
        //update key board
        self.updateKeyTitle()
        
        
        print("------------------viewDidAppear---------------------")

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("------------------viewDidDidAppear---------------------")
        
        
        openCCServer = nil
        RimeWrapper.stopService()
        print("------------------viewDidDidAppear---------------------")
    }
    
    deinit{
        
        print("-------------------------deinit---------------------------")
        
    }
    
    
    func modePush(_ model : Int) {
        self.modelQueue.append(model)
        self.currentMode = model
        
        if self.currentMode == 0 {
            self.isChineseInput = true
        }else{
            self.isChineseInput = false
        }
        
        print(self.modelQueue)
    }
    
    func modelPop() {
        self.modelQueue.removeLast()
        let first = self.modelQueue.last
        self.currentMode = first!
        
        if self.currentMode == 0 {
            self.isChineseInput = true
        }else{
            self.isChineseInput = false
        }
        
        print(self.modelQueue)
    }
    
    func modelPopToModel(_ model : Int) {
        
    }
    
    override func modeChangeTapped(_ sender: KeyboardKey){
        
        let toMode = self.layout?.viewToModel[sender]?.toMode
        
        
        if toMode == -1 {
            self.modelPop()
        }
        else if(toMode == 1)
        {
           print("我要切换到数字键盘喽")
           self.viewNumberBoardView.isHidden = false
           self.view.bringSubview(toFront: self.viewNumberBoardView)
        }
        else{
            self.modePush(toMode!)
        }
        
        RimeWrapper.clearComposition(forSession: rimeSessionId_)
        
        self.removeAllCandidateList();
        self.candidatesBanner?.reloadData()
        
    }
    
    override func keyPressed(_ key: Key) {
        
        //play key sound
        self.playKeySound()
        
        let textDocumentProxy = self.textDocumentProxy
        
        if self.isChineseInput == false {
            if key.type == .backspace {
                textDocumentProxy.deleteBackward()
                return;
            }
            
            if key.type == .space && self.spaceDragIsMoving == false {
                textDocumentProxy.insertText(" ")
                self.spaceDragIsMoving = false
                return;
            }
            
            if key.type == .modeChange{
                return;
            }
            
            super.keyPressed(key)
            
            if key.type == .specialCharacter {
                if let m = key.toMode {
                    if m == -1 {
                        self.modelPop()
                    }
                }

            }
            return
        }
        

        
        //返回键
        if key.type == .return {
            
            if RimeWrapper.isSessionAlive(self.rimeSessionId_) == false {
                print("按键-->session 不存在")
                return;
            }
            let c: XRimeContext = RimeWrapper.context(forSession: rimeSessionId_)
            var preedite:String? = c.composition.preeditedText
            if preedite?.characters.count > 0{
                
                preedite = preedite!.replacingOccurrences(of: " ", with: "")//去掉所有空格
                
//                textDocumentProxy.insertText(preedite!)
                self.insertText(preedite!)
                RimeWrapper.clearComposition(forSession: self.rimeSessionId_)
                
                
                self.removeAllCandidateList();
                self.candidatesBanner?.reloadData()
                
                return;
            }
            
            textDocumentProxy.insertText("\n")
            return
       }
        

        
        //数字，符号等
        //--------------------------------------------------
        let keyOutput = key.outputForCase(self.shiftState.uppercase())
        
        if !UserDefaults.standard.bool(forKey: kCatTypeEnabled) {
            textDocumentProxy.insertText(keyOutput)
            return
        }
        

        //----------------------------------------------
        let ko = key.outputForCase(self.shiftState.uppercase())
        let nsstrTest:NSString = ko as NSString
        let result = nsstrTest.utf8String?[0] //result = 99
        
        //删除按钮
        var r = Int32(result!)
        if key.type == .backspace {
            r = Int32(XK_BackSpace)
        }
        
        if key.type == .space {
            
            
            if self.candidateList.count <= 0 {
                if RimeWrapper.commitComposition(forSession: rimeSessionId_) {
                    RimeWrapper.clearComposition(forSession: rimeSessionId_)
                    self.candidatesBanner?.reloadData()
                }
                if self.spaceDragIsMoving == false {
                    textDocumentProxy.insertText(" ")
                }
                self.spaceDragIsMoving = false
                return
            }
            
            RimeWrapper.clearComposition(forSession: rimeSessionId_)
            var t = self.candidateList.first!.text
            t = t! + " "
            self.insertText(t!)
            self.removeAllCandidateList();
            self.candidatesBanner?.reloadData()
           
        }
        

        let h = RimeWrapper.inputKey(forSession: rimeSessionId_, rimeKeyCode: r, rimeModifier: 0)
        if h == false {
            textDocumentProxy.deleteBackward()
            self.removeAllCandidateList();
            self.candidatesBanner?.reloadData()
            return;
        }else{
            //
            let comitText = RimeWrapper.consumeComposedText(forSession: self.rimeSessionId_)
            if (comitText != nil) {
                self.insertText(comitText!)
                self.removeAllCandidateList();
                self.candidatesBanner?.reloadData()
                return
            }
        }
        
        
        self.removeAllCandidateList();
        let cl = RimeWrapper.getCandidateList(forSession: rimeSessionId_, andIndex: -1, andCount: 50) as? [String]
        
        if (cl == nil) {
            self.removeAllCandidateList();
        }else{
            
            self.addCandidates(cl!)
            
        }
        
        self.candidatesBanner?.reloadData()
        
        
        return;
        
    }
    
    func addCandidates(_ strings:[String]) {
        

        for s in strings {
            let candidate = CandidateModel()
            candidate.text = self.openCC(s)
            self.candidateList.append(candidate)
        }
        
    }
    
    func removeAllCandidateList() {
        self.candidateList.removeAll()
        self.candidateIndex = -1;
        self.candidateCount = 50;
    }
    
    func openCC(_ text: String) ->String {
        
        var ret = text
        
        if self.openCCServer != nil {
            ret = (self.openCCServer?.convert(text))!
        }
        return ret;
    }
    
    func insertText(_ text:String) {
        
        //
        var s = text;
        if self.openCCServer != nil {
            s = self.openCCServer!.convert(text)
        }
        
        self.textDocumentProxy.insertText(s)
    }
    
    
    override func setupKeys() {
        super.setupKeys()
        
        
        for page in keyboard.pages  {
            for rowKeys in page.rows {
                for key in rowKeys {
                    if let keyView = self.layout?.viewForKey(key){
                        
                        
                        //
                        if key.type == .space {

                            var s = UIPanGestureRecognizer(target: self, action: #selector(Catboard.spaceSwipLeft(_:)))
                            keyView.addGestureRecognizer(s)
                            
                            
                            s = UIPanGestureRecognizer(target: self, action: #selector(Catboard.spaceSwipRigth(_:)))
                            keyView.addGestureRecognizer(s)
                            
                            
                            
                            break;
                        }
                        
                        
                        
                        
                        
                        
                    }

                }
            }
        }
        
    }
    
    
    func spaceSwipLeft(_ gesture: UISwipeGestureRecognizer) {
        
        print("swip left ...")
    }
    
    func spaceSwipRigth(_ gesture: UISwipeGestureRecognizer) {
        
        print("swip rigth...")
    }
    
    
    
    // a settings view that replaces the keyboard when the settings button is pressed
//    override func createSettings() -> ExtraView? {
//        
//        settingsView = EmojiView(globalColors: self.dynamicType.globalColors, darkMode: false, solidColorMode: self.solidColorMode())
//        
//        return settingsView
//    }
    

    
    
    
    
    
    override func createBanner() -> ExtraView? {
        
        candidatesBanner = CandidatesBanner(globalColors: type(of: self).globalColors, darkMode: false, solidColorMode: self.solidColorMode())
        candidatesBanner!.delegate = self
        
        weak var weakSelf = self
        candidatesBanner?.toolsView.tapToolsItem = {
            (btn:UIButton, index:Int) in
            
            weakSelf?.playKeySound()
            if index == 1 {
                //open iRime
                //let iRimeURL = "iRime://";
                //self.openURL(iRimeURL)
            }else if index == 2{
                if (weakSelf?.isShowEmojiView)! {
                    weakSelf?.exitEmojiView()
                    btn.backgroundColor = UIColor.white
                    btn.setImage(UIImage(named: "emoji_tab1"), for: UIControlState())
                }else{
                    weakSelf?.showEmojiView()
                    btn.backgroundColor = UIColor.gray
                    btn.setImage(UIImage(named: "emoji_tab1Press"), for: UIControlState())

                }
            }
            
        }
        return candidatesBanner
    }
    
    
    func openURL(_ url: String) {
        var responder: UIResponder = self
        while responder.next != nil {
            responder = responder.next!
            NSLog("responder = %@", responder)
            if responder.responds(to: #selector(Catboard.openURL(_:))) == true {
                responder.perform(#selector(Catboard.openURL(_:)), with: URL(string: url))
            }
        }
    }
    
    // KeyboardViewController
    override func updateAppearances(_ appearanceIsDark: Bool) {
        return
        candidatesBannerAppearanceIsDark = appearanceIsDark
        candidatesBannerAppearanceIsDark = false
        super.updateAppearances(candidatesBannerAppearanceIsDark)
        candidatesBanner?.updateAppearance()
    }
    
    
    var currentOrientation: UIInterfaceOrientation? = nil
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        super.willRotate(to: toInterfaceOrientation, duration: duration)
        currentOrientation = toInterfaceOrientation
        self.candidatesBanner?.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
        print("-------------------------------didReceiveMemoryWarning------------------------------------------")
        
    }
    
    //collocetionView
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        //play key sound
        self.playKeySound()
        
        self.selectText(indexPath.row)
        self.exitCandidatesTableIfNecessary()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = self.candidateList?.count
        //print(count)
        return count!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CandidateCell
        cell.updateAppearance()
        if (indexPath == indexPathZero) {
            cell.textLabel.textAlignment = .left
        } else {
            cell.textLabel.textAlignment = .center
        }
        let candidate = self.candidateList[indexPath.row]
        cell.textLabel.text = candidate.text
        //        cell.textLabel.sizeToFit()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let candidate = self.candidateList[indexPath.row]
        
        if candidate.textSize == nil{
            candidate.textSize = getCellSizeAtIndex(indexPath, andText: candidate.text, andSetLayout: collectionViewLayout as! UICollectionViewFlowLayout)
        }
        
        return candidate.textSize!
        
    }
    
    
//
    func getCellSizeAtIndex(_ indexPath: IndexPath, andText text: String, andSetLayout layout: UICollectionViewFlowLayout) -> CGSize {
        let size = CandidateCell.getCellSizeByText(text, needAccuracy: indexPath == indexPathZero ? true : false)
        if let myLayout = layout as? MyCollectionViewFlowLayout {
            myLayout.updateLayoutRaisedByCellAt(indexPath, withCellSize: size)
        }
        return size
    }
    
    
    var isShowingCandidatesTable = false
    @IBAction func toggleCandidatesTableOrDismissKeyboard() {
        self.playKeySound()
        if self.candidateList?.count <= 0 {
            Logger.sharedInstance.writeLogLine(filledString: "[DOWN] <> DISMISS")
            self.dismissKeyboard()
            return
        }
        
        
        if isShowingCandidatesTable == false {
            Logger.sharedInstance.writeLogLine(filledString: "[DOWN] <>")
            isShowingCandidatesTable = true
            showCandidatesTable()
        } else {
            Logger.sharedInstance.writeLogLine(filledString: "[UP] <>")
            isShowingCandidatesTable = false
            exitCandidatesTable()
        }
    }
    
    var candidatesTable: UICollectionView!
    func showCandidatesTable() {
        isShowingCandidatesTable = true
        candidatesBanner!.hideTypingAndCandidatesView()
        candidatesBanner!.changeArrowUp()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        candidatesTable = UICollectionView(frame: CGRect(x: view.frame.origin.x, y: view.frame.origin.y + getBannerHeight(), width: view.frame.width, height: view.frame.height - getBannerHeight()), collectionViewLayout: layout)
        candidatesTable.backgroundColor = candidatesBannerAppearanceIsDark ? UIColor.darkGray : UIColor.white
        candidatesTable.register(CandidateCell.self, forCellWithReuseIdentifier: "Cell")
        candidatesTable.delegate = self
        candidatesTable.dataSource = self
        
        //add mjrefresh
//        self.candidatesTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            //Call this Block When enter the refresh status automatically
//            }];
        
        weak var weakSelf = self
        let footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            
            weakSelf?.loadMoreCandidate(scrollView: (weakSelf?.candidatesTable)!)
            
        });
        (footer!).stateLabel.isHidden = true
        self.candidatesTable.mj_footer = footer
        
        
        
        
        self.view.addSubview(candidatesTable)
    }
    
    func exitCandidatesTable() {
        isShowingCandidatesTable = false
        candidatesBanner!.scrollToFirstCandidate()
        candidatesBanner!.unhideTypingAndCandidatesView()
        candidatesBanner!.changeArrowDown()
        candidatesTable.removeFromSuperview()
    }
    
    func loadMoreCandidate(scrollView: UIScrollView) {
//        let cl = RimeWrapper.getCandidateList(forSession: rimeSessionId_) as? [String]
        //print("index:%d", self.candidateIndex)
        //print("count:%d", self.candidateCount)
        self.candidateIndex += self.candidateCount
        let cl = RimeWrapper.getCandidateList(forSession: rimeSessionId_, andIndex: self.candidateIndex, andCount: self.candidateCount) as? [String]
        
        if (cl != nil) {
            self.addCandidates(cl!)
        }else{
            scrollView.mj_footer.endRefreshingWithNoMoreData()
            return;
        }
        
        self.candidatesTable.reloadData()
        
        
        scrollView.mj_footer.endRefreshing();
    }
    
    
    //------------emoji view
    var emojiView : AGEmojiKeyboardView!
    
    func showEmojiView() {

        let r = CGRect(x: view.frame.origin.x, y: view.frame.origin.y + getBannerHeight(), width: view.frame.width, height: view.frame.height - getBannerHeight())
        emojiView = AGEmojiKeyboardView(frame: r, dataSource: self)
        emojiView.delegate = self
        emojiView.backgroundColor = UIColor.white
        emojiView.autoresizingMask = .flexibleHeight
        emojiView.pageControl.pageIndicatorTintColor = UIColor.gray
        emojiView.pageControl.currentPageIndicatorTintColor = UIColor.darkGray
        self.view.addSubview(emojiView)
        self.isShowEmojiView = true
        
        
        
    }
    
    func exitEmojiView() {
        
        self.isShowEmojiView = false
        emojiView.removeFromSuperview()
        
    }
   
    
    func emojiKeyBoardView(_ emojiKeyBoardView: AGEmojiKeyboardView!, didUseEmoji emoji: String!) {
        
        self.textDocumentProxy.insertText(emoji)
        
    }
    
    func emojiKeyBoardViewDidPressBackSpace(_ emojiKeyBoardView: AGEmojiKeyboardView!) {
        
        self.textDocumentProxy.deleteBackward()
        
    }
    
    
    func emojiKeyboardView(_ emojiKeyboardView: AGEmojiKeyboardView!, imageForSelectedCategory category: AGEmojiKeyboardViewCategoryImage) -> UIImage! {
        
        var imgName: String = ""
        
        if category == .recent {
            
            imgName = "emoji_tab0Press"
            
        }else if category == .face{
            
            imgName = "emoji_tab1Press"
            
        }else if category == .bell{
            
            imgName = "emoji_tab2Press"
            
        }else if category == .flower{
            
            imgName = "emoji_tab3Press"
            
        }else if category == .car {
            
            imgName = "emoji_tab4Press"
            
        }else if category == .characters{
            
            imgName = "emoji_tab5Press"
            
        }
        
        return UIImage(named: imgName)
        
    }
   
    func emojiKeyboardView(_ emojiKeyboardView: AGEmojiKeyboardView!, imageForNonSelectedCategory category: AGEmojiKeyboardViewCategoryImage) -> UIImage! {
         var imgName: String = ""
        
        if category == .recent {
            
            imgName = "emoji_tab0"
            
        }else if category == .face{
            
            imgName = "emoji_tab1"
            
        }else if category == .bell{
            
            imgName = "emoji_tab2"
            
        }else if category == .flower{
            
            imgName = "emoji_tab3"
            
        }else if category == .car {
            
            imgName = "emoji_tab4"
            
        }else if category == .characters{
            
            imgName = "emoji_tab5"
            
        }
        
        return UIImage(named: imgName)       
    }
    
    func backSpaceButtonImage(for emojiKeyboardView: AGEmojiKeyboardView!) -> UIImage! {
        
        return UIImage(named: "expression_delete")
    }
    
    
    //-----------------------
    
    func exitCandidatesTableIfNecessary() {
        if isShowingCandidatesTable == false {
            return
        }
        exitCandidatesTable()
    }
    
    //tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (self.candidateList?.count)!
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "textCell")
        if cell == nil {
            cell = CandidateTableCellTableViewCell(style: .default, reuseIdentifier: "textCell")
        }
        
        let c: CandidateTableCellTableViewCell = cell as! CandidateTableCellTableViewCell
        let candidate = self.candidateList[indexPath.row]
        c.txtLabel?.text = candidate.text
        
        if indexPath.row == 0 {
            c.txtLabel?.textColor = UIColor.init(red: 0, green: 128.0 / 255.0, blue: 248.0 / 255, alpha: 1.0);
        }else{
            c.txtLabel?.textColor = UIColor.black
        }
        
        return cell!
        
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        let s = self.candidateList![indexPath.row]
        
        if s.textSize == nil {
            s.textSize = CandidateCell.getCellSizeByText(s.text, needAccuracy: indexPath == indexPathZero ? true : false)
        }
        //设置第一个选项宽大点，方便选择
        if indexPath.row == 0 {
            let l : CGFloat = 5.0
            return s.textSize!.width + l
        }
        return s.textSize!.width
        
       
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        

        
        self.selectText(indexPath.row)
        self.candidatesBanner?.scrollToFirstCandidate()
        
        //play key sound
        self.playKeySound()
        
    }
    
    
    func selectText(_ index: NSInteger) -> String? {
        let res = RimeWrapper.selectCandidate(forSession: self.rimeSessionId_, in: index)
        if res == false {
            print("选中没有文字了")
            return nil;
        }
        
        
        let comitText = RimeWrapper.consumeComposedText(forSession: self.rimeSessionId_)
        if (comitText != nil) {
            self.insertText(comitText!)
            self.removeAllCandidateList();
            self.candidatesBanner?.reloadData()
            return comitText;
        }
        

        let cl = RimeWrapper.getCandidateList(forSession: self.rimeSessionId_, andIndex: self.candidateIndex, andCount: self.candidateCount) as? [String]
        self.removeAllCandidateList();
        if (cl != nil) {
            
            self.addCandidates(cl!)
        }

        self.candidatesBanner?.reloadData()
        return nil;
    }
    
    
    
    func getPreeditedText() -> String {
       
        if RimeWrapper.isSessionAlive(rimeSessionId_) == false {
            return "";
        }
        
        let context: XRimeContext = RimeWrapper.context(forSession: rimeSessionId_)
        return context.composition.preeditedText
    }
    

    
    
    func switchInputTouchDown(){
    }
    
    func switchInputTouchUp(){
        
        self.clearInput()
        self.isChineseInput = !self.isChineseInput
        
        self.shiftState = .locked
        self.changeSwitchInputButtonText()
        
    }
    
    func changeSwitchInputButtonText() {
        
        if self.isChineseInput {
            self.switchInputView?.label.text = "ABC"
        }else{
            self.switchInputView?.label.text = "返回"
        }
        
    }
    
    func clearInput() {
        
        if RimeWrapper.isSessionAlive(self.rimeSessionId_) == false {
            print("按键-->session 不存在")
            return;
        }
        RimeWrapper.clearComposition(forSession: self.rimeSessionId_)
       
    }
    
    
    //-----------------------------
    
    func onDeploymentStarted() {
        print("deploy start....")
//        DispatchQueue.main.async { 
//            self.showDeployView()
//        };
    }
    
    
    func onDeploymentSuccessful() {
        
        print("deploy successful....")
        
        
        DispatchQueue.main.async { 
//            let uf = NSString.userDefaultsInGroup()
//            uf.setObject(NOT_NEED_DEPOLY, forKey: IS_NEED_DEPOLY)
//            self.exitDeployView()
            
            //中文输入
            if !RimeWrapper.isSessionAlive(self.rimeSessionId_) {
                self.rimeSessionId_ = RimeWrapper.createSession()
            }
        };
        
       
        
    }
    
    func onDeploymentFailed() {
        
        print("deploy fail....")
//        DispatchQueue.main.async { 
//            self.exitDeployView()
//        }
    }
    
    func onSchemaChanged(withNewSchema schema: String!) {
        
        print("deploy change new schema....")
    }
    
    func onOptionChanged(with option: XRimeOption, value: Bool) {
        
        print("deploy chand option....")
    }
    
    
    //--------------------
    
    
    func needDeploy() {
        
//     if RimeWrapper.isSessionAlive(rimeSessionId_) == false {
//        return;
//    }
    
        let uf = NSString .userDefaultsInGroup()
        
        let isNeed = uf?.string(forKey: NEED_DEPOLY)
        
        if isNeed == IS_NEED_DEPOLY || isNeed == nil {
            
           
            RimeWrapper.redeploy(withFastMode: false)
        }
        
        
    }
    
    var deployView: DeployView?
    func showDeployView() {
        
        let r = CGRect(x: view.frame.origin.x, y: view.frame.origin.y + getBannerHeight(), width: view.frame.width, height: view.frame.height - getBannerHeight())
        deployView = DeployView(frame: r)
        self.view.addSubview(deployView!)
        
    }
    
    
    func exitDeployView() {
        
        deployView?.removeFromSuperview()
        
    }
    
    
    override func playKeySound() {
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
            PlaySound.playSound()
        })
        
    }
    
    
    func updateKeyTitle() {
        

        //find the return key
        for page in keyboard.pages {
            for row in page.rows {
                
                for k in row {
                    if k.type == .return {
                        k.uppercaseKeyCap = self.getReturnKeyTitleString()
                        k.uppercaseOutput = "\n"
                        k.lowercaseOutput = "\n"
                    }
                    
                    if k.type == .space {
                        
                        if RimeWrapper.isSessionAlive(rimeSessionId_) {
                            
                            let schemaName = RimeWrapper.getCurrentSchemaName(withSessionId: rimeSessionId_)
                            
                            k.uppercaseKeyCap = schemaName
                            k.uppercaseOutput = "\n"
                            k.lowercaseOutput = "\n"

                        }
                        

                    }
                }
                
            }
        }
    }

}




