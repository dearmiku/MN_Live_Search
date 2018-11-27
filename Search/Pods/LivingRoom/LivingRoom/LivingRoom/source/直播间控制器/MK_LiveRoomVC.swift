//
//  MK_LiveRoomVC.swift
//  LivingRoom
//
//  Created by 杨尚达 on 2018/11/8.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import SnapKit
import RxSwift
import RxCocoa
import Moya
import Base


///直播间控制器
public class MK_LiveRoomVC : MK_BaseVC {
    
    let provider = MoyaProvider<MK_LiverRoomTarget>()
    
    ///房间号
    public let roomIdV = BehaviorSubject<String?>.init(value: nil)
    
    
    ///顶部工具栏
    lazy var topToolBar = { () -> MK_TopToolBar in
        let res = MK_TopToolBar.init()
        self.view.addSubview(res)
        return res
    }()
    
    
    ///直播间详情
    lazy var liveRoomInfoV = { () -> MK_LiveRoomDetailInfoV in
        let res = MK_LiveRoomDetailInfoV()
        view.addSubview(res)
        return res
    }()
    
    ///播放器
    lazy var player = { () -> MK_Player in
        let res = MK_Player()
        view.addSubview(res)
        return res
    }()
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.isShowNavigationBar = false
        
        liveRoomInfoV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-MK_Device.safeArre.bottom)
            make.height.equalTo(100)
        }
        
        player.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(liveRoomInfoV.snp.top)
        }
        
        topToolBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(MK_Device.safeArre.top + 12 + 30)
            make.top.equalToSuperview()
        }
        
        
        
        ///对房间号进行订阅
        roomIdV.subscribe(onNext: {[weak self] (res) in
            
            guard let sf = self,
                let roomID = res else {return}
            ///展示房间详情信息
            sf.liveRoomInfoV.vm.currentRoomID.onNext(roomID)
            
            ///开始播放业务
            sf.player.vm.roomId.onNext(roomID)
            
        }).disposed(by: bag)
        
        
        ///对播放器UI状态进行监听
        player.uiState.skip(1).subscribe(onNext: {[weak self] (res) in
            
            guard let sf = self else {return}
            
            switch res {
                
            case .show:
                UIView.animate(withDuration: 0.25, animations: {
                    sf.topToolBar.alpha = 1.0
                })
                break
            case .hide:
                UIView.animate(withDuration: 0.25, animations: {
                    sf.topToolBar.alpha = 0.0
                })
                break
            }
            
        }).disposed(by: bag)
        
        ///对屏幕旋转状态进行监听
        MK_LiveRoomVC.isOrV.subscribe(onNext: {[weak self] (res) in
            
            guard let sf = self else {return}
            
            if res {
                UIView.animate(withDuration: 0.25, animations: {
                    sf.liveRoomInfoV.snp.updateConstraints({ (make) in
                        make.height.equalTo(0)
                    })
                    sf.view.layoutIfNeeded()
                })
            }else{
                UIView.animate(withDuration: 0.25, animations: {
                    sf.liveRoomInfoV.snp.updateConstraints({ (make) in
                        make.height.equalTo(100)
                    })
                    sf.view.layoutIfNeeded()
                })
            }
        }).disposed(by: bag)
        
        ///对返回按钮的监听
        topToolBar.backBu.rx
            .tap.asObservable().subscribe(onNext: {[weak self] (_) in
            
            guard let sf = self else {return}
            
            ///返回竖直状态
            MK_LiveRoomVC.shouldOr = true
            ///竖屏
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            MK_LiveRoomVC.isOrV.onNext(false)
            MK_LiveRoomVC.shouldOr = false
            
            ///退出界面
            if let vc = sf.navigationController {
                vc.popViewController(animated: true)
            }else{
                sf.dismiss(animated: true, completion: nil)
            }
            
        }).disposed(by: bag)
        
        
        ///开启定时隐藏工具栏
        player.clickPlayer()
        
    }
    
    /* 屏幕旋转相关 */
    ///旋转状态
    static let isOrV = BehaviorSubject<Bool>.init(value: false)
    
    ///是否应该旋转
    static var shouldOr:Bool = false
    
    public override var shouldAutorotate: Bool {
        get{
            return MK_LiveRoomVC.shouldOr
        }
    }
    
    
}




