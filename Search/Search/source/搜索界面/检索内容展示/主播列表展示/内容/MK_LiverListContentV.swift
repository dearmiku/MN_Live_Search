//
//  MK_LiverListContentV.swift
//  Search
//
//  Created by 杨尚达 on 2018/10/31.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import UIKit
import RxSwift
import Base


///主播内容列表 
class MK_LiverListContentV : UICollectionView {
    
    let cellID = "CellID"
    
    var bag = DisposeBag()
    
    ///内容数组
    lazy var contentArr = BehaviorSubject<[MK_LiverModel]>.init(value: [])
    
    ///布局方法
    var CollVlayout:MK_AppleMessageCollectionViewLayout!
    
    
    ///点击房间号
    var clickModelV = BehaviorSubject<String>.init(value: "")
    
    init(){
        
        let layout = MK_AppleMessageCollectionViewLayout()
        
        layout.itemSize = CGSize.init(width: 100, height: 130)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 1
        
        
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        
        CollVlayout = layout
        
        self.backgroundColor = UIColor.white
        
        self.register(Item.self, forCellWithReuseIdentifier: cellID)
        self.delegate = self
        self.dataSource = self
        
        self.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        
        
        contentArr.asObserver().subscribe(onNext: {[weak self] (res) in
            
            self?.reloadData()
            
            self?.CollVlayout.reStareLayout()
            
            
        }).disposed(by: bag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
}

///collectionView 代理方法
extension MK_LiverListContentV : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let arr = (try? contentArr.value()) ?? []
        
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! Item
        
        if let arr = try? contentArr.value(){
            cell.model = arr[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let arr = try? contentArr.value(){
            
            let model = arr[indexPath.row]
            
            clickModelV.onNext(model.liverRoomID)
            
        }
    }
    
}


