//
//  MK_LiverListToolBar.swift
//  Search
//
//  Created by 杨尚达 on 2018/11/16.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import SnapKit


///主播列表工具栏
class MK_LiverListToolBar : UIView {
    
    ///标题
    lazy var titleLa = { () -> UILabel in
        let res = UILabel()
        res.text = "主播"
        res.font = UIFont.systemFont(ofSize: 12)
        addSubview(res)
        return res
    }()
    
    
    //显示更多按钮
    lazy var showMoreBu = { () -> UIButton in
        let res = UIButton.init(type: UIButton.ButtonType.system)
        res.setTitle("全部", for: UIControl.State.normal)
        addSubview(res)
        return res
    }()
    
    
    
    init(){
        super.init(frame: CGRect.zero)
        
        titleLa.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
        }
        showMoreBu.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
