//
//  MK_Player.swift
//  LivingRoom
//
//  Created by 杨尚达 on 2018/10/22.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import UIKit
import IJKMediaFramework
import SnapKit
import RxSwift
import RxCocoa


///播放器
class MK_Player : UIView {
    
    var bag = DisposeBag()
    
    let vm = MK_Player_VM()
    
    
    ///播放器状态
    var state = BehaviorSubject<State>.init(value: MK_Player.State.free)
    
    ///UI状态]
    var uiState = BehaviorSubject<UIState>.init(value: MK_Player.UIState.hide)
    
    
    ///ijk播放器
    lazy var ijkPlayer = { () -> IJKMPMoviePlayerController in
        let res = IJKMPMoviePlayerController.init()
        res.controlStyle = .none
        res.scalingMode = .aspectFit
        self.addSubview(res.view)
        return res
    }()
    
    ///工具栏
    lazy var toolBar = { () -> MK_PlayerToolBar in
        let res = MK_PlayerToolBar()
        addSubview(res)
        return res
    }()
    
    ///点击手势
    lazy var tapGe = { () -> UITapGestureRecognizer in 
        
        let res = UITapGestureRecognizer.init(target: self, action: #selector(clickPlayer))
        res.delegate = self
        return res
    }()
    
    
    init(){
        super.init(frame: CGRect.zero)
        
        ijkPlayer.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        toolBar.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(ijkPlayer.view)
            make.height.equalTo(40+MK_Device.safeArre.right)
        }
        
        ///添加屏幕点击事件
        ijkPlayer.view.addGestureRecognizer(tapGe)
        
        
        ///对播放链接进行监听
        vm.liveURL.skip(1).subscribe(onNext: {[weak self] (res) in
            
            guard let sf = self,
                let url = URL.init(string: res) else {return}
             print("获取播放链接 \(url)")
            ///开始播放
            sf.ijkPlayer.contentURL = url
            sf.ijkPlayer.prepareToPlay()
            sf.ijkPlayer.play()
            
        }).disposed(by: bag)
        
        
        ///对当前状态进行监听
        state.asObserver().subscribe(onNext: {[weak self] (res) in
            
            guard let sf = self,
                let roomID = try? sf.vm.roomId.value() else {return}
            
            switch res {
                
            case .free:
                break
            case .playeing:
                sf.vm.roomId.onNext(roomID)
                break
            case .pauseing:
                
                sf.ijkPlayer.pause()
                break
            }
            
            
        }).disposed(by: bag)
        
        
        ///对刷新按钮监听
        toolBar.reloadBu.rx
            .tap.asObservable().subscribe(onNext: {[weak self] (_) in
                
                guard let sf = self,
                    let state = try? sf.state.value(),
                    state != .pauseing,
                    let roomID = try? sf.vm.roomId.value() else {return}
                
                sf.vm.roomId.onNext(roomID)
                
            }).disposed(by: bag)
        
        ///对暂停按钮进行监听
        toolBar.pauseBu.rx.observe(Bool.self, #keyPath(UIButton.isSelected)).subscribe(onNext: {[weak self] (res) in
            
            guard let sf = self,
                let isSelect = res else {return}
            
            if isSelect{
                sf.state.onNext(MK_Player.State.pauseing)
            } else {
                sf.state.onNext(MK_Player.State.playeing)
            }
            
        }).disposed(by: bag)
        
        
        ///对ui状态进行监听
        uiState.asObserver().subscribe(onNext: {[weak self] (res) in
            
            guard let sf = self else {return}
            switch res {
                
            case .show:
                UIView.animate(withDuration: 0.25, animations: {
                    sf.toolBar.alpha = 1.0
                })
                
                break
            case .hide:
                UIView.animate(withDuration: 0.25, animations: {
                    sf.toolBar.alpha = 0.0
                })
                
                break
            }
            
        }).disposed(by: bag)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    ///点击播放器
    @objc func clickPlayer(){
        
        guard let res = try? self.uiState.value(),res == .hide else {return}
        
        self.uiState.onNext(MK_Player.UIState.show)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.uiState.onNext(MK_Player.UIState.hide)
        }
    }
    
    
}


extension MK_Player : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


extension MK_Player {
    
    enum State {
        
        ///空闲
        case free
        
        ///播放
        case playeing
        
        ///暂停
        case pauseing
        
        
    }
    
    ///UI界面状态
    enum UIState {
        
        ///展示工具栏
        case show
        
        ///隐藏工具栏
        case hide
        
        
    }
    
}
