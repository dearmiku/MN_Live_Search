//
//  MK_Device.swift
//  Search
//
//  Created by 杨尚达 on 2018/10/25.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

///主窗口
public let KeyWindow = UIApplication.shared.keyWindow!

///主屏幕
public var mainScreen:UIScreen {
    get{
        return UIScreen.main
    }
}
//屏幕宽高
public var ScreenWidth:CGFloat{
    get{
        return UIScreen.main.bounds.size.width
    }
}

public var ScreenHeight:CGFloat{
    get{
        return UIScreen.main.bounds.size.height
    }
}

///分辨率
public var ScreenScale:CGFloat {
    get{
        return UIScreen.main.scale
    }
}



///设备相关信息
public class MK_Device {
    
    static var bag = DisposeBag()
    
    ///导航栏高度 + 状态栏
    public static var navigationBarHight:CGFloat{
        get{
            ///普通iPhone
            if safeArre == UIEdgeInsets.zero {
                return 64.0
                
                ///全面屏系列
            }else{
                if isLandspace {
                    return 32.0
                }else{
                    return 88.0
                }
            }
        }
    }
    ///TabBar + 安全区的高度
    public static var tabbarHight:CGFloat = MK_Device.safeArre.bottom + 49.0
    
    ///状态栏高度
    public static var stateBarHight:CGFloat{
        get{
            if safeArre == UIEdgeInsets.zero {
                return 20
            }else{
                if isLandspace {
                    return 0
                }else{
                    return 44
                }
            }
        }
    }
    
    ///安全区
    public static var safeArre:UIEdgeInsets {
        get{
            if #available(iOS 11.0, *) {
                return KeyWindow.safeAreaInsets
            } else {
                return UIEdgeInsets.zero
            }
        }
    }
    
    
    ///是否横屏
    public static var isLandspace:Bool {
        
        get{
            return ScreenWidth > ScreenHeight
        }
        
    }
    
    
    
    ///软件版本号
    public static let sysVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"]! as! String
    

    
    ///是否横屏
    public static var screenOrignSing = NotificationCenter.default.rx
        .notification(UIDevice.orientationDidChangeNotification).asObservable()
        .filter { (_) -> Bool in
            switch UIDevice.current.orientation {
                
            case .unknown,.faceUp,.faceDown:
                return false
            default:
                return true
            }
        }
        .map { (_) -> Bool in
            switch UIDevice.current.orientation {
                
            case .portrait,.portraitUpsideDown:
                return false
                
            case .landscapeLeft,.landscapeRight:
                return true
                
            default:
                return true
            }
    }
    
}
