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
        selectedBackgroundView?.autoresizingMask = .flexibleWidth
        selectedBackgroundView?.backgroundColor = UIColor.lightGray
        
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        txtLabel = UILabel()
        txtLabel.backgroundColor = UIColor.clear
        txtLabel.font = candidateTextFont
        txtLabel.textAlignment = .center
        txtLabel.baselineAdjustment = .alignCenters
        txtLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(txtLabel)
        
        
        self.separatorInset = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = UIEdgeInsets.zero
        
        
        
        //test
        
//        txtLabel.backgroundColor = UIColor.redColor()
//        self.contentView.backgroundColor = UIColor.greenColor()
        
        
        
        
        
        txtLabel.translatesAutoresizingMaskIntoConstraints = false
//        let constraints = NSLayoutConstraint.constraintsWithVisualFormat("|-8-[txtLabel]-8-|", options: [], metrics: nil, views: ["txtLabel": txtLabel])
//        self.contentView.addConstraints(constraints)
        let constraint = NSLayoutConstraint(item: txtLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)
        self.contentView.addConstraint(constraint)
        
        let c = NSLayoutConstraint(item: txtLabel, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0)
        self.contentView.addConstraint(c)
        
        let rot: CGFloat = CGFloat(M_PI / 2)
        txtLabel.transform = CGAffineTransform(rotationAngle: rot)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func updateAppearance() {
        if candidatesBannerAppearanceIsDark == true {
            txtLabel.textColor = UIColor.white
        } else {
            txtLabel.textColor = UIColor.darkText
        }
    }
    
    class func getCellSizeByText(_ text: String, needAccuracy: Bool) -> CGSize {
        
        func accurateWidth() -> CGFloat {
            return (text as NSString).boundingRect(with: CGSize(width: CGFloat.infinity, height: getCandidateCellHeight()), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: candidateTextFont], context: nil).width + 20
        }
        
        var textWidth: CGFloat = 0
        if needAccuracy {
            textWidth = accurateWidth()
        } else {
            let length = text.getReadingLength()
            let utf8Length = text.lengthOfBytes(using: String.Encoding.utf8)
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
