//
//  MK_LiveRoomCell.swift
//  Base
//
//  Created by 杨尚达 on 2018/11/22.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher


///直播间列表cell
public class MK_LiveRoomCell:UICollectionViewCell {
    
    ///直播间缩略图
    lazy var roomImV = { () -> UIImageView in
        let res = UIImageView()
        addSubview(res)
        return res
    }()
    
    ///主播头像缩率图
    lazy var liverHeadImV = { () -> UIImageView in
        let res = UIImageView()
        addSubview(res)
        return res
    }()
    
    ///房间名称
    lazy var roomNameLa = { () -> UILabel in
        let res = UILabel()
        res.font = UIFont.systemFont(ofSize: 12)
        addSubview(res)
        return res
    }()
    
    ///分类名称名称
    lazy var cateNameLa = { () -> UILabel in
        let res = UILabel()
        res.textAlignment = .right
        res.font = UIFont.systemFont(ofSize: 8)
        res.textColor = UIColor(red:0.99, green:0.40, blue:0.13, alpha:1.00)
        addSubview(res)
        return res
    }()
    
    ///主播名称
    lazy var liverNameLa = { () -> UILabel in
        let res = UILabel()
        res.textAlignment = .right
        res.font = UIFont.systemFont(ofSize: 8)
        res.textColor = UIColor.gray
        addSubview(res)
        return res
    }()
    
    ///关注数
    lazy var fansLa = { () -> UILabel in
        let res = UILabel()
        res.font = UIFont.systemFont(ofSize: 8)
        res.textColor = UIColor.gray
        addSubview(res)
        return res
    }()
    
    ///模型
    public var model:MK_LiveRoomCellModelProtocol? {
        didSet{
            guard let res = model else {return}
            
            roomNameLa.text = res.roomNameStr
            cateNameLa.text = res.cateNameStr
            fansLa.text = res.hotNumStr
            liverNameLa.text = res.liverNameStr
            
            if let roomURL = URL.init(string: res.liveRoomImStr){
                
                roomImV.kf.setImage(with: ImageResource.init(downloadURL: roomURL))
            }
            
            if let headURL = URL.init(string: res.liveHeadImStr){
                
                liverHeadImV.kf.setImage(with: ImageResource.init(downloadURL: headURL))
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.00)
        self.layer.cornerRadius = 6
        
        roomImV.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(6)
            make.right.equalToSuperview().offset(-6)
            make.height.equalTo(roomImV.snp.width).multipliedBy(0.57)
        }
        
        liverHeadImV.snp.makeConstraints { (make) in
            make.left.equalTo(roomImV)
            make.top.equalTo(roomImV.snp.bottom).offset(5)
            make.height.width.equalTo(50)
        }
        roomNameLa.snp.makeConstraints { (make) in
            make.left.equalTo(liverHeadImV.snp.right).offset(5)
            make.right.equalToSuperview().offset(-80)
            make.top.equalTo(liverHeadImV)
        }
        liverNameLa.snp.makeConstraints { (make) in
            make.left.equalTo(roomNameLa)
            make.bottom.equalTo(liverHeadImV)
        }
        cateNameLa.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-5)
            make.left.equalTo(roomNameLa.snp.right).offset(3)
            make.top.equalTo(liverHeadImV)
        }
        fansLa.snp.makeConstraints { (make) in
            make.right.equalTo(cateNameLa)
            make.bottom.equalTo(liverHeadImV)
        }
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
