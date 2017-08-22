//
//  iRSymbolBoardRightWordsCollectionCell.swift
//  iRime
//
//  Created by 王宇 on 2017/7/27.
//  Copyright © 2017年 jimmy54. All rights reserved.
//

import UIKit

class iRSymbolBoardRightWordsCollectionCell: UICollectionViewCell {
    
    
    var strTitle:String?
    {
        didSet
        {
             labContent.text = strTitle
        }
    }
    
    
    let viewHightLight = { () -> UIView in 
        let view = UIView.init()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    
    let labContent:UILabel = {
        let lab:UILabel = UILabel.init()
        lab.font = UIFont.systemFont(ofSize: 20)
        lab.textAlignment = NSTextAlignment.center
        lab.adjustsFontSizeToFitWidth = true;
        
//        lab.backgroundColor = UIColor.red
        
        return lab
        
    }()
    let viewLineBottom:UIView = {
        
        let view:UIView = UIView.init()
        view.backgroundColor = RGB(r: 150, g: 150, b: 150)
        return view
    
    }()
    
    let viewLineRight:UIView = {
        
        let view:UIView = UIView.init()
        view.backgroundColor = RGB(r: 150, g: 150, b: 150)
        return view
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeStateForSelected(_ isSelected:Bool) -> Void {
        if isSelected {
            viewHightLight.backgroundColor = RGBA(r: 100, g: 100, b: 100, alpha: 0.3)
        }
        else
        {
            viewHightLight.backgroundColor = UIColor.clear
        }
    }
    
    
    func createSubViews() -> Void {
        //1.滴部分割线
        self.contentView.addSubview(viewLineBottom)
        //--约束布局
        viewLineBottom.mas_makeConstraints { (make:MASConstraintMaker!) in
            make.bottom.right().left().equalTo()(self.contentView)
            make.height.mas_equalTo()(onePixel());
        }
        //2.右侧分割线
        self.contentView.addSubview(viewLineRight)
        //--约束布局
        viewLineRight.mas_makeConstraints { (make:MASConstraintMaker!) in
            make.right.bottom().top().equalTo()(self.contentView)
            make.width.mas_equalTo()(onePixel());
        }
        //3.lab
        self.contentView.addSubview(labContent)
        //--约束布局
        labContent.mas_makeConstraints { (make:MASConstraintMaker!) in
            make.top.equalTo()(self.contentView)
            make.left.equalTo()(self)?.offset()(2)
            make.right.equalTo()(self.viewLineRight.mas_left)?.offset()(-2)
            make.bottom.equalTo()(self.viewLineBottom.mas_top)
        }
        
        //4.viewHightLight 高亮view
        self.contentView.addSubview(viewHightLight)
        //--约束布局
        viewHightLight.mas_makeConstraints { (make:MASConstraintMaker!) in
            make.edges.equalTo()(self.contentView)
        }
        
    }
    
    
}









































