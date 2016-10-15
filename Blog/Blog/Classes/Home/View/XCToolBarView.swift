//
//  XCBottomView.swift
//  Blog
//
//  Created by huaqian58 on 16/9/28.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit
import SnapKit

class XCToolBarView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        settingComponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func settingComponent() {
    
        addSubview(comment)
        comment.snp.makeConstraints { (make) in
            make.top.leading.equalTo(self)
            make.height.equalTo(self)
        }
        
        addSubview(retweet)
        retweet.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(comment.snp.trailing)
            make.width.equalTo(comment)
            make.height.equalTo(self)
        }
        
        addSubview(unlike)
        unlike.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(retweet.snp.trailing)
            make.trailing.equalTo(self)
            make.width.equalTo(retweet)
            make.height.equalTo(self)
        }
    }
    
    // TODO: 懒加载控件
    private lazy var comment: UIButton = {
        let button = UIButton(imageString:"timeline_icon_comment",title: "评论", titleColor: UIColor.orange, fontSize: 14)
        
        return button
    }()
    
    private lazy var retweet: UIButton = {
        let button = UIButton(imageString:"timeline_icon_retweet", title: "转发", titleColor: UIColor.orange, fontSize: 14)
        
        return button
    }()
    
    private lazy var unlike: UIButton = {
        let button = UIButton(imageString:"timeline_icon_unlike", title: "点赞", titleColor: UIColor.orange, fontSize: 14)
        
        return button
    }()
    
    var statusModel: XCStatusViewModel? {
        didSet {
            comment.setTitle(statusModel?.comment_text, for: .normal)
            retweet.setTitle(statusModel?.repost_text, for: .normal)
            unlike.setTitle(statusModel?.ohYeahText, for: .normal)
        }
    }
}
