//
//  iRNumberBoardFatherView.swift
//  iRime
//
//  Created by 王宇 on 2017/2/28.
//  Copyright © 2017年 jimmy54. All rights reserved.
//

import UIKit

protocol iRNumberBoardFatherViewProtocol:NSObjectProtocol {
    
    func presentTextFromNumberPad(_ text:String) -> Void
    func deleteBackwardOfiRNumberBoardFatherView() -> Void
    func getReturnKeyTitle() -> String
    
}


class iRNumberBoardFatherView: UIView,iRNumberBoardCentreKeysViewvProtocol,iRNumberBoardLeftKeysViewProtocol,iRNumberBoardRightKeysViewProtocol {
    var viewLeftKeys:iRNumberBoardLeftKeysView?
    var viewRightKeys:iRNumberBoardRightKeysView?
    var viewCentreKeys:iRNumberBoardCentreKeysView?
    var delegateAction:iRNumberBoardFatherViewProtocol?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
        self.createSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    func createSubViews() -> Void
    {
       //1.左侧的标点符号view
        viewLeftKeys = iRNumberBoardLeftKeysView.init(frame: CGRect.null)
        self.addSubview(viewLeftKeys!)
        //--属性设置
        viewLeftKeys?.delegateToCallBack = self
        //--约束布局
        viewLeftKeys?.mas_makeConstraints({ (maker:MASConstraintMaker!) in
            maker.left.equalTo()(self)
            maker.top.equalTo()(self)
            maker.bottom.equalTo()(self)
            maker.width.equalTo()(self.mas_width)?.multipliedBy()(1.0/6.0)?.offset()(-5)
        })
       //2.右侧的标点符号view
       viewRightKeys = iRNumberBoardRightKeysView.init(frame: CGRect.null)
       self.addSubview(viewRightKeys!)
        //--属性设置
        viewRightKeys?.delegateAction = self
        //--约束布局
        viewRightKeys?.mas_makeConstraints({ (maker:MASConstraintMaker!) in
            maker.right.equalTo()(self)
            maker.top.equalTo()(self)
            maker.bottom.equalTo()(self)
            maker.width.equalTo()(self.mas_width)?.multipliedBy()(1.0/6.0)?.offset()(-5)
        })
        //3.中间的view
        viewCentreKeys = iRNumberBoardCentreKeysView.init(frame: CGRect.null)
        self.addSubview(viewCentreKeys!)
        //--属性设置
        viewCentreKeys?.delegateAction = self
        viewCentreKeys?.backgroundColor = UIColor.white
        //--约束布局
        viewCentreKeys?.mas_makeConstraints({ (maker:MASConstraintMaker!) in
            maker.top.equalTo()(self)
            maker.left.equalTo()(self.viewLeftKeys!.mas_right)
            maker.right.equalTo()(self.viewRightKeys!.mas_left)
            maker.bottom.equalTo()(self)
        })
    }
    
    func callBackOfCentreToPassText(_ text:String) -> Void
    {
        if self.delegateAction != nil {
            self.delegateAction?.presentTextFromNumberPad(text)
        }
    }
    
    func callBackOfCentreToHiddenNumberKeyBoard() -> Void
    {
        self.isHidden = true
    }
    
    func iRNumberBoardLeftKeysViewPassText(_ text:String) -> Void
    {
        if self.delegateAction != nil {
            self.delegateAction?.presentTextFromNumberPad(text)
        }
    }
    
    func passTextOfIRNumberBoardRightKeysView(_ text:String) -> Void
    {
        if self.delegateAction != nil {
            self.delegateAction?.presentTextFromNumberPad(text)
        }
    }
    func deleteOneOfIRNumberBoardRightKeysView() -> Void
    {
        if self.delegateAction != nil {
            self.delegateAction?.deleteBackwardOfiRNumberBoardFatherView()
        }
    }
    
    override var isHidden: Bool {
        get {
            return super.isHidden
        }
        set(v) {
            super.isHidden = v
            self.updateReturnKeyTitleWhenShow()
        }
    }
    
    func updateReturnKeyTitleWhenShow() -> Void {
        if self.delegateAction != nil {
            let stringTitle:String =  (self.delegateAction?.getReturnKeyTitle())!
            if stringTitle != "返回" {
                viewRightKeys!.btnFour?.setTitle(stringTitle, for: UIControlState())

            }
            
            
        }
    }
    
}


































