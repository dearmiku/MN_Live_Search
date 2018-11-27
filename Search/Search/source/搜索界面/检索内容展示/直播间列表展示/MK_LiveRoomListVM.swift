//
//  MK_LiveRoomListVM.swift
//  Search
//
//  Created by 杨尚达 on 2018/11/20.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import Moya
import RxSwift


class MK_LiveRoomListVM {
    
    var bag = DisposeBag()
    
    lazy var provider = MoyaProvider<MK_SearchTarget>()
    
    ///检索词汇
    lazy var searchStrV = BehaviorSubject<String>.init(value: "")
    
    
    ///展示全部主播信息
    func showAllLiverInfo()->PrimitiveSequence<SingleTrait, [MK_LiveRoomModel]?>{
        
        guard let str = try? searchStrV.value() else {
            return Single<[MK_LiveRoomModel]?>.create { (res) -> Disposable in
                res(SingleEvent<[MK_LiveRoomModel]?>.success(nil))
                return Disposables.create()
            }
            
        }
        
        return provider.rx
            .request(MK_SearchTarget.liveRoomSearch(str))
            .mapString()
            .map { (str) -> [MK_LiveRoomModel]? in
                return MK_Search_Plugin.analyAllSearchToLiveRoomWith(str: str)
        }
        
    }
    
}

