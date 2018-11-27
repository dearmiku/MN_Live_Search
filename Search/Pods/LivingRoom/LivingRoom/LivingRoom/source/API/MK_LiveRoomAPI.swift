//
//  MK_LiveRoomAPI.swift
//  LivingRoom
//
//  Created by 杨尚达 on 2018/11/8.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import Alamofire
import Moya



enum MK_LiverRoomTarget {
    
    ///加载直播间详情 (房间号)
    case getLiveRoomInfo(String)
    
    ///加载直播链接 (房间号)
    case getLiveURL(String)
    
}


extension MK_LiverRoomTarget : TargetType {
    
    
    var baseURL: URL {
        switch self {
            
        case .getLiveRoomInfo(_):
            return URL.init(string: "http://open.douyucdn.cn/")!
            
        case .getLiveURL(_):
            return URL.init(string: "https://m.douyu.com/")!
        }
    }
    
    var path: String {
        switch self {
            
        case let .getLiveRoomInfo(roomID):
            return "api/RoomApi/room/\(roomID)"
            
        case .getLiveURL(_):
            return "html5/live"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
            
        case .getLiveRoomInfo(_):
            return Alamofire.HTTPMethod.get
            
        case .getLiveURL(_):
             return Alamofire.HTTPMethod.get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
            
        case .getLiveRoomInfo(_):
            return Task.requestParameters(parameters: [:], encoding: URLEncoding.default)
            
        case let .getLiveURL(roomID):
            return Task.requestParameters(parameters: [
                "roomId":roomID
                ], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
            
        default:
            return nil
        }
    }
    
    
}
