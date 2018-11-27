//
//  MK_LiveRoomDetailInfoVM.swift
//  LivingRoom
//
//  Created by 杨尚达 on 2018/11/8.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import Moya
import RxSwift
import HandyJSON


class MK_LiveRoomDetailInfoVM {
    
    var bag = DisposeBag()
    
    lazy var provider = MoyaProvider<MK_LiverRoomTarget>()
    
    
    ///当前房间号
    lazy var currentRoomID = BehaviorSubject<String>.init(value: "")
    
    ///当前展示房间详情数据
    lazy var roomInfoV = BehaviorSubject<Model>.init(value: Model())
    
    init(){
        
        ///对房间号进行订阅
        currentRoomID.asObserver().skip(1).subscribe(onNext: {[weak self] (res) in
            
            guard let sf = self else {return}
            
            ///请求房间详情
            sf.provider.rx
                .request(MK_LiverRoomTarget.getLiveRoomInfo(res))
                .mapJSON()
                .subscribe(onSuccess: { (res) in
                    guard let dic = res as? [String:Any],
                        let data = dic["data"] as? [String:Any],
                        let model = Model.deserialize(from: data)  else {
                            
                            print("直播间-直播间详情 无法将返回数据转化为模型\(res)")
                            
                            return
                    }
                    
                    print("成功获取直播间房间详情模型\(model)")
                    
                    sf.roomInfoV.onNext(model)
                    
                }, onError: { (err) in
                    print("获取直播间详情失败\(err)")
                }).disposed(by: sf.bag)
            
        }).disposed(by: bag)
        
        
    }
    
}


extension MK_LiveRoomDetailInfoVM {
    
    struct Model : HandyJSON {
        
        ///房间号
        var room_id:String = ""
        
        ///房间截图
        var room_thumb:String = ""
        
        ///房间名称
        var room_name:String = ""
        
        ///房间分类ID
        var cate_id:String = ""
        
        ///房间分类名称
        var cate_name:String = ""
        
        ///房间状态
        var room_status:String = ""
        
        ///开播时间
        var start_time:String = ""
        
        ///房主名称
        var owner_name:String = ""
        
        ///房主头像
        var avatar:String = ""
        
        ///热度
        var online:Int64 = 0
        
        ///粉丝数
        var fans_num:String = ""
        
        
    }
    
}
