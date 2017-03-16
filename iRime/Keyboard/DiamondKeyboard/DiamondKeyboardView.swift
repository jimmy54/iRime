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

func createTableView(fatherView:protocol<UITableViewDataSource, UITableViewDelegate>) -> UITableView {
    let tableView: UITableView = UITableView.init(frame: CGRectZero, style: .Plain);
    tableView.delegate = fatherView
    tableView.dataSource = fatherView
    tableView.backgroundColor = UIColor.blueColor()
    return tableView
}

class DiamondKeyboardView: UIView,UITableViewDataSource,UITableViewDelegate {

    var tableView: UITableView? = nil
    var collectionView: UICollectionView? = nil
    
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configUI() {
        self.tableView = createTableView(self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell.init()
        
    }
}
