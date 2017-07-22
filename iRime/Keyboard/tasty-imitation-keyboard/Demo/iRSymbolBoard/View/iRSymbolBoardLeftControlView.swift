//
//  iRSymbolBoardLeftControlView.swift
//  iRime
//
//  Created by 王宇 on 2017/7/18.
//  Copyright © 2017年 jimmy54. All rights reserved.
//  左侧控制条view

import UIKit

class iRSymbolBoardLeftControlView: UIView,UITableViewDataSource,UITableViewDelegate {

    var modelMain:iRsymbolsModel?
    lazy var tableView = {()->UITableView in
        let tableView:UITableView = UITableView.init(frame: CGRect.null, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.randomColor
        
        createSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: 创建view
    func createSubViews() -> Void {
        //1.tableVeiw
        self.addSubview(tableView)
        //--约束布局
        tableView.mas_makeConstraints { (make:MASConstraintMaker!) in
            make.edges.equalTo()(self)
        }
    }
    // MARK: - tableView数据源方法
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (modelMain?.arrayModels?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = UITableViewCell.init(style: .default, reuseIdentifier: "i")
        
        let modelSymbolItem:iRsymbolsItemModel = (modelMain?.arrayModels?[indexPath.row])!
        
        
        cell.textLabel?.text = modelSymbolItem.name
        
        
        
        return cell
    }
    
}
