//
//  iRSymbolBoardLeftControlViewCell.swift
//  iRime
//
//  Created by 王宇 on 2017/7/22.
//  Copyright © 2017年 jimmy54. All rights reserved.
//

import UIKit

class iRSymbolBoardLeftControlViewCell: UITableViewCell {

    
    var modelSymbolItem:iRsymbolsItemModel?
    {
       didSet
       {
            labTitle.text = modelSymbolItem?.name
        
            if (modelSymbolItem?.isSelected)! {
                labTitle.backgroundColor = UIColor.white
                viewLineBottom.isHidden = true
            }
            else
            {
                labTitle.backgroundColor = RGB(r: 174, g: 183, b: 196)
                viewLineBottom.isHidden = false
            }
       }
    }
    

    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        createSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubViews() -> Void {
        //2.底部分割线
        self.contentView.addSubview(viewLineBottom)
        //--约束布局
        viewLineBottom.mas_makeConstraints { (maker:MASConstraintMaker!) in
            maker.left.right().equalTo()(self.contentView)
            maker.bottom.equalTo()(self.contentView)
            maker.height.mas_equalTo()(onePixel())
        }
        //1.labTitle 文字
        self.contentView.addSubview(labTitle)
        //--约束布局
        labTitle.mas_makeConstraints { (maker:MASConstraintMaker!) in
            maker.left.right().equalTo()(self.contentView)
            maker.top.equalTo()(self.contentView)
            maker.bottom.equalTo()(self.viewLineBottom.mas_top)
        }
       
    }
    
    //MARK: 属性懒加载
    lazy var labTitle:UILabel = {() -> UILabel in
        let labTitle:UILabel = UILabel.init()
        labTitle.font = UIFont.systemFont(ofSize: 20)
        labTitle.textAlignment = .center
        return labTitle
    }()
    
    lazy var viewLineBottom = { () -> UIView in 
        let viewLineBottom = UIView.init(frame: CGRect.null)
        viewLineBottom.backgroundColor = RGB(r: 150, g: 150, b: 150)
        return viewLineBottom;
    }()
    
}
