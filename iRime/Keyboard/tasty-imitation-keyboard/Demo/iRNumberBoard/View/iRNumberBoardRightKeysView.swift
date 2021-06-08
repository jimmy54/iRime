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
      var last:MASViewAttribute? = nil
      let layout:[NSDictionary] = [
        ["title": "BackSpace", "action": #selector(iRNumberBoardRightKeysView.btnOneStartAction(_:))],
        ["title": "空格", "action": #selector(iRNumberBoardRightKeysView.btnTwoStartAction(_:))],
        ["title": "@", "action": #selector(iRNumberBoardRightKeysView.btnThreeAction(_:))],
        ["title": "换行", "action": #selector(iRNumberBoardRightKeysView.btnFourAction(_:))]
      ]

      for key in layout {
        let iBtn:iRNumberBoardLeftKeysBtn = iRNumberBoardLeftKeysBtn.init(frame: CGRect.null)

        self.addSubview(iBtn)

        iBtn.addTarget(self, action:key["action"] as! Selector, for: .touchDown)

        iBtn.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnEndAction(_:)) , for: .touchUpInside)
        iBtn.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnEndAction(_:)) , for: .touchCancel)
        iBtn.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnEndAction(_:)) , for: .touchDragExit)
        iBtn.addTarget(self, action:#selector(iRNumberBoardRightKeysView.btnEndAction(_:)) , for: .touchDragEnter)

        if let title = key["title"] as? String {
          if title == "BackSpace" {
            iBtn.setImage(UIImage.init(named: "expression_delete"), for: UIControlState())
            iBtn.setImage(UIImage.init(named: "filter_delete"), for: .highlighted)
          } else {
            iBtn.setTitle(title, for: UIControlState())
          }
        }

        //--约束布局
        iBtn.mas_makeConstraints({ (maker:MASConstraintMaker!) in
            maker.left.equalTo()(self)
            maker.top.equalTo()(last == nil ? self : last)
            maker.right.equalTo()(self)
            maker.height.equalTo()(self.mas_height)?.multipliedBy()(1.0/4.0)
        })

        last = iBtn.mas_bottom
      }
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
