//
//  MK_QuickSearchContentV.swift
//  Search
//
//  Created by 杨尚达 on 2018/10/29.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import Moya
import Base


///快捷搜索内容展示控件
class MK_QuickSearchContentV : UICollectionView {
    
    let cellID = "CellID"
    
    var bag = DisposeBag()
    
    ///快捷检索内容数组
    lazy var contentStrArr = BehaviorSubject<[String]>.init(value: [])
    
    ///快捷检索词汇
    lazy var searchStr = BehaviorSubject<String?>.init(value: "")
    
    ///点击关键字
    lazy var clickStr = BehaviorSubject<String>.init(value: "")
    
    
    lazy var provider = MoyaProvider<MK_SearchTarget>()
    
    
    init(){
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: ScreenWidth, height: 60)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        
        self.delegate = self
        self.dataSource = self
        self.register(Item.self, forCellWithReuseIdentifier: cellID)
        self.backgroundColor = UIColor.white
        
        
        ///对快捷检索词汇进行监听
        searchStr.skip(1).subscribe(onNext: {[weak self] (res) in
            
            guard let sf = self,let str = res else {return}
            
            ///请求快捷搜索关键字
            sf.provider.rx
                .request(MK_SearchTarget.quickSearch(str))
                .mapJSON()
                .subscribe(onSuccess: { (res) in
                    
                    guard let dic = res as? [String:Any],
                        let arr = dic["autoCom"] as? [String] else {return}
                    
                    MK_Log(str: "快捷检索内容展示\(res)")
                    sf.contentStrArr.onNext(arr)
                    
                }, onError: { (err) in
                    MK_Log(str: "快捷搜索获取数据失败~\(err)")
                    
                }).disposed(by: sf.bag)
            
        }).disposed(by: bag)
        
        
        ///对展示快捷内容进行监听
        contentStrArr.subscribe(onNext: {[weak self] (res) in
            
            guard let sf = self else {return}
            sf.reloadData()
            
        }).disposed(by: bag)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///将字符串转化为需要展示的富文本
    func turnStrToNeedAtt(str:String)->NSAttributedString{
        
        guard let kw = (try? searchStr.value()) as? String,
        kw.replacingOccurrences(of: " ", with: "").count != 0 else {
            
            return NSAttributedString.init(string: str, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black,.font:UIFont.systemFont(ofSize: 14)])
        }
        
        let arr = (str as NSString).components(separatedBy: kw)
        
        let res = NSMutableAttributedString.init(string: "")
        
        ///关键字富文本
        let kwAttArr = [NSAttributedString.Key.foregroundColor : UIColor(red:0.13, green:0.59, blue:0.85, alpha:1.00),.font:UIFont.systemFont(ofSize: 14)]
        
        ///常规字富文本
        let normalAttArr = [NSAttributedString.Key.foregroundColor : UIColor.black,.font:UIFont.systemFont(ofSize: 14)]
        
        for (index,item) in arr.enumerated() {
            
            if index == arr.count - 1{
                
                if item == ""{
                    res.append(NSAttributedString.init(string: kw, attributes: kwAttArr))
                }else{
                    res.append(NSAttributedString.init(string: item, attributes: normalAttArr))
                }
                
            }else{
                res.append(NSAttributedString.init(string: item, attributes: normalAttArr))
                res.append(NSAttributedString.init(string: kw, attributes: kwAttArr))
            }
        }
        
        return res
    }
    
    
    
}

extension MK_QuickSearchContentV : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = try? contentStrArr.value().count
        
        return count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! Item
        
        if let arr = try? contentStrArr.value() {
            cell.showLa.attributedText = turnStrToNeedAtt(str: arr[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let arr = try? contentStrArr.value() else {return}
        let str = arr[indexPath.row]
        clickStr.onNext(str)
    }
    
}


extension MK_QuickSearchContentV {
    
    class Item : UICollectionViewCell {
        
        ///快捷结果展示La
        lazy var showLa = { () -> UILabel in
            let res = UILabel()
            addSubview(res)
            return res
        }()
        
        ///下划线
        lazy var bottomLineV = { () -> UIView in
            let res = UIView()
            res.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.00)
            addSubview(res)
            return res
        }()
        
        ///item展示字符串
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = UIColor.white
            
            showLa.snp.makeConstraints { (make) in
                make.right.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(12)
            }
            bottomLineV.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(6)
                make.right.equalToSuperview().offset(-6)
                make.height.equalTo(1)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}
