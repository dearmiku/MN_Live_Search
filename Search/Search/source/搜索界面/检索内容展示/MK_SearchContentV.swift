//
//  MK_SearchContentV.swift
//  Search
//
//  Created by 杨尚达 on 2018/11/2.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import Moya


///检索内容展示空间
class MK_SearchContentV: UIView {
    
    var bag = DisposeBag()
    
    lazy var provider = MoyaProvider<MK_SearchTarget>()
    
    ///主播列表展示控件
    lazy var liverContentV = { () -> MK_LiverListV in
        let res = MK_LiverListV()
        addSubview(res)
        return res
    }()
    
    
    ///直播间展示空间
    lazy var liveRoomContentV = { () -> MK_LiveRoomListV in
        let res = MK_LiveRoomListV()
        addSubview(res)
        return res
    }()
    
    ///检索词汇
    lazy var searchWord = BehaviorSubject<String>.init(value: "")
    
    
    init(){
        
        super.init(frame: CGRect.zero)
        
        liverContentV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(200)
        }
        liveRoomContentV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(212)
        }
        
        
        ///对检索词汇进行订阅
        searchWord.skip(1).subscribe(onNext: {[weak self] (res) in
            
            guard let sf = self else {return}
            
            ///进行全类搜索
            sf.provider.rx.request(MK_SearchTarget.allSearch(res)).mapString().subscribe(onSuccess: { (res) in
                
                ///对HTML进行解析
                
                ///传输 主播列表 数据~
                let liver = MK_Search_Plugin.analyAllSearchWith(str: res)
                sf.liverContentV.contentV.contentArr.onNext(liver)
                
                ///传输 直播间 数据
                let room = MK_Search_Plugin.analyAllSearchToLiveRoomWith(str: res)
                sf.liveRoomContentV.contentV.contentArr.onNext(room)
                
            }, onError: { (err) in
                
                print("对全类搜索解析词汇错误~")
                
            }).disposed(by: sf.bag)
            
        }).disposed(by: bag)
        
        ///将搜索词汇与具体模块控件进行绑定
        searchWord.skip(1).bind(to: liverContentV.vm.searchStrV).disposed(by: bag)
        
        searchWord.skip(1).bind(to: liveRoomContentV.vm.searchStrV).disposed(by: bag)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
