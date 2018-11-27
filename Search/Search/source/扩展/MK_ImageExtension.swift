//
//  MK_ImageExtension.swift
//  Search
//
//  Created by 杨尚达 on 2018/10/25.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import UIKit
import Base



extension UIImage {
    
    
    ///获取在当前自定义Bundle中的图片
    static func getImageBy(name:String)->UIImage?{

        return UIImage.getImageBy(name: name, classTy: MK_SearchMainVC.self, ModelName: "Search")
    }
    
}
