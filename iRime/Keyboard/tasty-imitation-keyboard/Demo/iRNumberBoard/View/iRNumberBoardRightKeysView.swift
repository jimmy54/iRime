//
//  iRNumberBoardRightKeysView.swift
//  iRime
//
//  Created by 王宇 on 2017/3/5.
//  Copyright © 2017年 jimmy54. All rights reserved.
//

import UIKit



protocol iRNumberBoardRightKeysViewProtocol:NSObjectProtocol {
    func passTextOfIRNumberBoardRightKeysView(text:String) -> Void
    func deleteOneOfIRNumberBoardRightKeysView() -> Void
}

class iRNumberBoardRightKeysBtn: UIButton {
    
    var viewBottomLine:UIView?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let backColor = UIColor.init(red: 204.0/255.0, green: 210.0/255.0, blue: 217.0/255.0, alpha: 1.0)
         self.titleLabel?.font = UIFont(descriptor: UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody), size: NSObject.getFitFontForNumberBoard())
        self.backgroundColor = backColor;
        self.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.setBackgroundImage(UIImage.imageWithColor(UIColor.lightGrayColor()), forState: .Highlighted)
        self.createSubVeiws()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func createSubVeiws() -> Void {
        //1.下部分割线
        viewBottomLine = UIView.init(frame: CGRectNull)
        self .addSubview(viewBottomLine!)
        //--属性设置
        viewBottomLine?.backgroundColor = UIColor.init(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)
        //--约束布局
        viewBottomLine?.mas_makeConstraints({ (maker:MASConstraintMaker!) in
            maker.left.equalTo()(self)
            maker.bottom.equalTo()(self)
            maker.right.equalTo()(self);
            maker.height.mas_equalTo()(0.5)
        })
    }
}

class iRNumberBoardRightKeysView: UIView {

    var btnOne:iRNumberBoardLeftKeysBtn? = nil
    var btnTwo:iRNumberBoardLeftKeysBtn? = nil
    var btnThree:iRNumberBoardLeftKeysBtn? = nil
    var btnFour:iRNumberBoardLeftKeysBtn? = nil
    var delegateAction:iRNumberBoardRightKeysViewProtocol? = nil
    var timer:NSTimer? = nil
    let timeRepeat:NSTimeInterval = 0.2

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubVeiws()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createSubVeiws() -> Void {
        //想了半天,还是傻瓜式创建吧,这个也不会有太大的变动
        //1.第一个btn item
        btnOne = iRNumberBoardLeftKeysBtn.init(frame: CGRectNull)
        self.addSubview(btnOne!)
        //--属性设置
        btnOne?.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnOneStartAction(_:)), forControlEvents: .TouchDown)
        btnOne?.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnEndAction(_:)) , forControlEvents: .TouchUpInside)
        btnOne?.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnEndAction(_:)) , forControlEvents: .TouchUpOutside)
        btnOne?.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnEndAction(_:)) , forControlEvents: .TouchCancel)
        btnOne?.setTitle("退格", forState: .Normal)
        //--约束布局
        btnOne?.mas_makeConstraints({ (maker:MASConstraintMaker!) in
            maker.left.equalTo()(self)
            maker.top.equalTo()(self)
            maker.right.equalTo()(self)
            maker.height.equalTo()(self.mas_height).multipliedBy()(1.0/4.0)
        })
        //2.第二个btn item 空格
        btnTwo = iRNumberBoardLeftKeysBtn.init(frame: CGRectNull)
        self.addSubview(btnTwo!)
        //--属性设置
        btnTwo?.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnTwoStartAction(_:)), forControlEvents: .TouchDown)
        btnTwo?.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnEndAction(_:)) , forControlEvents: .TouchUpInside)
        btnTwo?.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnEndAction(_:)) , forControlEvents: .TouchUpOutside)
        btnTwo?.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnEndAction(_:)) , forControlEvents: .TouchCancel)
        btnTwo?.setTitle("空格", forState: .Normal)
        //--约束布局
        btnTwo?.mas_makeConstraints({ (maker:MASConstraintMaker!) in
            maker.left.equalTo()(self)
            maker.top.equalTo()(self.btnOne!.mas_bottom)
            maker.right.equalTo()(self)
            maker.height.equalTo()(self.mas_height).multipliedBy()(1.0/4.0)
        })
        //3.第三个btn item @
        btnThree = iRNumberBoardLeftKeysBtn.init(frame: CGRectNull)
        self.addSubview(btnThree!)
        //--属性设置
        btnThree?.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnThreeAction(_:)) , forControlEvents: .TouchUpInside)
        btnThree?.setTitle("@", forState: .Normal)
        //--约束布局
        btnThree?.mas_makeConstraints({ (maker:MASConstraintMaker!) in
            maker.left.equalTo()(self)
            maker.top.equalTo()(self.btnTwo!.mas_bottom)
            maker.right.equalTo()(self)
            maker.height.equalTo()(self.mas_height).multipliedBy()(1.0/4.0)
        })
        //4.第四个btn item 换行
        btnFour = iRNumberBoardLeftKeysBtn.init(frame: CGRectNull)
        self.addSubview(btnFour!)
        //--属性设置
        btnFour?.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnFourAction(_:)) , forControlEvents: .TouchUpInside)
        btnFour?.setTitle("换行", forState: .Normal)
        //--约束布局
        btnFour?.mas_makeConstraints({ (maker:MASConstraintMaker!) in
            maker.left.equalTo()(self)
            maker.top.equalTo()(self.btnThree!.mas_bottom)
            maker.right.equalTo()(self)
            maker.height.equalTo()(self.mas_height).multipliedBy()(1.0/4.0)
        })
    }
    
    func btnOneStartAction(btn:iRNumberBoardRightKeysBtn) -> Void {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(timeRepeat, target: self, selector: #selector(iRNumberBoardRightKeysView.repeatBtnOneAction), userInfo: nil, repeats: true)
        self.timer?.fire()
    }
    func btnEndAction(btn:iRNumberBoardRightKeysBtn) -> Void {
        self.timer?.invalidate()
        self.timer = nil
    }
    func repeatBtnOneAction() -> Void {
        
        if self.delegateAction != nil {
            self.delegateAction?.deleteOneOfIRNumberBoardRightKeysView()
        }
        
    }
    func btnTwoStartAction(btn:iRNumberBoardRightKeysBtn) -> Void {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(timeRepeat, target: self, selector: #selector(iRNumberBoardRightKeysView.repeatBtnTwoAction), userInfo: nil, repeats: true)
        self.timer?.fire()
    }
    func repeatBtnTwoAction() -> Void {
        
        if self.delegateAction != nil {
            self.delegateAction?.passTextOfIRNumberBoardRightKeysView(" ")
        }
        
    }
//    func btnTwoAction(btn:iRNumberBoardRightKeysBtn) -> Void {
//        if self.delegateAction != nil {
//           self.delegateAction?.passTextOfIRNumberBoardRightKeysView(" ")
//        }
//    }
    func btnThreeAction(btn:iRNumberBoardRightKeysBtn) -> Void {
        if self.delegateAction != nil {
            self.delegateAction?.passTextOfIRNumberBoardRightKeysView("@")
        }
    }
    func btnFourAction(btn:iRNumberBoardRightKeysBtn) -> Void {
        if self.delegateAction != nil {
            self.delegateAction?.passTextOfIRNumberBoardRightKeysView("\n")
        }
    }

    
}
