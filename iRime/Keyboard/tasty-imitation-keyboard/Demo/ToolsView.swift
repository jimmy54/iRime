//
//  ToolsView.swift
//  iRime
//
//  Created by jimmy54 on 9/6/16.
//  Copyright © 2016 jimmy54. All rights reserved.
//

import UIKit

typealias tapToolsItemBock = (_ tapBtn: UIButton, _ tapIndex: Int) -> ()


class ToolItem: NSObject {
    var icon: UIImage?
    
    
    override init() {
        super.init()
        
    }
    
}


class ToolsView: UIView {
    
    
    let iRimeItem: UIButton = UIButton(type: .custom)
    let emojiItem: UIButton = UIButton(type: .custom)
    
    var tapToolsItem: tapToolsItemBock?
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(iRimeItem)
        self.addSubview(emojiItem)
        
        iRimeItem.translatesAutoresizingMaskIntoConstraints = false
        emojiItem.translatesAutoresizingMaskIntoConstraints = false
        
        iRimeItem.setImage(UIImage(named: "KBSkinToolbar_icon_logo"), for: UIControlState())
        
        emojiItem.setImage(UIImage(named: "emoji_tab1"), for: UIControlState())
        
        
  
        iRimeItem.mas_makeConstraints { (make :MASConstraintMaker! ) in
         
            make.top.equalTo()(self)?.setOffset(0)
            make.left.equalTo()(self)?.setOffset(0)
            make.bottom.equalTo()(self)?.setOffset(0)
            make.width.equalTo()(self.mas_width)?.dividedBy()(4)
            
        }
        
        self.emojiItem.mas_makeConstraints { (make) in
            
            make?.left.equalTo()(self.iRimeItem.mas_right)?.setOffset(0)
            make?.top.equalTo()(self)?.setOffset(0)
            make?.bottom.equalTo()(self)?.setOffset(0)
            make?.width.equalTo()(self.mas_width)?.dividedBy()(4)
            
        }
        
        
//        iRimeItem.snp_makeConstraints { (make) in
//            
//            make.top.equalTo(0)
//            make.left.equalTo(0)
//            make.bottom.equalTo(0)
//            make.width.equalTo(self.snp_width).dividedBy(4)
//        }
//        
//        self.emojiItem.snp_makeConstraints { (make) in
//            make.left.equalTo(self.iRimeItem.snp_right).offset(0)
//            make.top.equalTo(0)
//            make.bottom.equalTo(0)
//            make.width.equalTo(self.snp_width).dividedBy(4)
//        }
        
        
        //add event
        iRimeItem.addTarget(self, action: #selector(ToolsView.tapToolsItem(_:)), for: .touchUpInside)
        emojiItem.addTarget(self, action: #selector(ToolsView.tapToolsItem(_:)), for: .touchUpInside)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
       
        
        
    }
    
    
    
    func tapToolsItem(_ btn:UIButton) {
        if self.tapToolsItem == nil {
            return;
        }
        
        var index = 0
        if btn == iRimeItem {
            index = 1
        }else if btn == emojiItem{
            index = 2
        }
        
        
        self.tapToolsItem!(btn, index)
        
        
    }
   
    
}
