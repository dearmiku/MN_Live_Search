//
//  MK_SearcProvider.swift
//  Search
//
//  Created by 杨尚达 on 2018/10/22.
//  Copyright © 2018年 杨尚达. All rights reserved.
//


import Alamofire
import Moya



enum MK_SearchTarget {
    
    
    ///快捷搜索
    case quickSearch(String)
    
    ///全类搜索
    case allSearch(String)
    
    ///主播检索
    case liverSearch(String)
    
    ///直播间检索
    case liveRoomSearch(String)
    
    
}


extension MK_SearchTarget:TargetType{
    
    var baseURL: URL {
        switch self {
            
            
        default:
            return URL.init(string: "https://www.douyu.com/")!
        }
    }
    
    var path: String {
        switch self {
            
        case .quickSearch(_):
            return "search_info/getRecommend"
            
        case .allSearch(_):
            return "search/"
            
        case .liverSearch(_):
            return "search/"
            
        case .liveRoomSearch(_):
            return "search/"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
            
            
        case .quickSearch(_):
            return Alamofire.HTTPMethod.get
            
            
        case .allSearch(_):
            return Alamofire.HTTPMethod.get
            
        case .liverSearch(_):
            return Alamofire.HTTPMethod.get
            
        case .liveRoomSearch(_):
            return Alamofire.HTTPMethod.get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
            
            
        ///快捷搜索
        case let .quickSearch(keyword):
            return Task.requestParameters(parameters: [
                "kw":keyword,
                ], encoding: URLEncoding.default)
            
            
        case let .allSearch(keyword):
           return Task.requestParameters(parameters: [
                "kw":keyword,
                "label":"total",
                "skw":"",
                "type":"live",
                ], encoding: URLEncoding.default)
            
            
        case let .liverSearch(keyword):
            return Task.requestParameters(parameters: [
                "kw":keyword,
                "label":"anchor"
                ], encoding: URLEncoding.default)
            
        case let .liveRoomSearch(keyword):
            return Task.requestParameters(parameters: [
                "kw":keyword,
                "skw":"",
                "label":"live",
                "type":"live"
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
