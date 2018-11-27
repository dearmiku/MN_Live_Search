//
//  MK_LiveRoomCellModelProtocol.swift
//  Base
//
//  Created by 杨尚达 on 2018/11/22.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import Foundation


///直播间模型协议
public protocol MK_LiveRoomCellModelProtocol {
    
    ///房间名
    var roomNameStr:String {get}
    
    ///分类名称
    var cateNameStr:String {get}
    
    ///粉丝热度名称
    var hotNumStr:String {get}
    
    ///主播名称
    var liverNameStr:String {get}
    
    ///主播头像链接字符串
    var liveHeadImStr:String {get}
    
    ///直播间头像链接字符串
    var liveRoomImStr:String {get}
    
    ///房间号
    var roomIdStr:String {get}
    
    
}
