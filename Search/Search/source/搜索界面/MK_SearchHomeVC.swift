//
//  MK_SearchHomeVC.swift
//  Search
//
//  Created by 杨尚达 on 2018/11/16.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import Base

///搜索模块入口界面
public class MK_SearchHomeVC:MK_BaseNavigationVC {
    
    public init(){
        let vc = MK_SearchMainVC()
        super.init(rootViewController: vc)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
         
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
