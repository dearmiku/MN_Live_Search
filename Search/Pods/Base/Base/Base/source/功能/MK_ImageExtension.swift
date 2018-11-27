//
//  MK_ImageExtension.swift
//  Search
//
//  Created by 杨尚达 on 2018/10/25.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import UIKit



public extension UIImage {
    
    ///获取在当前自定义Bundle中的图片
    public static func getImageBy(name:String,classTy:AnyClass,ModelName:String)->UIImage?{

        return UIImage.init(named: "\(ModelName).bundle/" + name, in: Bundle.init(for: classTy), compatibleWith: nil)
        
    }
    
}
