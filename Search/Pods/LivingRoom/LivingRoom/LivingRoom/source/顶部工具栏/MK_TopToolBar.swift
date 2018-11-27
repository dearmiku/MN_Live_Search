//
//  MK_TopToolBar.swift
//  LivingRoom
//
//  Created by 杨尚达 on 2018/11/14.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import SnapKit


///顶部工具栏
class MK_TopToolBar : UIView {
    
    ///返回按钮
    lazy var backBu = { () -> UIButton in
        let res = UIButton()
        res.setImage(UIImage.getImageBy(name: "MK_Player_Back"), for: UIControl.State.normal)
        addSubview(res)
        return res
    }()
    
    
    init(){
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.init(white: 0.0, alpha: 0.5)
        
        backBu.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(MK_Device.safeArre.top + 6)
            make.height.width.equalTo(30)
            make.left.equalToSuperview().offset(12)
        }
        
        print(MK_Device.safeArre)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
