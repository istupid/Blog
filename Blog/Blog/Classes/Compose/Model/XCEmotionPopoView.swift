//
//  XCEmotionPopoView.swift
//  Blog
//
//  Created by huaqian58 on 16/10/10.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit
import pop

class XCEmotionPopoView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        settingComponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func settingComponent() {
    
        addSubview(bgImage)
        
        addSubview(button)
        
        bgImage.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        button.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(bgImage)
            make.width.height.equalTo(64)
        }
    
    }
    
    private lazy var bgImage: UIImageView = {
        let bgImage = UIImageView()
        bgImage.image = #imageLiteral(resourceName: "emoticon_keyboard_magnifier")
        bgImage.sizeToFit()
        return bgImage
    }()
    
    lazy var button: XCEmotionButton = XCEmotionButton()
    
    var lastEmotion: XCEmotion?
    
    // 动画
    func show() {
//        print("show --> " + "\(lastEmotion?.chs)，\(lastEmotion?.code)")
//        print("show --> " + "\(button.emotion?.chs)，\(button.emotion?.code)")
        if let em = lastEmotion {
            if em.chs == button.emotion?.chs && em.code == button.emotion?.code{
                return
            }
//            if em.code == button.emotion?.code {
//                return
//            }
        }
//        print("------------")
        let anim = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
        
        anim?.fromValue = 40
        anim?.toValue = 32
        
        anim?.springSpeed = 20
        anim?.springBounciness = 20
        
        button.pop_add(anim, forKey: nil)
        
        lastEmotion = button.emotion
    }

}
