//
//  iRSymbolBoardRightWordsView.swift
//  iRime
//
//  Created by 王宇 on 2017/7/18.
//  Copyright © 2017年 jimmy54. All rights reserved.
//  右侧展示符号的view

import UIKit

class iRSymbolBoardRightWordsView: UIView,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {

    weak var delegateAction:iRSymbolBoardContentViewProtocol?
    let collectionView:UICollectionView = {
        let collectionView = UICollectionView.init(frame: CGRect.null, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.register(iRSymbolBoardRightWordsCollectionCell.classForCoder(), forCellWithReuseIdentifier: "iRSymbolBoardRightWordsCollectionCell")
        collectionView.backgroundColor = UIColor.white
        return collectionView
    
    }()
    
    var modelSymbolItem:iRsymbolsItemModel?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubViews() -> Void {
        //1.collectionView
        self.addSubview(collectionView)
        //--属性设置
        collectionView.delegate = self;
        collectionView.dataSource = self;
        //--约束布局
        collectionView.mas_makeConstraints { (make:MASConstraintMaker!) in
            make.edges.equalTo()(self);
        }
    }
    
    //MARK:数据源
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return (modelSymbolItem?.arraySymbols?.count)!;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell:iRSymbolBoardRightWordsCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "iRSymbolBoardRightWordsCollectionCell", for: indexPath) as! iRSymbolBoardRightWordsCollectionCell
        
        cell.strTitle = modelSymbolItem?.arraySymbols?[indexPath.item]
        
        return cell
    }
    
    //MARK:布局回调
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return  (modelSymbolItem?.sizeOfItem)!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    //MARK:点击回调
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (self.delegateAction?.responds(to: #selector(iRSymbolBoardContentViewProtocol.presentTextFromSymbolBoard(_:))))! {
            
            let strSymbol:String = (modelSymbolItem?.arraySymbols?[indexPath.item])!
            
            self.delegateAction?.presentTextFromSymbolBoard(strSymbol)
        }
        
        
        let identifyLockStr:String = UserDefaults.standard.string(forKey: identifyLock_iRSymbolBoard)!
        if identifyLockStr  == "0"
        {
            //--锁是开启状态
            if (self.delegateAction?.responds(to: #selector(iRSymbolBoardContentViewProtocol.tapToCheckIfNeedToHideSymbolBoard)))! {
                self.delegateAction?.tapToCheckIfNeedToHideSymbolBoard()
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath)
    {
        let cell:iRSymbolBoardRightWordsCollectionCell = collectionView.cellForItem(at: indexPath) as! iRSymbolBoardRightWordsCollectionCell
        
        cell.changeStateForSelected(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath)
    {
        let cell:iRSymbolBoardRightWordsCollectionCell = collectionView.cellForItem(at: indexPath) as! iRSymbolBoardRightWordsCollectionCell
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            cell.changeStateForSelected(false)
        }
    
    }
    
    
    
    
    
}
