//
//  DiamondKeyboardView.swift
//  iRime
//
//  Created by hanbing on 2017/3/16.
//  Copyright © 2017年 jimmy54. All rights reserved.
//

import UIKit


class DiamondKeyboardView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.redColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    let iRimeItem: UIButton = UIButton(type: .Custom)
}
