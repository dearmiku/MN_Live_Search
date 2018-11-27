//
//  MK_SearchMainVC.swift
//  Search
//
//  Created by 杨尚达 on 2018/10/23.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import Base


///搜索主界面
class MK_SearchMainVC : MK_BaseVC {
    
    ///控制器状态
    lazy var state:Variable<State> = Variable(.free)
    
    ///搜索栏
    lazy var searchBar = { () -> MK_SearchBar in
        let res = MK_SearchBar()
        view.addSubview(res)
        return res
    }()
    
    ///快捷搜索控件
    lazy var quickSearchV = { () -> MK_QuickSearchContentV in
        let res = MK_QuickSearchContentV()
        view.addSubview(res)
        return res
    }()
    
    ///内容展示空间
    lazy var contentV = { () -> MK_SearchContentV in
        let res = MK_SearchContentV()
        view.addSubview(res)
        return res
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.isShowNavigationBar = false
        
        searchBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(MK_Device.safeArre.top)
            make.height.equalTo(50)
        }
        quickSearchV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalToSuperview().offset(-MK_Device.safeArre.bottom)
        }
        contentV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalToSuperview().offset(-MK_Device.safeArre.bottom)
        }
        
        
        
        /// 将搜索栏实时检索内容与快捷展示进行绑定~
        searchBar.currentStr.asObservable().skip(1).bind(to: quickSearchV.searchStr).disposed(by: bag)
        
        /// 将确认检索内容 与 检索内容展示框
        searchBar.searchStrV.asObserver()
            .skip(1).subscribe(onNext: {[weak self] (res) in
            
            self?.contentV.searchWord.onNext(res)
            self?.state.value = State.allSearch(res)
            
        }).disposed(by: bag)
        
        ///对搜索栏内容进行监听
        searchBar.currentStr
            .asObservable()
            .skip(1)
            .subscribe(onNext: {[weak self] (res) in
                
                guard let sf = self,
                    let str = res else {return}
                
                switch sf.state.value {
                    
                    ///空闲状态
                case .free:
                    if str.count == 0 {
                        
                    }else{
                      sf.state.value = .quick
                    }
                    ///快捷搜索状态
                case .quick:
                    if str.count == 0 {
                        sf.state.value = .free
                    }else{
                    }
                    ///全类搜索状态
                case .allSearch(_):
                    if str.count == 0 {
                        sf.state.value = .free
                    }else{
                        sf.state.value = .quick
                    }
                }
                
            }).disposed(by: bag)
        
        
        ///对状态进行监听
        state.asObservable().subscribe(onNext: {[weak self] (res) in
            
            guard let sf = self else {return}
            
            switch res {
            ///空闲状态
            case .free:
                sf.quickSearchV.isHidden = true
                sf.contentV.isHidden = true
                break
            ///快捷搜索
            case .quick:
                sf.quickSearchV.isHidden = false
                sf.contentV.isHidden = true
                break
            ///全搜索
            case .allSearch:
                sf.quickSearchV.isHidden = true
                sf.contentV.isHidden = false
                break
            }
            
        }).disposed(by: bag)
        
        ///对快捷展示关键字点击进行监听
        quickSearchV.clickStr.subscribe(onNext: {[weak self] (res) in
            
            guard res.count != 0,
                let sf = self else {return}
            
            sf.searchBar.textImputV.text = res
            sf.searchBar.searchStrV.onNext(res)
            
        }).disposed(by: bag)
        
        
    }
    
    
}



extension MK_SearchMainVC {
    
    enum State {
        
        ///空闲状态
        case free
        
        ///快捷状态
        case quick
        
        ///全类搜索状态
        case allSearch(String)
    }
    
}
