//
//  MK_LiverListCell.swift
//  Search
//
//  Created by 杨尚达 on 2018/10/31.
//  Copyright © 2018年 杨尚达. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift



extension MK_LiverListContentV {
    
    class Item : UICollectionViewCell {
        
        var bag = DisposeBag()
        
        ///主播头像
        lazy var headImV = { () -> UIImageView in
            let res = UIImageView()
            res.layer.cornerRadius = 3
            res.layer.masksToBounds = true
            addSubview(res)
            return res
        }()
        
        ///主播名称
        lazy var liverNameLa = { () -> UILabel in
            let res = UILabel()
            res.font = UIFont.systemFont(ofSize: 10)
            addSubview(res)
            return res
        }()
        
        ///粉丝数
        lazy var fansLa = { () -> UILabel in
            let res = UILabel()
            res.font = UIFont.systemFont(ofSize: 9)
            addSubview(res)
            return res
        }()
        
        ///主播数据模型
        var model:MK_LiverModel?{
            
            didSet{
                
                guard let res = model else {return}
                
                normalY = nil
                liverNameLa.text = res.liverName
                fansLa.text = (res.fansNum)
                
                guard let url = URL.init(string: res.headImURLStr) else {return}
                
                
                headImV.kf.setImage(with: ImageResource.init(downloadURL: url)) {[weak self] (_, _, _, _) in
                    
                    guard let sf = self else {return}
                    ///图片动画
                    let imFrame = sf.headImV.frame
                    let imVCenter = sf.headImV.center
                    sf.headImV.frame.size = CGSize.zero
                    sf.headImV.frame.origin = imVCenter
                    
                    UIView.animate(withDuration: 0.5,
                                   delay: 0, usingSpringWithDamping: 0.3,
                                   initialSpringVelocity: 6,
                                   options: [],
                                   animations: {
                                    sf.headImV.frame = imFrame
                    }, completion: nil)
                }
                
                ///展示动画
                if self.window != nil {
                    self.shouwAnimation()
                }
                
            }
        }
        
        ///上次偏移数值
        var normalY:CGFloat? 
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.00)
            self.layer.cornerRadius = 6
            
            headImV.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(16)
                make.width.height.equalTo(50)
            }
            liverNameLa.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(headImV.snp.bottom).offset(10)
            }
            fansLa.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(liverNameLa.snp.bottom).offset(10)
            }
            
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        override func didMoveToWindow() {
            
            ///展示动画~
            super.didMoveToWindow()
            
            self.shouwAnimation()
            
        }
        
        
        ///展示动画
        func shouwAnimation(){
            
            self.fansLa.alpha = 0.0
            self.liverNameLa.alpha = 0.0
            UIView.animate(withDuration: 0.5) {
                self.fansLa.alpha = 1.0
                self.liverNameLa.alpha = 1.0
            }
            
        }
        
        
    }
    
}
