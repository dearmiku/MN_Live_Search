//
//  MK_PlayerToolBar.swift
//  LivingRoom
//
//  Created by 杨尚达 on 2018/11/13.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import SnapKit
import RxSwift



///播放器工具栏
class MK_PlayerToolBar : UIView {
    
    var bag = DisposeBag()
    
    ///刷新按钮
    lazy var reloadBu = { () -> UIButton in
        let res = UIButton()
        res.setImage(UIImage.getImageBy(name: "MK_Player_Reload"), for: UIControl.State.normal)
        addSubview(res)
        return res
    }()
    
    
    ///暂停播放按钮
    lazy var pauseBu = { () -> UIButton in
        let res = UIButton()
        res.setImage(UIImage.getImageBy(name: "MK_Player_Play"), for: UIControl.State.normal)
        res.setImage(UIImage.getImageBy(name: "MK_Player_Pause"), for: UIControl.State.selected)
        addSubview(res)
        return res
    }()
    
    ///全屏按钮
    lazy var fullScreenBu = { () -> UIButton in
        let res = UIButton()
        res.setImage(UIImage.getImageBy(name: "MK_PlayerNoFullScreen"), for: UIControl.State.normal)
        res.setImage(UIImage.getImageBy(name: "MK_PlayerFullScreen"), for: UIControl.State.selected)
        res.addTarget(self, action: #selector(clickFullScreen), for: UIControl.Event.touchUpInside)
        addSubview(res)
        return res
    }()
    
    init(){
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.init(white: 0.0, alpha: 0.5)
        
        pauseBu.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        reloadBu.snp.makeConstraints { (make) in
            make.height.width.centerY.equalTo(pauseBu)
            make.left.equalTo(pauseBu.snp.right).offset(12)
        }
        
        fullScreenBu.snp.makeConstraints { (make) in
            make.height.width.centerY.equalTo(pauseBu)
            make.right.equalToSuperview().offset(-12)
        }
        
        
        ///监听点击暂停播放按钮
        pauseBu.rx.tap.asObservable().subscribe(onNext: {[weak self] (_) in
            
            guard let sf = self else {return}
            sf.pauseBu.isSelected = !sf.pauseBu.isSelected
            
        }).disposed(by: bag)
        
        
        ///对屏幕旋转状态进行监听
        MK_LiveRoomVC.isOrV.subscribe(onNext: {[weak self] (res) in
            
            guard let sf = self else {return}
            sf.fullScreenBu.isSelected = !res
            
        }).disposed(by: bag)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    ///点击旋转按钮
    @objc func clickFullScreen(){
        
        
        if self.fullScreenBu.isSelected {
            ///全屏
            
            MK_LiveRoomVC.shouldOr = true
            
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            
            MK_LiveRoomVC.isOrV.onNext(true)
            MK_LiveRoomVC.shouldOr = false
            
        }else{
            
            MK_LiveRoomVC.shouldOr = true
            ///竖屏
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            MK_LiveRoomVC.isOrV.onNext(false)
            MK_LiveRoomVC.shouldOr = false
        }
        
    }
    
}
