//
//  CandidateTableCellTableViewCell.swift
//  iRime
//
//  Created by jimmy54 on 6/29/16.
//  Copyright © 2016 jimmy54. All rights reserved.
//



import UIKit


class CandidateTableCellTableViewCell: UITableViewCell {
    
    var txtLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectedBackgroundView = UIView(frame: frame)
        selectedBackgroundView?.autoresizingMask = .FlexibleWidth
        selectedBackgroundView?.backgroundColor = UIColor.lightGrayColor()
        
        self.contentView.backgroundColor = UIColor.clearColor()
        self.backgroundColor = UIColor.clearColor()
        
        txtLabel = UILabel()
        txtLabel.backgroundColor = UIColor.clearColor()
        txtLabel.font = candidateTextFont
        txtLabel.textAlignment = .Center
        txtLabel.baselineAdjustment = .AlignCenters
        txtLabel.lineBreakMode = .ByTruncatingTail
        contentView.addSubview(txtLabel)
        
        
        self.separatorInset = UIEdgeInsetsZero
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = UIEdgeInsetsZero
        
        
        
        //test
        
//        txtLabel.backgroundColor = UIColor.redColor()
//        self.contentView.backgroundColor = UIColor.greenColor()
        
        
        
        
        
        txtLabel.translatesAutoresizingMaskIntoConstraints = false
//        let constraints = NSLayoutConstraint.constraintsWithVisualFormat("|-8-[txtLabel]-8-|", options: [], metrics: nil, views: ["txtLabel": txtLabel])
//        self.contentView.addConstraints(constraints)
        let constraint = NSLayoutConstraint(item: txtLabel, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1, constant: 0)
        self.contentView.addConstraint(constraint)
        
        let c = NSLayoutConstraint(item: txtLabel, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1, constant: 0)
        self.contentView.addConstraint(c)
        
        let rot: CGFloat = CGFloat(M_PI / 2)
        txtLabel.transform = CGAffineTransformMakeRotation(rot)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func updateAppearance() {
        if candidatesBannerAppearanceIsDark == true {
            txtLabel.textColor = UIColor.whiteColor()
        } else {
            txtLabel.textColor = UIColor.darkTextColor()
        }
    }
    
    class func getCellSizeByText(text: String, needAccuracy: Bool) -> CGSize {
        
        func accurateWidth() -> CGFloat {
            return (text as NSString).boundingRectWithSize(CGSize(width: CGFloat.infinity, height: getCandidateCellHeight()), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: candidateTextFont], context: nil).width + 20
        }
        
        var textWidth: CGFloat = 0
        if needAccuracy {
            textWidth = accurateWidth()
        } else {
            let length = text.getReadingLength()
            let utf8Length = text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
            if utf8Length == length * 3 {
                textWidth = oneChineseGlyphWidth * CGFloat(text.getReadingLength()) + 20
            } else {
                textWidth = accurateWidth()
            }
        }
        var returnWidth: CGFloat = 0
        if textWidth < defaultCandidateCellWidth {
            returnWidth = defaultCandidateCellWidth
        } else {
            returnWidth = textWidth
        }
        return CGSize(width: returnWidth, height: getCandidateCellHeight())
    }
}
