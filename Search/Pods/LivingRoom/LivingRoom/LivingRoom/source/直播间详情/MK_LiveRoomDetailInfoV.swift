//
//  MK_LiveRoomDetailInfoV.swift
//  LivingRoom
//
//  Created by 杨尚达 on 2018/11/8.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import Kingfisher



///直播间详情展示
class MK_LiveRoomDetailInfoV : UIView {
    
    var bag = DisposeBag()
    
    ///vm
    let vm = MK_LiveRoomDetailInfoVM()
    
    
    ///主播头像
    lazy var liverImV = { () -> UIImageView in
        let res = UIImageView()
        addSubview(res)
        return res
    }()
    
    ///房间名称La
    lazy var roomNameLa = { () -> UILabel in
        let res = UILabel()
        res.font = UIFont.systemFont(ofSize: 12)
        res.numberOfLines = 0
        addSubview(res)
        return res
    }()
    
    ///房间分类名称La
    lazy var roomCatNameLa = { () -> UILabel in
        let res = UILabel()
        res.font = UIFont.systemFont(ofSize: 9)
        addSubview(res)
        return res
    }()
    
    ///主播名称
    lazy var liverNameLa = { () -> UILabel in
        let res = UILabel()
         res.font = UIFont.systemFont(ofSize: 8)
        addSubview(res)
        return res
    }()
    
    
    ///房间热度La
    lazy var hotNumLa = { () -> UILabel in
        let res = UILabel()
        res.font = UIFont.systemFont(ofSize: 8)
        addSubview(res)
        return res
    }()
    
    ///关注数
    lazy var fansNumLa = { () -> UILabel in
        let res = UILabel()
        res.font = UIFont.systemFont(ofSize: 8)
        addSubview(res)
        return res
    }()
    
    
    ///是否在直播
    lazy var isShowLa = { () -> UILabel in
        let res = UILabel()
        res.font = UIFont.systemFont(ofSize: 8)
        addSubview(res)
        return res
    }()
    
    
    ///最后开播时间
    lazy var lastLiveTime = { () -> UILabel in
        let res = UILabel()
        res.font = UIFont.systemFont(ofSize: 8)
        addSubview(res)
        return res
    }()
    
    
    init(){
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.white
        
        liverImV.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(liverImV.snp.height)
        }
        roomNameLa.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(liverImV.snp.right).offset(12)
            make.right.equalToSuperview().offset(-50)
        }
        
        isShowLa.snp.makeConstraints { (make) in
            make.top.equalTo(roomNameLa)
            make.right.equalToSuperview().offset(-10)
        }
        
        liverNameLa.snp.makeConstraints { (make) in
            make.left.equalTo(roomNameLa)
            make.top.equalTo(roomNameLa.snp.bottom).offset(6)
        }
        roomCatNameLa.snp.makeConstraints { (make) in
            make.centerY.equalTo(liverNameLa)
            make.right.equalToSuperview().offset(-12)
        }
        hotNumLa.snp.makeConstraints { (make) in
            make.left.equalTo(liverNameLa)
            make.top.equalTo(liverNameLa.snp.bottom).offset(6)
        }
        lastLiveTime.snp.makeConstraints { (make) in
            make.top.equalTo(hotNumLa.snp.bottom).offset(6)
            make.left.equalTo(hotNumLa)
        }
        fansNumLa.snp.makeConstraints { (make) in
            make.centerY.equalTo(lastLiveTime)
            make.right.equalToSuperview().offset(-12)
        }
        
        
        ///对模型进行订阅
        vm.roomInfoV.skip(1).subscribe(onNext: {[weak self] (res) in
            
            guard let sf = self else {return}
            
            sf.roomNameLa.text = res.room_name
            sf.liverNameLa.text = res.owner_name
            sf.roomCatNameLa.text = res.cate_name
            sf.hotNumLa.text = "热度:\(res.online)"
            sf.lastLiveTime.text = "最后开播:\(res.start_time)"
            sf.fansNumLa.text = "关注数:\(res.fans_num)"
            
            if res.room_status == "1"{
                sf.isShowLa.text = "直播中"
            }else{
                sf.isShowLa.text = "未开播"
            }
            
            if let url = URL.init(string: res.avatar){
                
                sf.liverImV.kf.setImage(with: ImageResource.init(downloadURL: url))
            }
            
        }).disposed(by: bag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
