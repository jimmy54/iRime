//
//  iRNumberBoardCentreKeysView.swift
//  iRime
//
//  Created by 王宇 on 2017/3/5.
//  Copyright © 2017年 jimmy54. All rights reserved.
//

import UIKit


extension UIImage{
    
   class  func imageWithColor(_ color:UIColor) -> UIImage {
        let rect:CGRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(rect.size);
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor);
        context.fill(rect);
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return image;
    }
    
}

extension NSObject{

   class  func getFitFontForNumberBoard() -> CGFloat {
        
        let width:CGFloat = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        
        if width > 320.0{
            return CGFloat(22.0)
        }
        else
        {
            return CGFloat(20.0)
        }
    }
    
    class func numberBoardFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Heiti TC", size: size)!
    }
   
}

public protocol iRNumberBoardCentreKeysViewvProtocol: NSObjectProtocol {
    func callBackOfCentreToPassText(_ text:String) -> Void
    func callBackOfCentreToHiddenNumberKeyBoard() -> Void
}



class iRNumberBoardCentreKeysBtn: UIButton {
    
    var viewBottomLine:UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        let backColor = UIColor.white;//UIColor.init(red: 204.0/255.0, green: 210.0/255.0, blue: 217.0/255.0, alpha: 1.0)
//        self.titleLabel?.font = UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFontTextStyle.body), size: NSObject.getFitFontForNumberBoard())
        self.titleLabel?.font = NSObject.numberBoardFont(size: NSObject.getFitFontForNumberBoard())
        self.backgroundColor = backColor;
        self.setTitleColor(UIColor.black, for: UIControlState())
        self.setBackgroundImage(UIImage.imageWithColor(UIColor.lightGray), for: .highlighted)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setItemTitle(_ i:Int) -> Void {
        if i == 9 {
            self.setTitle("返回", for: UIControlState())
        }
        else if i == 10
        {
            self.setTitle("0", for: UIControlState())
        }
        else if i == 11
        {
            self.setTitle(".", for: UIControlState())
        }
        else
        {
            self.setTitle("\(i+1)", for: UIControlState())
        }
    }

    
}

class iRNumberBoardCentreKeysView: UIView {
    
    var lastBtnItem:iRNumberBoardCentreKeysBtn? = nil
    var lastLineFirstItem:iRNumberBoardCentreKeysBtn? = nil
    var arrayBtnItems:[iRNumberBoardCentreKeysBtn]? = [iRNumberBoardCentreKeysBtn]();
    weak var delegateAction:iRNumberBoardCentreKeysViewvProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func createSubViews() -> Void {
        for i:Int in 0 ..< 12  {
            let btnItem:iRNumberBoardCentreKeysBtn = iRNumberBoardCentreKeysBtn.init(frame: CGRect.null)
            self .addSubview(btnItem)
            btnItem.tag = i
            btnItem.addTarget(self, action: #selector(iRNumberBoardCentreKeysView.btnItemAction(_:)), for: .touchUpInside)
            arrayBtnItems?.append(btnItem)
            if i == 0 {
                btnItem.mas_makeConstraints({ (maker:MASConstraintMaker!) in
                    maker.left.equalTo()(self)
                    maker.top.equalTo()(self)
                    maker.width.equalTo()(self.mas_width)?.multipliedBy()(1.0/3.0)
                    maker.height.equalTo()(self.mas_height)?.multipliedBy()(1.0/4.0)
                })
            }
            else if i%3==0{
                btnItem.mas_makeConstraints({ (maker:MASConstraintMaker!) in
                    maker.left.equalTo()(self)
                    maker.top.equalTo()(self.lastLineFirstItem!.mas_bottom)
                    maker.width.equalTo()(self.mas_width)?.multipliedBy()(1.0/3.0)
                    maker.height.equalTo()(self.mas_height)?.multipliedBy()(1.0/4.0)
               })
            }
            else{
                btnItem.mas_makeConstraints({ (maker:MASConstraintMaker!) in
                    maker.left.equalTo()(self.lastBtnItem!.mas_right)
                    maker.top.equalTo()(self.lastBtnItem!)
                    maker.width.equalTo()(self.mas_width)?.multipliedBy()(1.0/3.0)
                    maker.height.equalTo()(self.mas_height)?.multipliedBy()(1.0/4.0)
                })

            }
            if i%3 == 0 {
                self.lastLineFirstItem = btnItem
            }
            self.lastBtnItem = btnItem
            btnItem.setItemTitle(i)
        }//for i in 0 ..< 12
        //1.横向分割线view _1
        let viewLineHorizontal_1:UIView = self.getLineView()
        self .addSubview(viewLineHorizontal_1)
        //--属性设置
        //--约束布局
        viewLineHorizontal_1.mas_makeConstraints { (maker:MASConstraintMaker!) in
            maker.left.equalTo()(self)
            maker.right.equalTo()(self)
            maker.height.mas_equalTo()(0.5)
            maker.bottom.equalTo()(self.arrayBtnItems?.first?.mas_bottom)
        }
        //2.横向分割线view _2
        let viewLineHorizontal_2:UIView = self.getLineView()
        self .addSubview(viewLineHorizontal_2)
        //--属性设置
        //--约束布局
        viewLineHorizontal_2.mas_makeConstraints { (maker:MASConstraintMaker!) in
            maker.left.equalTo()(self)
            maker.right.equalTo()(self)
            maker.height.mas_equalTo()(0.5)
            maker.bottom.equalTo()(self.arrayBtnItems?[3].mas_bottom)
        }
        //3.横向分割线view _3
        let viewLineHorizontal_3:UIView = self.getLineView()
        self .addSubview(viewLineHorizontal_3)
        //--属性设置
        //--约束布局
        viewLineHorizontal_3.mas_makeConstraints { (maker:MASConstraintMaker!) in
            maker.left.equalTo()(self)
            maker.right.equalTo()(self)
            maker.height.mas_equalTo()(0.5)
            maker.bottom.equalTo()(self.arrayBtnItems?[6].mas_bottom)
        }
        //4.竖向的分割线view _1
        let viewLineVertical_1:UIView = self.getLineView()
        self .addSubview(viewLineVertical_1)
        //--属性设置
        //--约束布局
        viewLineVertical_1.mas_makeConstraints { (maker:MASConstraintMaker!) in
            maker.top.equalTo()(self)
            maker.bottom.equalTo()(self)
            maker.width.mas_equalTo()(0.5)
            maker.left.equalTo()(self.arrayBtnItems?[0].mas_right)
        }
        //5.竖向的分割线view _2
        let viewLineVertical_2:UIView = self.getLineView()
        self .addSubview(viewLineVertical_2)
        //--属性设置
        //--约束布局
        viewLineVertical_2.mas_makeConstraints { (maker:MASConstraintMaker!) in
            maker.top.equalTo()(self)
            maker.bottom.equalTo()(self)
            maker.width.mas_equalTo()(0.5)
            maker.left.equalTo()(self.arrayBtnItems?[1].mas_right)
        }
    }
    
    func getLineView() -> UIView {
        let viewLine:UIView = UIView.init(frame: CGRect.null)
        //--属性设置
        viewLine.backgroundColor =  UIColor.init(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)
        return viewLine;
        
    }
    
    func btnItemAction(_ btn:UIButton) -> Void {
        if btn.tag == 9 {
            if self.delegateAction != nil {
                self.delegateAction?.callBackOfCentreToHiddenNumberKeyBoard()
            }
        }
        else
        {
            if self.delegateAction != nil{
                self.delegateAction?.callBackOfCentreToPassText((btn.titleLabel?.text)!)
            }
        }
    }
    
}












































