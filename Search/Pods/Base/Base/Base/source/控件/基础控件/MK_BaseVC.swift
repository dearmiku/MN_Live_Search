//
//  MK_BaseVC.swift
//  Search
//
//  Created by 杨尚达 on 2018/11/16.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import UIKit
import RxSwift

///基础视图控制器
open class MK_BaseVC: UIViewController {
    
    public var bag = DisposeBag.init()
    
    ///是否显示NavigationBar
    public var isShowNavigationBar = true
    
    ///状态栏样式
    var stateBarStyle:UIStatusBarStyle {
        get{
            return UIStatusBarStyle.lightContent
        }
    }
    
    ///navigationBar图像
    public var navigationBarBackGroundIm:UIImage? = nil
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(navigationBarBackGroundIm, for: UIBarMetrics.default)
        self.navigationController?.setNavigationBarHidden(!isShowNavigationBar, animated: true)
    }
    
    override open var prefersStatusBarHidden: Bool{
        return false
    }
    
    deinit {
        print("控制器完成回收~")
    }
}
