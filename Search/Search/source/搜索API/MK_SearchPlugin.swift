//
//  MK_SearchPlugin.swift
//  Search
//
//  Created by 杨尚达 on 2018/11/5.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import SwiftSoup
import Moya
import Result


///搜索API Target 插件
class  MK_Search_Plugin {
    
    
    ///针对全类搜索的处理-> (主播数组)
    static func analyAllSearchWith(str:String)->([MK_LiverModel]){
        
        guard let doc = try? SwiftSoup.parse(str) else {
            return []
        }
        
        ///获取检索主播列表
        guard let anchor_list = try? doc.getElementsByClass("anchor-card") else {
            return []
        }
        
        var liverModelArr:[MK_LiverModel] = []
        
        ///遍历检索列表
        for item in anchor_list.array() {
            
            var model = MK_LiverModel()
            
            ///获取主播头像
            if let avatar = try? item.getElementsByClass("anchor-avatar"),
                let res = (try? avatar.select("img").attr("data-original")) {
                
                model.headImURLStr = res
            }
            
            
            ///获取主播姓名
            if let nameEl = try? item.getElementsByClass("anchor-name"),
                let name = try? nameEl.text()  {
                
                model.liverName = name
            }
            
            
            ///获取关注数
            if let fansEl = try? item.getElementsByClass("anchor-info"),
                let fans = try? fansEl.text()  {
                
                model.fansNum = fans
            }
            
            ///获取房间号
            if let roomIdEl = try? item.getElementsByClass("anchor-action-btn"),
                let roomID = try? roomIdEl.attr("data-room_id"){
                
                model.liverRoomID = roomID
            }
            
            liverModelArr.append(model)
            
        }
        
        return liverModelArr
        
    }
    
    
    ///针对全类搜索数据的解析 --> (直播间数组)
    static func analyAllSearchToLiveRoomWith(str:String)->[MK_LiveRoomModel]{
        
        guard let doc = try? SwiftSoup.parse(str) else {
            return []
        }
        
        ///获取检索主播列表
        guard let room_list = (try? doc.getElementsByClass("play-list").array().first) as? Element else {
            return []
        }
        
        var res:[MK_LiveRoomModel] = []
        
        ///遍历直播间列表
        for item in room_list.children() {
            
            var model = MK_LiveRoomModel()
            
            ///获取 房间名称 与 房间id
            guard let room_ela = try? item.select("a"),
            let roomTitle = try? room_ela.attr("title"),
            let room_id = try? room_ela.attr("data-rid") else {
                return []
            }
            
            model.roomID = room_id
            model.roomName = roomTitle
            
            ///房间缩略图
            guard let roomImStr = try? room_ela.select("img").attr("data-original") else {
                return []
            }
            model.roomImStr = roomImStr
            
            ///主播相关
            guard let mesEl = (try? item.getElementsByClass("mes").first()) as? Element else {
                return []
            }
            
            ///主播名称
            guard let liverNameEl = try? mesEl.getElementsByClass("dy-name ellipsis fl"),
            let liverName = try? liverNameEl.text() else {
                return []
            }
            
            model.liverName = liverName
            
            ///直播间分类名称
            guard let catStr = try? mesEl.getElementsByClass("tag ellipsis").text() else {
                return []
            }
            model.catName = catStr
            
            
            ///主播缩略头像
            guard let liverHeadStr = try? mesEl.select("img").attr("data-original") else {
                return []
            }
            
            model.liverHeadStr = (liverHeadStr as NSString).replacingOccurrences(of: "_small", with: "_middle")
            
            ///关注数
            guard let fansStr = try? mesEl.getElementsByClass("dy-follow fr").text() else {
                return []
            }
            
            model.fansNum = fansStr
            
            res.append(model)
        }
        return res
    }
    
    
}
