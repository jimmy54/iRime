//
//  Catboard.swift
//  TransliteratingKeyboard
//
//  Created by Alexei Baboulevitch on 9/24/14.
//  Copyright (c) 2014 Alexei Baboulevitch ("Archagon"). All rights reserved.
//

import UIKit


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
    return NSUserDefaults.standardUserDefaults().boolForKey("kShowTypingCellInExtraLine")    // If not exist, false will be returned.
}

func getEnableGestureFromSettings() -> Bool {
    return NSUserDefaults.standardUserDefaults().boolForKey("kGesture")    // If not exist, false will be returned.
}

var cornerBracketEnabled = getCornerBracketEnabledFromSettings()

func updateCornerBracketEnabled() {
    cornerBracketEnabled = getCornerBracketEnabledFromSettings()
}

func getCornerBracketEnabledFromSettings() -> Bool {
    return NSUserDefaults.standardUserDefaults().boolForKey("kCornerBracket")    // If not exist, false will be returned.
}

var candidatesBannerAppearanceIsDark = false

let indexPathZero = NSIndexPath(forRow: 0, inSection: 0)
let indexPathFirst = NSIndexPath(forRow: 1, inSection: 0)

var startTime: NSDate?


//// //////////






let kCatTypeEnabled = "kCatTypeEnabled"

class Catboard: KeyboardViewController,RimeNotificationDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource, AGEmojiKeyboardViewDataSource, AGEmojiKeyboardViewDelegate{
    
    var rimeSessionId_ : RimeSessionId = 0
    var isChineseInput: Bool = true
    var switchInputView:KeyboardKey?
    var candidatesBanner: CandidatesBanner?
    
    let fm :FileManger = FileManger()
    
    var openCCServer: OpenCCService?
    
    var isShowEmojiView: Bool = false
    
    var candidateList:[CandidateModel]! = Array<CandidateModel>(){
    
        
        
        willSet{
        
        }
        
        didSet{
            

        }
        
    }
    
    var modelQueue: [Int] = Array<Int>()
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        NSUserDefaults.standardUserDefaults().registerDefaults([kCatTypeEnabled: true])
        
        

        
       
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("input viewDidLoad");
        fm.startBlock = {
            ()->() in
            
            self.view.userInteractionEnabled = false
            
        }
        
        
        fm.endBlock = {
            ()->()in
            
            self.view.userInteractionEnabled = true
            
        }
        
        fm.initSettingFile()
        
        
        self.modePush(self.currentMode)
        
        
        

        
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("------------------viewDidAppear---------------------")
         RimeWrapper .setNotificationDelegate(self)
        if RimeWrapper.startService() {
            
            print("start service success");
            
            
            //
            let curSchema = NSString.userDefaultsInGroup().stringForKey(CURRENT_SCHEMA_NAME)
            print(curSchema);
            if curSchema == nil {
                print("当前默认输入法为空")
                NSString.userDefaultsInGroup().setObject(DEFAULT_SCHEMA_NAME, forKey:CURRENT_SCHEMA_NAME)
                
            }
            
            //
            
            
            openCCServer = nil
            let ud = NSString.userDefaultsInGroup()
            let CC = ud.integerForKey(CURRENT_CC)
            if CC != 0 {
                let unsignCC = UInt(CC)
                
                let f = OpenCCServiceConverterType(rawValue: unsignCC)
                openCCServer = OpenCCService(converterType: f!)
                
            }
            
            
            //中文输入
            if !RimeWrapper.isSessionAlive(rimeSessionId_) {
                rimeSessionId_ = RimeWrapper.createSession()
            }
            
            
            

//            self.needDeploy()
            
            
        }else{
            
            print("start service error");
            
        }
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("------------------viewDidDidAppear---------------------")
        
        
        openCCServer = nil
        RimeWrapper.stopService()
//        RimeWrapper.RimeDeployWorkspace();
//        RimeWrapper.redeployWithFastMode(false)
    }
    
    deinit{
        
        print("-------------------------deinit---------------------------")
        
    }
    
    
    func modePush(model : Int) {
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
    
    func modelPopToModel(model : Int) {
        
    }
    
    override func modeChangeTapped(sender: KeyboardKey){
        
        let toMode = self.layout?.viewToModel[sender]?.toMode
        
        
        if toMode == -1 {
            self.modelPop()
        }else{
            self.modePush(toMode!)
        }
        
        RimeWrapper.clearCompositionForSession(rimeSessionId_)
        self.candidateList.removeAll()
        self.candidatesBanner?.reloadData()
        
    }
    
    override func keyPressed(key: Key) {
        
        let textDocumentProxy = self.textDocumentProxy
        
        if self.isChineseInput == false {
            if key.type == .Backspace {
                textDocumentProxy.deleteBackward()
                return;
            }
            
            if key.type == .Space && self.spaceDragIsMoving == false {
                textDocumentProxy.insertText(" ")
                self.spaceDragIsMoving = false
                return;
            }
            
            if key.type == .ModeChange{
                return;
            }
            
            super.keyPressed(key)
            
            if key.type == .SpecialCharacter {
                if let m = key.toMode {
                    if m == -1 {
                        self.modelPop()
                    }
                }

            }
            return
        }
        

        
        //返回键
        if key.type == .Return {
            
            if RimeWrapper.isSessionAlive(self.rimeSessionId_) == false {
                print("按键-->session 不存在")
                return;
            }
            let c: XRimeContext = RimeWrapper.contextForSession(rimeSessionId_)
            var preedite:String? = c.composition.preeditedText
            if preedite?.characters.count > 0{
                
                preedite = preedite!.stringByReplacingOccurrencesOfString(" ", withString: "")//去掉所有空格
                
//                textDocumentProxy.insertText(preedite!)
                self.insertText(preedite!)
                RimeWrapper.clearCompositionForSession(self.rimeSessionId_)
                
                self.candidateList.removeAll()
                self.candidatesBanner?.reloadData()
                
                return;
            }
            
            textDocumentProxy.insertText("\n")
            return
       }
        

        
        //数字，符号等
        //--------------------------------------------------
        let keyOutput = key.outputForCase(self.shiftState.uppercase())
        
        if !NSUserDefaults.standardUserDefaults().boolForKey(kCatTypeEnabled) {
            textDocumentProxy.insertText(keyOutput)
            return
        }
        

        //----------------------------------------------
        let ko = key.outputForCase(self.shiftState.uppercase())
        let nsstrTest:NSString = ko as NSString
        let result = nsstrTest.UTF8String[0] //result = 99
        
        //删除按钮
        var r = Int32(result)
        if key.type == .Backspace {
            r = Int32(XK_BackSpace)
        }
        
        if key.type == .Space {
            
            
            if self.candidateList.count <= 0 {
                if RimeWrapper.commitCompositionForSession(rimeSessionId_) {
                    RimeWrapper.clearCompositionForSession(rimeSessionId_)
                    self.candidatesBanner?.reloadData()
                }
                if self.spaceDragIsMoving == false {
                    textDocumentProxy.insertText(" ")
                }
                self.spaceDragIsMoving = false
                return
            }
            
            RimeWrapper.clearCompositionForSession(rimeSessionId_)
            var t = self.candidateList.first!.text
            t = t.stringByAppendingString(" ")
            self.insertText(t)
            self.candidateList.removeAll()
            self.candidatesBanner?.reloadData()
           
        }
        

        let h = RimeWrapper.inputKeyForSession(rimeSessionId_, rimeKeyCode: r, rimeModifier: 0)
        if h == false {
            textDocumentProxy.deleteBackward()
            self.candidateList.removeAll()
            self.candidatesBanner?.reloadData()
            return;
        }
        
        
        let cl = RimeWrapper.getCandidateListForSession(rimeSessionId_) as? [String]
        
        if (cl == nil) {
            self.candidateList.removeAll()
        }else{
            
            self.addCandidates(cl!)
            
        }
        
        self.candidatesBanner?.reloadData()
        
        return;
        
    }
    
    func addCandidates(strings:[String]) {
        
        self.candidateList.removeAll()
        for s in strings {
            let candidate = CandidateModel()
            candidate.text = self.openCC(s)
            self.candidateList.append(candidate)
        }
        
    }
    
    func openCC(text: String) ->String {
        
        var ret = text
        
        if self.openCCServer != nil {
            ret = (self.openCCServer?.convert(text))!
        }
        return ret;
    }
    
    func insertText(text:String) {
        
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
                        if key.type == .Space {

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
    
    
    func spaceSwipLeft(gesture: UISwipeGestureRecognizer) {
        
        print("swip left ...")
    }
    
    func spaceSwipRigth(gesture: UISwipeGestureRecognizer) {
        
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
        
        candidatesBanner = CandidatesBanner(globalColors: self.dynamicType.globalColors, darkMode: false, solidColorMode: self.solidColorMode())
        candidatesBanner!.delegate = self
        
        candidatesBanner?.toolsView.tapToolsItem = {
            (btn:UIButton, index:Int) in
            
            if index == 1 {
                //open iRime
                let iRimeURL = "iRime://";
                self.openURL(iRimeURL)
            }else if index == 2{
                if self.isShowEmojiView {
                    self.exitEmojiView()
                    btn.backgroundColor = UIColor.whiteColor()
                    btn.setImage(UIImage(named: "emoji_tab1"), forState: .Normal)
                }else{
                    self.showEmojiView()
                    btn.backgroundColor = UIColor.grayColor()
                    btn.setImage(UIImage(named: "emoji_tab1Press"), forState: .Normal)

                }
            }
            
        }
        return candidatesBanner
    }
    
    
    func openURL(url: String) {
        var responder: UIResponder = self
        while responder.nextResponder() != nil {
            responder = responder.nextResponder()!
            NSLog("responder = %@", responder)
            if responder.respondsToSelector(#selector(Catboard.openURL(_:))) == true {
                responder.performSelector(#selector(Catboard.openURL(_:)), withObject: NSURL(string: url))
            }
        }
    }
    
    // KeyboardViewController
    override func updateAppearances(appearanceIsDark: Bool) {
        candidatesBannerAppearanceIsDark = appearanceIsDark
        super.updateAppearances(appearanceIsDark)
        candidatesBanner?.updateAppearance()
    }
    
    
    var currentOrientation: UIInterfaceOrientation? = nil
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        super.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration)
        currentOrientation = toInterfaceOrientation
        self.candidatesBanner?.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
        print("-------------------------------didReceiveMemoryWarning------------------------------------------")
        
    }
    
    //collocetionView
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        self.selectText(indexPath.row)
        self.exitCandidatesTableIfNecessary()
        
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = self.candidateList?.count
        print(count)
        return count!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CandidateCell
        cell.updateAppearance()
        if (indexPath == indexPathZero) {
            cell.textLabel.textAlignment = .Left
        } else {
            cell.textLabel.textAlignment = .Center
        }
        let candidate = self.candidateList[indexPath.row]
        cell.textLabel.text = candidate.text
        //        cell.textLabel.sizeToFit()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let candidate = self.candidateList[indexPath.row]
        
        if candidate.textSize == nil{
            candidate.textSize = getCellSizeAtIndex(indexPath, andText: candidate.text, andSetLayout: collectionViewLayout as! UICollectionViewFlowLayout)
        }
        
        return candidate.textSize!
        
    }
    
    
//
    func getCellSizeAtIndex(indexPath: NSIndexPath, andText text: String, andSetLayout layout: UICollectionViewFlowLayout) -> CGSize {
        let size = CandidateCell.getCellSizeByText(text, needAccuracy: indexPath == indexPathZero ? true : false)
        if let myLayout = layout as? MyCollectionViewFlowLayout {
            myLayout.updateLayoutRaisedByCellAt(indexPath, withCellSize: size)
        }
        return size
    }
    
    
    var isShowingCandidatesTable = false
    @IBAction func toggleCandidatesTableOrDismissKeyboard() {
        
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
        layout.scrollDirection = .Vertical
        candidatesTable = UICollectionView(frame: CGRect(x: view.frame.origin.x, y: view.frame.origin.y + getBannerHeight(), width: view.frame.width, height: view.frame.height - getBannerHeight()), collectionViewLayout: layout)
        candidatesTable.backgroundColor = candidatesBannerAppearanceIsDark ? UIColor.darkGrayColor() : UIColor.whiteColor()
        candidatesTable.registerClass(CandidateCell.self, forCellWithReuseIdentifier: "Cell")
        candidatesTable.delegate = self
        candidatesTable.dataSource = self
        self.view.addSubview(candidatesTable)
    }
    
    func exitCandidatesTable() {
        isShowingCandidatesTable = false
        candidatesBanner!.scrollToFirstCandidate()
        candidatesBanner!.unhideTypingAndCandidatesView()
        candidatesBanner!.changeArrowDown()
        candidatesTable.removeFromSuperview()
    }
    
    
    //------------emoji view
    var emojiView : AGEmojiKeyboardView!
    
    func showEmojiView() {

        let r = CGRect(x: view.frame.origin.x, y: view.frame.origin.y + getBannerHeight(), width: view.frame.width, height: view.frame.height - getBannerHeight())
        emojiView = AGEmojiKeyboardView(frame: r, dataSource: self)
        emojiView.delegate = self
        emojiView.backgroundColor = UIColor.whiteColor()
        emojiView.autoresizingMask = .FlexibleHeight
        emojiView.pageControl.pageIndicatorTintColor = UIColor.grayColor()
        emojiView.pageControl.currentPageIndicatorTintColor = UIColor.darkGrayColor()
        self.view.addSubview(emojiView)
        self.isShowEmojiView = true
        
        
        
    }
    
    func exitEmojiView() {
        
        self.isShowEmojiView = false
        emojiView.removeFromSuperview()
        
    }
   
    
    func emojiKeyBoardView(emojiKeyBoardView: AGEmojiKeyboardView!, didUseEmoji emoji: String!) {
        
        self.textDocumentProxy.insertText(emoji)
        
    }
    
    func emojiKeyBoardViewDidPressBackSpace(emojiKeyBoardView: AGEmojiKeyboardView!) {
        
        self.textDocumentProxy.deleteBackward()
        
    }
    
    
    func emojiKeyboardView(emojiKeyboardView: AGEmojiKeyboardView!, imageForSelectedCategory category: AGEmojiKeyboardViewCategoryImage) -> UIImage! {
        
        var imgName: String = ""
        
        if category == .Recent {
            
            imgName = "emoji_tab0Press"
            
        }else if category == .Face{
            
            imgName = "emoji_tab1Press"
            
        }else if category == .Bell{
            
            imgName = "emoji_tab2Press"
            
        }else if category == .Flower{
            
            imgName = "emoji_tab3Press"
            
        }else if category == .Car {
            
            imgName = "emoji_tab4Press"
            
        }else if category == .Characters{
            
            imgName = "emoji_tab5Press"
            
        }
        
        return UIImage(named: imgName)
        
    }
   
    func emojiKeyboardView(emojiKeyboardView: AGEmojiKeyboardView!, imageForNonSelectedCategory category: AGEmojiKeyboardViewCategoryImage) -> UIImage! {
         var imgName: String = ""
        
        if category == .Recent {
            
            imgName = "emoji_tab0"
            
        }else if category == .Face{
            
            imgName = "emoji_tab1"
            
        }else if category == .Bell{
            
            imgName = "emoji_tab2"
            
        }else if category == .Flower{
            
            imgName = "emoji_tab3"
            
        }else if category == .Car {
            
            imgName = "emoji_tab4"
            
        }else if category == .Characters{
            
            imgName = "emoji_tab5"
            
        }
        
        return UIImage(named: imgName)       
    }
    
    func backSpaceButtonImageForEmojiKeyboardView(emojiKeyboardView: AGEmojiKeyboardView!) -> UIImage! {
        
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (self.candidateList?.count)!
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        
        var cell = tableView.dequeueReusableCellWithIdentifier("textCell")
        if cell == nil {
            cell = CandidateTableCellTableViewCell(style: .Default, reuseIdentifier: "textCell")
        }
        
        let c: CandidateTableCellTableViewCell = cell as! CandidateTableCellTableViewCell
        let candidate = self.candidateList[indexPath.row]
        c.txtLabel?.text = candidate.text
        
        return cell!
        
        
        
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        let s = self.candidateList![indexPath.row]
        
        if s.textSize == nil {
            s.textSize = CandidateCell.getCellSizeByText(s.text, needAccuracy: indexPath == indexPathZero ? true : false)
        }
        return s.textSize!.width
        
       
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        

        self.selectText(indexPath.row)
        self.candidatesBanner?.scrollToFirstCandidate()
        
    }
    
    
    func selectText(index: NSInteger) -> String? {
        let res = RimeWrapper.selectCandidateForSession(self.rimeSessionId_, inIndex: index)
        if res == false {
            print("选中没有文字了")
            return nil;
        }
        
        let comitText = RimeWrapper.consumeComposedTextForSession(self.rimeSessionId_)
        if (comitText != nil) {
//            self.textDocumentProxy.insertText(comitText)
            self.insertText(comitText)
            self.candidateList.removeAll()
            self.candidatesBanner?.reloadData()
            return comitText;
        }
        
        let cl = RimeWrapper.getCandidateListForSession(self.rimeSessionId_) as? [String]
        
        if (cl == nil) {
            
            self.candidateList.removeAll()
            
        }else{
            
            self.addCandidates(cl!)
            
        }
        
        self.candidatesBanner?.reloadData()
        return nil;
    }
    
    
    
    func getPreeditedText() -> String {
       
        if RimeWrapper.isSessionAlive(rimeSessionId_) == false {
            return "";
        }
        
        let context: XRimeContext = RimeWrapper.contextForSession(rimeSessionId_)
        return context.composition.preeditedText
    }
    

    
    
    func switchInputTouchDown(){
    }
    
    func switchInputTouchUp(){
        
        self.clearInput()
        self.isChineseInput = !self.isChineseInput
        
        self.shiftState = .Locked
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
        RimeWrapper.clearCompositionForSession(self.rimeSessionId_)
       
    }
    
    
    //-----------------------------
    
    func onDeploymentStarted() {
        print("deploy start....")
        dispatch_async(dispatch_get_main_queue()) { 
//            self.showDeployView()
        };
    }
    
    
    func onDeploymentSuccessful() {
        
        print("deploy successful....")
        
        
        dispatch_async(dispatch_get_main_queue()) { 
//            let uf = NSString.userDefaultsInGroup()
//            uf.setObject(NOT_NEED_DEPOLY, forKey: IS_NEED_DEPOLY)
//            self.exitDeployView()
        };
        
       
        
    }
    
    func onDeploymentFailed() {
        
        print("deploy fail....")
        dispatch_async(dispatch_get_main_queue()) { 
//            self.exitDeployView()
        }
    }
    
    func onSchemaChangedWithNewSchema(schema: String!) {
        
        print("deploy change new schema....")
    }
    
    func onOptionChangedWithOption(option: XRimeOption, value: Bool) {
        
        print("deploy chand option....")
    }
    
    
    //--------------------
    
    
    func needDeploy() {
        
//     if RimeWrapper.isSessionAlive(rimeSessionId_) == false {
//        return;
//    }
    
        let uf = NSString .userDefaultsInGroup()
        
        let isNeed = uf.stringForKey(NEED_DEPOLY)
        
        if isNeed == IS_NEED_DEPOLY || isNeed == nil {
            
           
            RimeWrapper.redeployWithFastMode(false)
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

}




