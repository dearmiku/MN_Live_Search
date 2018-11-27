//
//  MK_LiveRoomV.swift
//  Search
//
//  Created by 杨尚达 on 2018/11/19.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import SnapKit
import RxSwift
import LivingRoom
import Base


///直播间列表控件
class MK_LiveRoomListV : UIView {
    
    var bag = DisposeBag()
    
    let vm = MK_LiveRoomListVM()
    
    ///顶部工具栏
    lazy var topToolBar = { () -> MK_LiveRoomToolBar in
        let res = MK_LiveRoomToolBar()
        addSubview(res)
        return res
    }()
    
    
    ///内容视图
    lazy var contentV = { () -> MK_liveRoomListContentV in
        let res = MK_liveRoomListContentV()
        addSubview(res)
        return res
    }()
    
    ///UI状态
    let state = BehaviorSubject<State>.init(value: MK_LiveRoomListV.State.fold)
    
    
    init(){
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.white
        
        
        topToolBar.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(50)
        }
        contentV.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(topToolBar.snp.bottom)
        }
        
        ///对点击全部按钮进行监听
        topToolBar.showMoreBu
            .rx.tap.asObservable().subscribe(onNext: {[weak self] (_) in
                
                guard let sf = self,
                    let state = try? sf.state.value() else {return}
                
                switch state{
                    
                ///展开
                case .unfold:
                    sf.state.onNext(MK_LiveRoomListV.State.fold)
                ///折叠
                case .fold:
                    
                    ///获取全部主播信息
                    sf.vm.showAllLiverInfo()
                        .subscribe(onSuccess: { (res) in
                            
                            guard let arr = res else {
                                print("获取全部主播信息失败--获取数组未nil")
                                return
                            }
                            ///刷新数据
                            sf.contentV.contentArr.onNext(arr)
                            ///刷新界面
                            sf.state.onNext(MK_LiveRoomListV.State.unfold)
                        }, onError: { (err) in
                            
                            print("获取全部主播信息失败--error")
                            
                        }).disposed(by: sf.bag)
                    break
                }
                
                
            }).disposed(by: bag)
        
        ///对ui状态进行监听
        state.skip(1)
            .subscribe(onNext: {[weak self] (res) in
                
                guard let sf = self else {return}
                
                switch res {
                ///展开
                case .unfold:
                    
                    sf.unfoldAnimation()
                ///折叠
                case .fold:
                    
                    sf.foldAnimation()
                }
                
            }).disposed(by: bag)
        
        
        ///对点击房间号进行订阅
        contentV.clickRoomIDV.subscribe(onNext: {[weak self] (res) in
            
            guard let sf = self,
                let state = try? sf.state.value(),
                res.count != 0 else {return}
            
            ///进入直播间
            let vc = MK_LiveRoomVC()
            vc.roomIdV.onNext(res)
            
            switch state{
                
            case .unfold:
                
                sf.state.onNext(MK_LiveRoomListV.State.fold)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25, execute: {
                    MK_SearchHomeVC.showVC?.pushViewController(vc, animated: true)
                })
                
            case .fold:
                MK_SearchHomeVC.showVC?.pushViewController(vc, animated: true)
            }
            
        }).disposed(by: bag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /* 折叠展开动画相关 */
    
    ///折叠状态下的父控件
    weak var foldSuperV:UIView?
    
    ///折叠状态下的布局属性
    var foldFrame:CGRect?
    
    ///展开动画
    func unfoldAnimation(){
        
        guard let kw = UIApplication.shared.keyWindow,
            let supV = self.superview else {return}
        
        let currentFrame =  supV.convert(self.frame, to: kw)
        
        foldFrame = self.frame
        foldSuperV = supV
        
        self.removeFromSuperview()
        
        kw.addSubview(self)
        self.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(currentFrame.origin.x)
            make.top.equalToSuperview().offset(currentFrame.origin.y)
            make.width.equalTo(currentFrame.size.width)
            make.height.equalTo(currentFrame.size.height)
        })
        kw.layoutIfNeeded()
        
        
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.snp.remakeConstraints({ (make) in
                make.top.equalToSuperview().offset(12+MK_Device.safeArre.top)
                make.left.equalToSuperview().offset(12)
                make.right.equalToSuperview().offset(-12)
                make.bottom.equalToSuperview().offset(-(12+MK_Device.safeArre.bottom))
                
            })
            
            self.layer.borderColor = UIColor.gray.cgColor
            self.layer.borderWidth = 1
            self.layer.cornerRadius = 10
            self.topToolBar.showMoreBu.setTitle("收起", for: UIControl.State.normal)
            
            kw.layoutIfNeeded()
        }) { (_) in
            self.contentV.CollVlayout.reStareLayout()
        }
        
    }
    
    
    ///折叠动画
    func foldAnimation(){
        
        guard let kw = UIApplication.shared.keyWindow,
            let supeV = foldSuperV,
            let supeF = foldFrame else {return}
        
        let showFrame =  supeV.convert(supeF, to: kw)
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.snp.remakeConstraints({ (make) in
                make.left.equalToSuperview().offset(showFrame.origin.x)
                make.top.equalToSuperview().offset(showFrame.origin.y)
                make.width.equalTo(showFrame.size.width)
                make.height.equalTo(showFrame.size.height)
            })
            self.layer.borderWidth = 0
            self.layer.cornerRadius = 0
            self.topToolBar.showMoreBu.setTitle("全部", for: UIControl.State.normal)
            kw.layoutIfNeeded()
            
        }) { (_) in
            self.removeFromSuperview()
            supeV.addSubview(self)
            
            self.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(supeF.origin.x)
                make.top.equalToSuperview().offset(supeF.origin.y)
                make.width.equalTo(supeF.size.width)
                make.height.equalTo(supeF.size.height)
            })
            self.contentV.CollVlayout.reStareLayout()
        }
        
        
    }
    
    
}

extension MK_LiveRoomListV {
    
    ///状态
    enum State {
        
        ///展开
        case unfold
        
        ///折叠
        case fold
        
        
    }
    
    
}
