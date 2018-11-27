//
//  ImageExtension.swift
//  LivingRoom
//
//  Created by 杨尚达 on 2018/11/14.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import UIKit


extension UIImage {
    
    
    ///获取在当前自定义Bundle中的图片
    static func getImageBy(name:String)->UIImage?{
        
        return UIImage.init(named: "LivingRoom.bundle/" + name, in: Bundle.init(for: MK_LiveRoomVC.self), compatibleWith: nil)
        
    }
    
}
