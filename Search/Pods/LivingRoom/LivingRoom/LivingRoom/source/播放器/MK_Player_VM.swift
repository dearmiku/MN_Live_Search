//
//  MK_Player_VM.swift
//  LivingRoom
//
//  Created by 杨尚达 on 2018/11/13.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import RxSwift
import Moya



class MK_Player_VM {
    
    var bag = DisposeBag()
    
    let provider = MoyaProvider<MK_LiverRoomTarget>()
    
    ///roomID
    lazy var roomId = BehaviorSubject<String>.init(value: "")
    
    ///播放链接
    lazy var liveURL = BehaviorSubject<String>.init(value: "")
    
    
    init(){
        
        ///对room id进行订阅
        roomId.skip(1).subscribe(onNext: {[weak self]
            (res) in
            
            guard let sf = self,res.count != 0 else {return}
            
            sf.loadLiveURL(roomID: res)
            
        }).disposed(by: bag)
        
        ///定时循环刷新url
        Observable<Int>.interval(30, scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] (_) in
            
            guard let sf = self,
                let roomID = try? sf.roomId.value(),
                roomID.count != 0 else {return}
            
            sf.roomId.onNext(roomID)
            
            print("重载roomID 刷新播放器url")
            
        }).disposed(by:bag)
        
        
    }
    
    ///加载播放url
    func loadLiveURL(roomID:String){
        
        guard roomID.count != 0 else {return}
        
        provider.rx
            .request(MK_LiverRoomTarget.getLiveURL(roomID))
            .mapJSON()
            .subscribe(onSuccess: {[weak self] (res) in
                
                guard let sf = self,
                    let dic = res as? [String:Any],
                    let data = dic["data"] as? [String:Any],
                    let urlStr = data["hls_url"] as? String else {
                        
                        print("加载播放URL失败,可能未开播~\(res)")
                        return
                }
               
                sf.liveURL.onNext(urlStr)
                
            }) { (err) in
                
                print("无法获取url 网络错误\(err)")
                
            }.disposed(by: bag)
    }
    
}
