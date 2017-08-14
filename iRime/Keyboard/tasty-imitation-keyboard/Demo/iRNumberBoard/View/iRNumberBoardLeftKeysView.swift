//
//  iRNumberBoardLeftKeysView.swift
//  iRime
//
//  Created by 王宇 on 2017/3/2.
//  Copyright © 2017年 jimmy54. All rights reserved.
//



import UIKit

protocol iRNumberBoardLeftKeysViewProtocol:NSObjectProtocol {
    func iRNumberBoardLeftKeysViewPassText(_ text:String) -> Void
}

class iRNumberBoardLeftKeysBtn: UIButton {
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
      let viewBottomLine:UIView = UIView.init(frame: CGRect.null)

      self.addSubview(viewBottomLine)
      //--属性设置
      viewBottomLine.backgroundColor = UIColor.init(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)
      //--约束布局
      viewBottomLine.mas_makeConstraints({ (maker:MASConstraintMaker!) in
        maker.left.equalTo()(self)
        maker.bottom.equalTo()(self)
        maker.right.equalTo()(self);
        maker.height.mas_equalTo()(0.5)
      })
    }
}


class iRNumberBoardLeftKeysView: UIView {
    weak var delegateToCallBack:iRNumberBoardLeftKeysViewProtocol? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubVeiws()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func createSubVeiws() -> Void {
      var last:MASViewAttribute? = nil

      for key in ["+", "-", "*" , "/", ":"] {
        let iBtn:iRNumberBoardLeftKeysBtn = iRNumberBoardLeftKeysBtn.init(frame: CGRect.null)
        self.addSubview(iBtn)

        iBtn.addTarget(self, action:#selector(iRNumberBoardLeftKeysView.btnAction(_:)) , for: .touchUpInside)
        iBtn.setTitle(key, for: UIControlState())

        iBtn.mas_makeConstraints({ (maker:MASConstraintMaker!) in
          maker.left.equalTo()(self)
          maker.top.equalTo()(last == nil ? self : last!)
          maker.right.equalTo()(self)
          maker.height.equalTo()(self.mas_height)?.multipliedBy()(1.0/5.0)
        })

        last = iBtn.mas_bottom
      }
    }


    func btnAction(_ btn:iRNumberBoardLeftKeysBtn) -> Void {
        if (self.delegateToCallBack != nil) {
            self.delegateToCallBack?.iRNumberBoardLeftKeysViewPassText((btn.titleLabel?.text)!)
        }
    }
}













































