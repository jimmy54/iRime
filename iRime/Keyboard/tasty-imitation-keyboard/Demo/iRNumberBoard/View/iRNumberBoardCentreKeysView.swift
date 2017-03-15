//
//  iRNumberBoardCentreKeysView.swift
//  iRime
//
//  Created by 王宇 on 2017/3/5.
//  Copyright © 2017年 jimmy54. All rights reserved.
//

import UIKit


extension UIImage{
    
   class  func imageWithColor(color:UIColor) -> UIImage {
        let rect:CGRect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        
        UIGraphicsBeginImageContext(rect.size);
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return image;
    }
    
}

public protocol iRNumberBoardCentreKeysViewvProtocol: NSObjectProtocol {
    func callBackOfCentreToPassText(text:String) -> Void
    func callBackOfCentreToHiddenNumberKeyBoard() -> Void
}



class iRNumberBoardCentreKeysBtn: UIButton {
    
    var viewBottomLine:UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        let backColor = UIColor.whiteColor();//UIColor.init(red: 204.0/255.0, green: 210.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        self.backgroundColor = backColor;
        self.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.setBackgroundImage(UIImage.imageWithColor(UIColor.lightGrayColor()), forState: .Highlighted)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setItemTitle(i:Int) -> Void {
        if i == 9 {
            self.setTitle("返回", forState: .Normal)
        }
        else if i == 10
        {
            self.setTitle("0", forState: .Normal)
        }
        else if i == 11
        {
            self.setTitle(".", forState: .Normal)
        }
        else
        {
            self.setTitle("\(i+1)", forState: .Normal)
        }
    }

    
}

class iRNumberBoardCentreKeysView: UIView {
    
    var lastBtnItem:iRNumberBoardCentreKeysBtn? = nil
    var lastLineFirstItem:iRNumberBoardCentreKeysBtn? = nil
    var arrayBtnItems:[iRNumberBoardCentreKeysBtn]? = [iRNumberBoardCentreKeysBtn]();
    var delegateAction:iRNumberBoardCentreKeysViewvProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func createSubViews() -> Void {
        for i:Int in 0 ..< 12  {
            let btnItem:iRNumberBoardCentreKeysBtn = iRNumberBoardCentreKeysBtn.init(frame: CGRectNull)
            self .addSubview(btnItem)
            btnItem.tag = i
            btnItem.addTarget(self, action: #selector(iRNumberBoardCentreKeysView.btnItemAction(_:)), forControlEvents: .TouchUpInside)
            arrayBtnItems?.append(btnItem)
            if i == 0 {
                btnItem.mas_makeConstraints({ (maker:MASConstraintMaker!) in
                    maker.left.equalTo()(self)
                    maker.top.equalTo()(self)
                    maker.width.equalTo()(self.mas_width).multipliedBy()(1.0/3.0)
                    maker.height.equalTo()(self.mas_height).multipliedBy()(1.0/4.0)
                })
            }
            else if i%3==0{
                btnItem.mas_makeConstraints({ (maker:MASConstraintMaker!) in
                    maker.left.equalTo()(self)
                    maker.top.equalTo()(self.lastLineFirstItem!.mas_bottom)
                    maker.width.equalTo()(self.mas_width).multipliedBy()(1.0/3.0)
                    maker.height.equalTo()(self.mas_height).multipliedBy()(1.0/4.0)
               })
            }
            else{
                btnItem.mas_makeConstraints({ (maker:MASConstraintMaker!) in
                    maker.left.equalTo()(self.lastBtnItem!.mas_right)
                    maker.top.equalTo()(self.lastBtnItem!)
                    maker.width.equalTo()(self.mas_width).multipliedBy()(1.0/3.0)
                    maker.height.equalTo()(self.mas_height).multipliedBy()(1.0/4.0)
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
        let viewLine:UIView = UIView.init(frame: CGRectNull)
        //--属性设置
        viewLine.backgroundColor =  UIColor.init(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0)
        return viewLine;
        
    }
    
    func btnItemAction(btn:UIButton) -> Void {
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












































