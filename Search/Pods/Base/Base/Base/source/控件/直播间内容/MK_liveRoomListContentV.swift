//
//  MK_liveRoomListCContentV.swift
//  Search
//
//  Created by 杨尚达 on 2018/11/19.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import SnapKit
import RxSwift


///直播间模型
public class MK_liveRoomListContentV : UICollectionView {
    
    let cellID = "CellID"
    
    let emptyCellID = "EmptyCellID"
    
    var bag = DisposeBag()
    
    ///内容数组
    public lazy var contentArr = BehaviorSubject<[MK_LiveRoomCellModelProtocol]>.init(value: [])
    
    ///布局方法
    public var CollVlayout:MK_AppleMessageCollectionViewLayout!
    
    
    ///点击房间号
    public let clickRoomIDV = BehaviorSubject<String>.init(value: "")
    
    public init(){
        
        let layout = MK_AppleMessageCollectionViewLayout()
        
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize.init(width: 0, height: 0)
        
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        
        CollVlayout = layout
        
        self.backgroundColor = UIColor.white
        
        self.register(MK_LiveRoomCell.self, forCellWithReuseIdentifier: cellID)
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: emptyCellID)
        
        
        self.delegate = self
        self.dataSource = self
        
        self.contentInset = UIEdgeInsets.init(top: 10, left: 0, bottom: 10, right: 0)
        
        
        contentArr.asObserver().subscribe(onNext: {[weak self] (res) in
            self?.reloadData()
            self?.CollVlayout.reStareLayout()
        }).disposed(by: bag)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


///collectionView 代理方法
extension MK_liveRoomListContentV : UICollectionViewDelegate,UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let arr = (try? contentArr.value()) ?? []
        
        return arr.count * 3
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (indexPath.row - 1)%3 == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MK_LiveRoomCell
            
            if let arr = try? contentArr.value(){
                cell.model = arr[(indexPath.row - 1)/3]
            }
            
            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyCellID, for: indexPath)
            cell.backgroundColor = UIColor.white
            return cell
        }
        
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let arr = try? contentArr.value(){
            
            let model = arr[(indexPath.row - 1)/3]
            clickRoomIDV.onNext(model.roomIdStr)
        }
    }
    
}

extension MK_liveRoomListContentV : UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (indexPath.row - 1)%3 == 0 {
            
            return CGSize.init(width: self.frame.width-25, height: 260)
            
        }else{
            
            return CGSize.init(width: 10, height: 260)
            
        }
    }
    
    
}
