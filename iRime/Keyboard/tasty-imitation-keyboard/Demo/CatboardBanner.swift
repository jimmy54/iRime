//
//  CatboardBanner.swift
//  TastyImitationKeyboard
//
//  Created by Alexei Baboulevitch on 10/5/14.
//  Copyright (c) 2014 Alexei Baboulevitch ("Archagon"). All rights reserved.
//

import UIKit

/*
This is the demo banner. The banner is needed so that the top row popups have somewhere to go. Might as well fill it
with something (or leave it blank if you like.)
*/

typealias selectCandidateStringBlock = (String) -> ()

class CatboardBanner: ExtraView {
   
    var scrollView: UIScrollView = UIScrollView()
    var inputKeyLabel: UILabel = UILabel()
    

    
    
    
    var selectCandidateString: selectCandidateStringBlock?
    
    
    
    required init(globalColors: GlobalColors.Type?, darkMode: Bool, solidColorMode: Bool) {
        super.init(globalColors: globalColors, darkMode: darkMode, solidColorMode: solidColorMode)
       
        self.scrollView.backgroundColor = UIColor.whiteColor()
//        self.inputKeyLabel.backgroundColor = UIColor.brownColor()
        
        
        self.inputKeyLabel.font = UIFont.systemFontOfSize(8.0)
        
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width + 1, self.frame.size.height + 0.5)
        self.addSubview(self.scrollView)
        
        self.addSubview(self.inputKeyLabel)
        
        //add line
        let line: UIView = UIView()
        line.backgroundColor = UIColor.grayColor()
        line.frame = CGRectMake(0, 0, self.frame.size.width, 0.5)
        self.addSubview(line)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        
        let r = self.frame
        let inputKeyLabelHeight:CGFloat = 8.0
        self.inputKeyLabel.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width, inputKeyLabelHeight + 0.5)
        
        self.scrollView.frame = CGRectMake(r.origin.x, r.origin.y + inputKeyLabelHeight, r.size.width, r.size.height - inputKeyLabelHeight)
        self.scrollView.frame = self.frame
        var contentSize: CGSize = self.scrollView.contentSize
        let candidateStringYOffset :CGFloat = 0.0 //偏移
        let candidateStringGap:CGFloat = 5.0 //空隙
        let candidateStringHeight:CGFloat = self.scrollView.frame.height - candidateStringYOffset
        
        
        var candidateStringCurrentPosition:CGFloat = 0.0
        
        
        for view in self.scrollView.subviews {
            
            if view is UIButton == false {
                continue
            }
            //
            let r = view.frame
            
            view.frame = CGRectMake(candidateStringCurrentPosition, candidateStringYOffset, r.size.width + candidateStringGap, candidateStringHeight)
            candidateStringCurrentPosition += view.frame.size.width
            
            if candidateStringCurrentPosition >= contentSize.width {
                
                contentSize = CGSizeMake(candidateStringCurrentPosition, contentSize.height)
                self.scrollView.contentSize = contentSize
                
            }
            
        }
        
    }
    
    func updateBanner(candidateList: [String], inputKeyString:String) {
        
        self.inputKeyLabel.text = inputKeyString
        //移除所有
        self.scrollView.subviews.forEach { $0.removeFromSuperview() }
        for s in candidateList {
            
            self.addString(s)
            
        }
        self.setNeedsLayout()
    }
    
    func addString(s:String) {
        
        let btn:UIButton = UIButton(type: UIButtonType.Custom)
        btn.titleEdgeInsets = UIEdgeInsetsMake(btn.titleEdgeInsets.top + 5, btn.titleEdgeInsets.left, btn.titleEdgeInsets.bottom, btn.titleEdgeInsets.right)
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Selected)
        btn.addTarget(self, action: #selector(CatboardBanner.tapBtn(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btn.setTitle(s, forState: UIControlState.Normal)
        let size = CGSize()
        let attributes = [NSFontAttributeName: btn.titleLabel!.font]
        let r = s.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesFontLeading, attributes: attributes, context: nil)
        btn.frame = r;
        
        self.scrollView.addSubview(btn)
        
    }
    func moveScrollViewContentOffsetToFont() {
        self.scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    func clearBanner() {
        
        self.scrollView.subviews.forEach { $0.removeFromSuperview() }
        self.inputKeyLabel.text = ""
        
    }
    
    func tapBtn(btn: UIButton) {
        
        print(btn.titleLabel!.text)
        
        if (self.selectCandidateString != nil) {
            self.selectCandidateString!(btn.titleLabel!.text!)
        }
        
    }
    
   

}
