//
//  MK_SearchBar.swift
//  Search
//
//  Created by 杨尚达 on 2018/10/23.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift


///搜索栏
class MK_SearchBar : UIView {
    
    var bag = DisposeBag()
    
    ///占位搜素图片
    lazy var maskImageV = { () -> UIImageView in 
        let res = UIImageView()
        res.image = UIImage.getImageBy(name: "Search_SearchIcon")
        addSubview(res)
        return res
    }()
    
    ///检索背景图
    lazy var searchBackV = { () -> UIView in
        let res = UIView()
        res.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.00)
        res.layer.cornerRadius = 10
        
        addSubview(res)
        return res
    }()
    
    ///文字输入框
    lazy var textImputV = { () -> UITextField in
        let res = UITextField()
        res.tintColor = UIColor(red:0.13, green:0.59, blue:0.85, alpha:1.00)
        res.delegate = self
        res.returnKeyType = .search
        addSubview(res)
        return res
    }()
    
    ///取消返回按钮
    lazy var cancelBu = { () -> UIButton in
        let res = UIButton()
        res.setTitle("取消", for: UIControl.State.normal)
        res.setTitleColor(UIColor(red:0.13, green:0.59, blue:0.85, alpha:1.00), for: UIControl.State.normal)
        addSubview(res)
        return res
    }()
    
    ///当前输入框文字
    lazy var currentStr:Variable<String?> = Variable("")
    
    ///确认搜索框
    lazy var searchStrV = BehaviorSubject<String>.init(value: "")
    
    
    init(){
        super.init(frame: CGRect.zero)
        
        
        searchBackV.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-60)
        }
        maskImageV.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(searchBackV).offset(10)
            make.height.width.equalTo(30)
        }
        textImputV.snp.makeConstraints { (make) in
            make.left.equalTo(maskImageV.snp.right).offset(6)
            make.top.bottom.right.equalTo(searchBackV)
        }
        cancelBu.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }
        
        ///将文本输入框内容 实时绑定传输~
        textImputV.rx.text.asObservable().bind(to: currentStr).disposed(by: bag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MK_SearchBar : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let str = textField.text,
            str.count != 0{
            
            self.textImputV.resignFirstResponder()
            
            self.searchStrV.onNext(str)
        }
        return true
    }
    
}
