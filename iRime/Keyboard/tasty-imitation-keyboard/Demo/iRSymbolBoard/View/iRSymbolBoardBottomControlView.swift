//
//  iRSymbolBoardBottomControlView.swift
//  iRime
//
//  Created by 王宇 on 2017/7/18.
//  Copyright © 2017年 jimmy54. All rights reserved.
//  底部控制条view

import UIKit
@objc protocol iRSymbolBoardBottomControlViewProtocol:NSObjectProtocol {
    func deleteOneFor_iRSymbolBoardBottomControlView() -> Void
    func hidSymbolBoard() -> Void
}
class iRSymbolBoardBottomControlView: UIView {

    
    weak var delegateCallBack:iRSymbolBoardBottomControlViewProtocol?
    var timer:Timer? = nil
    let timeRepeat:TimeInterval = 0.2
    
    
    var btnBack:UIButton = {()->UIButton in
        let btn = UIButton.init()
        btn.setTitle("返回", for: .normal)
        btn.setTitleColor(RGB(r: 50, g: 50, b: 50), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(btnBackAction), for: .touchUpInside)
        return btn
    }()
    
    var btnDelete:UIButton = {()-> UIButton in
        let btn = UIButton.init()
        btn.setImage(UIImage.init(named: "expression_delete"), for: .normal)
        btn.addTarget(self, action:#selector(btnDeleteStartAction), for: .touchDown)
        btn.addTarget(self, action:#selector(btnDeleteEndAction) , for: .touchUpInside)
        btn.addTarget(self, action:#selector(btnDeleteEndAction) , for: .touchCancel)
        
        btn.addTarget(self, action:#selector(btnDeleteEndAction) , for: .touchDragExit)
        btn.addTarget(self, action:#selector(btnDeleteEndAction) , for: .touchDragEnter)
        return btn
    
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.gray
        self.createSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubViews() -> Void
    {
        //1.返回按钮
        self.addSubview(btnBack)
        //--约束布局
        btnBack.mas_makeConstraints { (make:MASConstraintMaker!) in
            make.left.equalTo()(self)?.offset()(15)
            make.height.equalTo()(self)
            make.width.mas_equalTo()(40)
            make.top.equalTo()(self)
        }
        
        //2.删除按钮
        self.addSubview(btnDelete)
        //--约束布局
        btnDelete.mas_makeConstraints { (make:MASConstraintMaker!) in
            make.right.equalTo()(self)?.offset()(-15)
            make.height.equalTo()(self)
            make.width.mas_equalTo()(40)
            make.top.equalTo()(self)
        }
    }
    func btnBackAction() -> Void
    {
        if (self.delegateCallBack?.responds(to: #selector(iRSymbolBoardBottomControlViewProtocol.hidSymbolBoard)))!
        {
            self.delegateCallBack?.hidSymbolBoard()
        }

    }
    
    func btnDeleteStartAction() -> Void {
        self.timer = Timer.scheduledTimer(timeInterval: timeRepeat, target: self, selector: #selector(btnDeleteRepeatAction), userInfo: nil, repeats: true)
        self.timer?.fire()
    }
    func btnDeleteEndAction() -> Void {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    
    func btnDeleteRepeatAction() -> Void
    {
        if (self.delegateCallBack?.responds(to: #selector(iRSymbolBoardBottomControlViewProtocol.deleteOneFor_iRSymbolBoardBottomControlView)))!
        {
            self.delegateCallBack?.deleteOneFor_iRSymbolBoardBottomControlView()
        }

    }
}
