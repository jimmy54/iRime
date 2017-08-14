//
//  iRNumberBoardRightKeysView.swift
//  iRime
//
//  Created by 王宇 on 2017/3/5.
//  Copyright © 2017年 jimmy54. All rights reserved.
//

import UIKit



protocol iRNumberBoardRightKeysViewProtocol:NSObjectProtocol {
    func passTextOfIRNumberBoardRightKeysView(_ text:String) -> Void
    func deleteOneOfIRNumberBoardRightKeysView() -> Void
}

class iRNumberBoardRightKeysBtn: UIButton {
    
    var viewBottomLine:UIView?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let backColor = UIColor.init(red: 204.0/255.0, green: 210.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        self.titleLabel?.font = UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.body), size: NSObject.getFitFontForNumberBoard())
        self.backgroundColor = backColor;
        self.setTitleColor(UIColor.black, for: UIControlState())
        self.setBackgroundImage(UIImage.imageWithColor(UIColor.lightGray), for: .highlighted)
        self.createSubVeiws()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func createSubVeiws() -> Void {
        //1.下部分割线
        viewBottomLine = UIView.init(frame: CGRect.null)
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
    weak var delegateAction:iRNumberBoardRightKeysViewProtocol? = nil
    var timer:Timer? = nil
    let timeRepeat:TimeInterval = 0.2

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
        btnOne = iRNumberBoardLeftKeysBtn.init(frame: CGRect.null)
        self.addSubview(btnOne!)
        //--属性设置
        btnOne?.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnOneStartAction(_:)), for: .touchDown)
        btnOne?.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnEndAction(_:)) , for: .touchUpInside)
        btnOne?.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnEndAction(_:)) , for: .touchCancel)
        
        btnOne?.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnEndAction(_:)) , for: .touchDragExit)
        btnOne?.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnEndAction(_:)) , for: .touchDragEnter)
        
        //expression_delete_pressed  filter_delete
        btnOne?.setImage(UIImage.init(named: "expression_delete"), for: UIControlState())
        btnOne?.setImage(UIImage.init(named: "filter_delete"), for: .highlighted)
        //--约束布局
        btnOne?.mas_makeConstraints({ (maker:MASConstraintMaker!) in
            maker.left.equalTo()(self)
            maker.top.equalTo()(self)
            maker.right.equalTo()(self)
            maker.height.equalTo()(self.mas_height)?.multipliedBy()(1.0/4.0)
        })
        //2.第二个btn item 空格
        btnTwo = iRNumberBoardLeftKeysBtn.init(frame: CGRect.null)
        self.addSubview(btnTwo!)
        //--属性设置
        btnTwo?.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnTwoStartAction(_:)), for: .touchDown)
        btnTwo?.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnEndAction(_:)) , for: .touchUpInside)
        btnTwo?.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnEndAction(_:)) , for: .touchCancel)
        
        btnTwo?.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnEndAction(_:)) , for: .touchDragExit)
        btnTwo?.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnEndAction(_:)) , for: .touchDragEnter)

        btnTwo?.setTitle("空格", for: UIControlState())
        //--约束布局
        btnTwo?.mas_makeConstraints({ (maker:MASConstraintMaker!) in
            maker.left.equalTo()(self)
            maker.top.equalTo()(self.btnOne!.mas_bottom)
            maker.right.equalTo()(self)
            maker.height.equalTo()(self.mas_height)?.multipliedBy()(1.0/4.0)
        })
        //3.第三个btn item @
        btnThree = iRNumberBoardLeftKeysBtn.init(frame: CGRect.null)
        self.addSubview(btnThree!)
        //--属性设置
        btnThree?.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnThreeAction(_:)) , for: .touchUpInside)
        btnThree?.setTitle("@", for: UIControlState())
        //--约束布局
        btnThree?.mas_makeConstraints({ (maker:MASConstraintMaker!) in
            maker.left.equalTo()(self)
            maker.top.equalTo()(self.btnTwo!.mas_bottom)
            maker.right.equalTo()(self)
            maker.height.equalTo()(self.mas_height)?.multipliedBy()(1.0/4.0)
        })
        //4.第四个btn item 换行
        btnFour = iRNumberBoardLeftKeysBtn.init(frame: CGRect.null)
        self.addSubview(btnFour!)
        //--属性设置
        btnFour?.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnFourAction(_:)) , for: .touchUpInside)
        btnFour?.setTitle("换行", for: UIControlState())
        //--约束布局
        btnFour?.mas_makeConstraints({ (maker:MASConstraintMaker!) in
            maker.left.equalTo()(self)
            maker.top.equalTo()(self.btnThree!.mas_bottom)
            maker.right.equalTo()(self)
            maker.height.equalTo()(self.mas_height)?.multipliedBy()(1.0/4.0)
        })
    }
    
    func btnOneStartAction(_ btn:iRNumberBoardRightKeysBtn) -> Void {
        self.timer = Timer.scheduledTimer(timeInterval: timeRepeat, target: self, selector: #selector(iRNumberBoardRightKeysView.repeatBtnOneAction), userInfo: nil, repeats: true)
        self.timer?.fire()
    }
    func btnEndAction(_ btn:iRNumberBoardRightKeysBtn) -> Void {
        self.timer?.invalidate()
        self.timer = nil
    }
    func repeatBtnOneAction() -> Void {
        
        if self.delegateAction != nil {
            self.delegateAction?.deleteOneOfIRNumberBoardRightKeysView()
        }
        
    }
    func btnTwoStartAction(_ btn:iRNumberBoardRightKeysBtn) -> Void {
        self.timer = Timer.scheduledTimer(timeInterval: timeRepeat, target: self, selector: #selector(iRNumberBoardRightKeysView.repeatBtnTwoAction), userInfo: nil, repeats: true)
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
    func btnThreeAction(_ btn:iRNumberBoardRightKeysBtn) -> Void {
        if self.delegateAction != nil {
            self.delegateAction?.passTextOfIRNumberBoardRightKeysView("@")
        }
    }
    func btnFourAction(_ btn:iRNumberBoardRightKeysBtn) -> Void {
        if self.delegateAction != nil {
            self.delegateAction?.passTextOfIRNumberBoardRightKeysView("\n")
        }
    }

    
}
