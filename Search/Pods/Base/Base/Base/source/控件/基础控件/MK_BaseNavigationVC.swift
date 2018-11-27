//
//  MK_BaseNavigationVC.swift
//  Base
//
//  Created by 杨尚达 on 2018/11/23.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import UIKit

///基础导航控制器
open class MK_BaseNavigationVC:UINavigationController {
    
    
    ///当前展示的VC
    public static var showVC:MK_BaseNavigationVC?
    
    
    public override init(rootViewController vc:UIViewController){
        super.init(rootViewController: vc)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        MK_BaseNavigationVC.showVC = self
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        MK_BaseNavigationVC.showVC = nil
    }
    
    
}
