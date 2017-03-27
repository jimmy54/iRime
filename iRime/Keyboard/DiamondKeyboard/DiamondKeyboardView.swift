//
//  DiamondKeyboardView.swift
//  iRime
//
//  Created by hanbing on 2017/3/16.
//  Copyright © 2017年 jimmy54. All rights reserved.
//

import UIKit

//@protocol RimeNotificationDelegate <NSObject>
//
//@optional
//- (void)onDeploymentStarted;
//- (void)onDeploymentSuccessful;
//- (void)onDeploymentFailed;
//- (void)onSchemaChangedWithNewSchema:(NSString *)schema;
//- (void)onOptionChangedWithOption:(XRimeOption)option value:(BOOL)value;
//
//@end


let bannerWidth: CGFloat = 50


class DiamondKeyboardView: UIView,UITableViewDataSource,UITableViewDelegate {

    var tableView: UITableView? = nil
    var collectionView: UICollectionView? = nil
    var bottomView: DiamondBottomView? = nil
    var bottomTableView: UITableView? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.redColor()
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configUI() {
        
        self.tableView = createTableView(self)
        self.addSubview(self.tableView!)
        
        let layout: UICollectionViewLayout = UICollectionViewLayout.init()

        self.collectionView = UICollectionView.init(frame: CGRectZero, collectionViewLayout: layout)
        self.addSubview(self.collectionView!)
        
        self.bottomTableView = createTableView(self)
        self.addSubview(self.bottomTableView!)
//        self.bottomView = DiamondBottomView.init(frame: CGRectZero)
//        self.addSubview(self.bottomView!)
        
        let myFrame: CGRect = self.frame
        let myHeight: CGFloat = myFrame.size.height
        let myWidth: CGFloat = myFrame.size.width
        let viewHeight: CGFloat = myHeight-bannerWidth
        
        self.tableView!.frame = CGRectMake(0, 0, bannerWidth, viewHeight)
        
        let collcetionFrame: CGRect = CGRectMake(bannerWidth, 0, myWidth-bannerWidth, viewHeight)
        self.collectionView!.frame = collcetionFrame
        
        let rot: CGFloat = CGFloat(-M_PI / 2)
        self.bottomTableView!.transform = CGAffineTransformMakeRotation(rot)
        let bottomFrame: CGRect = CGRectMake(0, viewHeight, myWidth, bannerWidth)
        self.bottomTableView!.frame = bottomFrame
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell.init()
    
    }
}

class DiamondBottomView: UIView,UITableViewDataSource,UITableViewDelegate {

    var tableView: UITableView? = nil
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blueColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configUI() {
        self.tableView! = createTableView(self)
        let rot: CGFloat = CGFloat(-M_PI / 2)
        self.tableView!.transform = CGAffineTransformMakeRotation(rot)
        self.addSubview(self.tableView!)
        
        self.tableView!.mas_makeConstraints( { (make: MASConstraintMaker!) in
            make.edges.mas_equalTo()(self)
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell.init()
    }

}

func createTableView(fatherView:protocol<UITableViewDataSource, UITableViewDelegate>) -> UITableView {
    let tableView: UITableView = UITableView.init(frame: CGRectZero, style: .Plain);
    tableView.delegate = fatherView
    tableView.dataSource = fatherView
    tableView.backgroundColor = UIColor.brownColor()
    return tableView
}
