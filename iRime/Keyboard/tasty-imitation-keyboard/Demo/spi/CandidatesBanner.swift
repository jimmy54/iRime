
import UIKit



let darkModeBannerColor = UIColor(red: 89, green: 92, blue: 95, alpha: 0.2)
let lightModeBannerColor = UIColor.whiteColor()
let darkModeBannerBorderColor = UIColor(white: 0.3, alpha: 1)
let lightModeBannerBorderColor = UIColor(white: 0.6, alpha: 1)

let extraLineTypingTextFont = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)


let typingAndCandidatesViewHeightWhenShowTypingCellInExtraLineIsTrue = 28 as CGFloat
let bannerHeightWhenShowTypingCellInExtraLineIsTrue = 50 as CGFloat

let typingAndCandidatesViewHeightWhenShowTypingCellInExtraLineIsFalse = 35 as CGFloat
let bannerHeightWhenShowTypingCellInExtraLineIsFalse = 64 as CGFloat

let candidatesTableCellHeight = 35 as CGFloat
let preeLabelHeight = 20 as CGFloat
let moreCandidateBtnHeight = 44 as CGFloat
let moreCandidateBtnWidth = 64 as CGFloat


func getBannerHeight() -> CGFloat {
    return showTypingCellInExtraLine ? bannerHeightWhenShowTypingCellInExtraLineIsTrue : bannerHeightWhenShowTypingCellInExtraLineIsFalse
}





class CandidatesBanner: ExtraView {
    
    var typingLabel: TypingLabel?
    var collectionViewLayout: MyCollectionViewFlowLayout
    var collectionView: UITableView
    var moreCandidatesButton: UIButton
    var preeLable:UILabel
    var hasInitAppearance = false
    
    var preeText: String?
    let toolsView: ToolsView

    weak var delegate: protocol<UITableViewDataSource, UITableViewDelegate>! {
        didSet {
            collectionView.dataSource = delegate
            collectionView.delegate = delegate
            configureSubviews()
        }
    }
    
    required init(globalColors: GlobalColors.Type?, darkMode: Bool, solidColorMode: Bool) {

        // Below part should be same as func initSubviews()
        
        if showTypingCellInExtraLine == true {
            typingLabel = TypingLabel()
        } else {
            typingLabel = nil
        }
        
        collectionViewLayout = MyCollectionViewFlowLayout()

        collectionView = UITableView(frame: CGRectZero, style: .Plain)
//        collectionView.backgroundColor = UIColor.blueColor()
        let rot: CGFloat = CGFloat(-M_PI / 2)
        collectionView.transform = CGAffineTransformMakeRotation(rot)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.separatorStyle = .None
 
        moreCandidatesButton = UIButton(type: .Custom)
        moreCandidatesButton.addTarget(delegate, action: #selector(Catboard.toggleCandidatesTableOrDismissKeyboard), forControlEvents: .TouchUpInside)
        
        preeLable = UILabel(frame:CGRectZero)
        
        toolsView = ToolsView(frame: CGRectZero)
        
        

        
        // Above part should be same as func initSubviews()
        
        super.init(globalColors: globalColors, darkMode: darkMode, solidColorMode: solidColorMode)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetSubviewsWithInitAndSetDelegate() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        initSubviews()
        // Call delegate's didSet()
        let delegate = self.delegate
        self.delegate = delegate
    }
    
    func initSubviews() {
        if showTypingCellInExtraLine == true {
            typingLabel = TypingLabel()
        } else {
            typingLabel = nil
        }
        
        collectionViewLayout = MyCollectionViewFlowLayout()
        
        collectionView = UITableView(frame: CGRectZero, style: .Plain)
        collectionView.backgroundColor = UIColor.clearColor()
        let rot: CGFloat = CGFloat(-M_PI / 2)
        collectionView.transform = CGAffineTransformMakeRotation(rot)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.separatorStyle = .None
        
        
       
        moreCandidatesButton = UIButton(type: .Custom)
        moreCandidatesButton.addTarget(delegate, action: #selector(Catboard.toggleCandidatesTableOrDismissKeyboard), forControlEvents: .TouchUpInside)
    }
    
    func configureSubviews() {
        
        addSubview(preeLable)
        addSubview(collectionView)
        addSubview(moreCandidatesButton)
        addSubview(toolsView)
        
        addAllViewConstraints()
        
        initAppearance()
    }
    
    func addAllViewConstraints() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        moreCandidatesButton.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        preeLable.translatesAutoresizingMaskIntoConstraints = false
        toolsView.translatesAutoresizingMaskIntoConstraints = false

        
//        self.snp_removeConstraints()
//        preeLable.snp_removeConstraints()
//        collectionView.snp_removeConstraints()
//        moreCandidatesButton.snp_removeConstraints()
//        toolsView.snp_removeConstraints()
        
        
        self.mas_remakeConstraints { (make: MASConstraintMaker!) in
            
        }
        
        
        preeLable.mas_remakeConstraints { (make: MASConstraintMaker!) in
            
        }
        
        collectionView.mas_remakeConstraints { (make: MASConstraintMaker!) in
            
        }
        
        moreCandidatesButton.mas_remakeConstraints { (make: MASConstraintMaker!) in
            
        }
        
        
        toolsView.mas_remakeConstraints { (make: MASConstraintMaker!) in
            
        }
        
        

        
        
        let actualScreenWidth = (UIScreen.mainScreen().nativeBounds.size.width / UIScreen.mainScreen().nativeScale)
        let actualScreenHeight = (UIScreen.mainScreen().nativeBounds.size.height / UIScreen.mainScreen().nativeScale)
        

        
        var screenHeight = actualScreenWidth
        switch((self.delegate as! Catboard).interfaceOrientation) {    // FIXME delegate should not be casted.
        case .Unknown, .Portrait, .PortraitUpsideDown:
            
            
//            self.snp_makeConstraints(closure: { (make) in
//                make.width.equalTo(actualScreenWidth)
//            })
            
            
            self.mas_makeConstraints({ (make: MASConstraintMaker!) in
                make.width.setOffset(actualScreenWidth)
            })
            
            screenHeight = actualScreenWidth
        case .LandscapeLeft, .LandscapeRight:

            
//            self.snp_makeConstraints(closure: { (make) in
//                make.width.equalTo(actualScreenHeight)
//            })
//            
            
            self.mas_makeConstraints({ (make:MASConstraintMaker!) in
                make.width.setOffset(actualScreenHeight)
            })
            
            
            screenHeight = actualScreenHeight
        }
    
        
        let bannerHeight = getBannerHeight()
        let tableViewHeight = bannerHeight - preeLabelHeight
        let he = screenHeight - moreCandidateBtnWidth
        let tableOff = he / 2 - moreCandidateBtnWidth / 2
        
        
        preeLable.frame = CGRectMake(0, 0, screenHeight, preeLabelHeight)
        
//        
//        self.snp_makeConstraints { (make) in
//            make.height.equalTo(bannerHeight)
//        }
        
        self.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.height.setOffset(bannerHeight)
        }
        

        
        
//         preeLable.snp_makeConstraints { (make) in
//            make.left.equalTo(0)
//            make.right.equalTo(0)
//            make.top.equalTo(0)
//            make.height.equalTo(preeLabelHeight)
//        }
        
        
        preeLable.mas_makeConstraints { (make:MASConstraintMaker!) in
            make.left.equalTo()(self).setOffset(0)
            make.right.equalTo()(self).setOffset(0)
            make.top.equalTo()(self).setOffset(0)
            make.height.setOffset(preeLabelHeight)
        }

        
//        collectionView.snp_makeConstraints { (make) in
//            make.left.equalTo(tableOff + 10)
//            make.top.equalTo(-tableOff + preeLabelHeight / 2)
//            make.height.equalTo(he)
//            make.width.equalTo(tableViewHeight)
//        }
//        
        
        
        collectionView.mas_makeConstraints { (make:MASConstraintMaker!) in
            make.left.equalTo()(self).setOffset(tableOff + 10)
            make.top.equalTo()(self).setOffset(-tableOff + preeLabelHeight / 2)
            make.height.setOffset(he)
            make.width.setOffset(tableViewHeight)
        }
        
        
        
        
//        toolsView.snp_makeConstraints { (make) in
//            make.edges.equalTo(self).inset(UIEdgeInsetsMake(preeLabelHeight, 0, 0, moreCandidateBtnWidth))
//        }
        
        toolsView.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.edges.equalTo()(self).setInsets(UIEdgeInsetsMake(preeLabelHeight, 0, 0, moreCandidateBtnWidth))
        }
        
//        moreCandidatesButton.snp_makeConstraints { (make) in
//            make.right.equalTo(0)
//            make.bottom.equalTo(0)
//            make.width.equalTo(moreCandidateBtnWidth)
//            make.height.equalTo(moreCandidateBtnHeight)
//        }
        
        
        moreCandidatesButton.mas_makeConstraints { (make: MASConstraintMaker!) in
            make.right.equalTo()(self).setOffset(0)
            make.bottom.equalTo()(self).setOffset(0)
            make.width.setOffset(moreCandidateBtnWidth)
            make.height.setOffset(moreCandidateBtnHeight)
        }
        
        
    }
    
    
    func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        addAllViewConstraints()
    }
    
    
    func scrollToFirstCandidate() {
        collectionView.setContentOffset(CGPointMake(0, 0), animated: true)
   }
    
    func resetLayoutWithAllCellSize(sizes: [CGSize]) {
        collectionViewLayout.resetLayoutWithAllCellSize(sizes)
    }
    
    func updateCellAt(cellIndex: NSIndexPath, withCellSize size: CGSize) {
        collectionViewLayout.updateLayoutRaisedByCellAt(cellIndex, withCellSize: size)
//        collectionView.reloadItemsAtIndexPaths([cellIndex])
    }
    
    func reloadData() {
        
        let cb: Catboard = delegate as! Catboard
        if let typingLabel = typingLabel {
            
            print("typinglabel is true")
            var i = 0
            var text: String = ""
            for t in cb.candidateList! {
                
                text = text.stringByAppendingString(t.text)
                if i > 7 {
                    break
                }
                i += 1
                
                
            }
            typingLabel.text = text
        }
        
        
        self.preeLable.text = cb.getPreeditedText()
        collectionView.reloadData()
        
        
        if collectionView.numberOfRowsInSection(0) <= 0{
            toolsView.hidden = false
        }else{
            toolsView.hidden = true
        }
        
    }
    
    func setCollectionViewFrame(frame: CGRect) {
        collectionView.frame = frame
    }
    
    func initAppearance() {
        var needUpdateAppearance = false
        if hasInitAppearance == false {
            needUpdateAppearance = true
        }
        
        hasInitAppearance = true
        
        if let typingLabel = typingLabel {
            typingLabel.font = extraLineTypingTextFont
            typingLabel.backgroundColor = UIColor.clearColor()
        }

        moreCandidatesButton.backgroundColor = UIColor.clearColor()
        
        moreCandidatesButton.layer.shadowColor = UIColor.blackColor().CGColor
        moreCandidatesButton.layer.shadowOffset = CGSizeMake(-2.0, 0.0)
        
        collectionView.separatorInset = UIEdgeInsetsZero
        
        
        
        collectionView.backgroundColor = UIColor.clearColor()
        toolsView.backgroundColor = UIColor.clearColor()
        toolsView.frame = collectionView.frame
//        moreCandidatesButton.backgroundColor = UIColor.redColor()
//        self.backgroundColor = UIColor.greenColor()
//        preeLable.backgroundColor = UIColor.brownColor()
        
        if needUpdateAppearance == true {
            updateAppearance()
        }
    }
    
     func updateAppearance() {
        if hasInitAppearance == false {
            initAppearance()
        }
        
        updateSeparatorBars()
        
        typingLabel?.updateAppearance()
        
        collectionView.separatorColor = candidatesBannerAppearanceIsDark ? darkModeBannerBorderColor : lightModeBannerBorderColor
        self.backgroundColor = candidatesBannerAppearanceIsDark ? darkModeBannerColor : UIColor.whiteColor()

        moreCandidatesButton.setImage(candidatesBannerAppearanceIsDark ? UIImage(named: "arrow-down-white") : UIImage(named: "arrow-down-black"), forState: .Normal)
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = candidatesBannerAppearanceIsDark ? darkModeBannerBorderColor.CGColor : lightModeBannerBorderColor.CGColor
        
        moreCandidatesButton.layer.shadowOpacity = 0.2
        
        preeLable.layer.borderWidth = 0.5
        preeLable.layer.borderColor = candidatesBannerAppearanceIsDark ? darkModeBannerBorderColor.CGColor : lightModeBannerBorderColor.CGColor
    }
    
    var separatorHorizontalBar: CALayer?
    var separatorVerticalBar: CALayer?

    func updateSeparatorBars() {
        removeSeparatorBars()
        addSeparatorBars()
    }
    
    func addSeparatorBars() {
        if separatorVerticalBar == nil {
            separatorVerticalBar = CALayer(layer: moreCandidatesButton.layer)
            
            separatorVerticalBar!.backgroundColor = candidatesBannerAppearanceIsDark ? darkModeBannerBorderColor.CGColor : lightModeBannerBorderColor.CGColor
            
            separatorVerticalBar!.frame = CGRectMake(0, 0, 0.5, moreCandidateBtnHeight)
            if let separatorVerticalBar = separatorVerticalBar {
                moreCandidatesButton.layer.addSublayer(separatorVerticalBar)
            }
        }
        
        if separatorHorizontalBar == nil {
            if showTypingCellInExtraLine == true {
                if let typingLabel = typingLabel {
                    if separatorHorizontalBar != nil {
                        separatorHorizontalBar!.removeFromSuperlayer()
                    }
                    separatorHorizontalBar = CALayer(layer: self.layer)
                    separatorHorizontalBar!.backgroundColor = candidatesBannerAppearanceIsDark ? darkModeBannerBorderColor.CGColor : lightModeBannerBorderColor.CGColor
                    separatorHorizontalBar!.frame = CGRectMake(0, CGRectGetHeight(typingLabel.frame), (UIScreen.mainScreen().nativeBounds.size.height / UIScreen.mainScreen().nativeScale), 0.5)
                    self.layer.addSublayer(separatorHorizontalBar!)
                }
            }
        }
    }
    
    func removeSeparatorBars() {
        if separatorVerticalBar != nil {
            separatorVerticalBar!.removeFromSuperlayer()
            separatorVerticalBar = nil
        }
        if separatorHorizontalBar != nil {
            separatorHorizontalBar!.removeFromSuperlayer()
            separatorHorizontalBar = nil
        }
    }
    
    func hideTypingAndCandidatesView() {
        typingLabel?.hidden = true
        collectionView.hidden = true
    }

    func unhideTypingAndCandidatesView() {
        typingLabel?.hidden = false
        collectionView.hidden = false
    }

    func changeArrowUp() {
        moreCandidatesButton.setImage(candidatesBannerAppearanceIsDark ? UIImage(named: "arrow-up-white") : UIImage(named: "arrow-up-black"), forState: .Normal)
    }

    func changeArrowDown() {
        moreCandidatesButton.setImage(candidatesBannerAppearanceIsDark ? UIImage(named: "arrow-down-white") : UIImage(named: "arrow-down-black"), forState: .Normal)
    }
    
}
