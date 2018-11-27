//
//  ViewController.swift
//  Search
//
//  Created by 杨尚达 on 2018/10/22.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import UIKit
import Moya
import RxSwift


class ViewController: UIViewController {
    
        lazy var provider = MoyaProvider<MK_SearchTarget>.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let vc = MK_SearchHomeVC()
        
        self.present(vc, animated: false, completion: nil)
        
        
    }


}

