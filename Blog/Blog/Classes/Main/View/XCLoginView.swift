//
//  XCLoginView.swift
//  Blog
//
//  Created by huaqian58 on 16/9/23.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit
import SnapKit

// TODO: 协议
@objc protocol XCLoginViewDelegate: NSObjectProtocol {

    @objc optional func userWillLogin()
    
    @objc optional func userWillRegister()

}

class XCLoginView: UIView {
    
    // TODO: 单例
    weak var delegate : XCLoginViewDelegate?
    
    // TODO: 外部显示调用
    func LoginView(title: String, imageName: String? = nil) {
        
        tipLabel.text = title
        
        if imageName == nil {
            // 首页
            startAnimation()
            
        } else {
            
            circleView.image = UIImage(named: imageName!)
            
            iconView.isHidden = true
            
            bringSubview(toFront: circleView)
        }
    }
    
    private func startAnimation() {
    
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = M_PI * 2
        animation.duration = 20
        animation.repeatCount = MAXFLOAT
        
        animation.isRemovedOnCompletion = false
        
        circleView.layer.add(animation, forKey: nil)
    }

    // MARK: 重写构造函数
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        settingComponent()
        
        settingConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: 添加子控件
    func settingComponent() {
        
        addSubview(circleView)
        addSubview(backView)
        addSubview(iconView)
        
        addSubview(tipLabel)
        addSubview(loginBtn)
        addSubview(registBtn)
        
        tipLabel.numberOfLines = 0
        
        let value = CGFloat(237 / 255.0)
        backgroundColor = UIColor(red: value, green: value, blue: value, alpha: 1.0)
        
        // 添加事件
        loginBtn.addTarget(self, action: #selector(loginBtnDidClick), for: .touchUpInside)
        registBtn.addTarget(self, action: #selector(registBtnDidClick), for: .touchUpInside)
    }
    
    @objc private func loginBtnDidClick() {
        
        delegate?.userWillLogin?()
    }
    
    @objc private func registBtnDidClick() {
        
        delegate?.userWillRegister?()
    }

    func settingConstraints() {
        
        circleView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self.snp.centerY).offset(-80)
        }
        
        backView.snp.makeConstraints { (make) in
            make.center.equalTo(circleView)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.center.equalTo(circleView)
        }
        
        tipLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(circleView)
            make.top.equalTo(circleView.snp.bottom).offset(8)
            make.width.equalTo(240)
        }
        
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(tipLabel.snp.bottom).offset(16)
            make.left.equalTo(tipLabel)
            make.width.equalTo(100)
            make.height.equalTo(35)
        }
        
        registBtn.snp.makeConstraints { (make) in
            make.top.equalTo(tipLabel.snp.bottom).offset(16)
            make.right.equalTo(tipLabel)
            make.width.equalTo(100)
            make.height.equalTo(35)
        }
    }
    
    // TODO: 懒加载子控件
    lazy var circleView: UIImageView = UIImageView(image:#imageLiteral(resourceName: "visitordiscover_feed_image_smallicon"))
    
    lazy var backView: UIImageView = UIImageView(image:#imageLiteral(resourceName: "visitordiscover_feed_mask_smallicon"))
    
    lazy var iconView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "visitordiscover_feed_image_house"))
    
    lazy var tipLabel: UILabel = UILabel(text: "什么王毅", textColor: UIColor.darkGray, fontSize: 14)
    
    lazy var loginBtn: UIButton = {
    
        let button = UIButton(title: "登录", titleColor: UIColor.darkGray, fontSize: 14)
        
        button.setBackgroundImage(#imageLiteral(resourceName: "common_button_white"), for: .normal)
        
        return button
    }()
    
    lazy var registBtn: UIButton = {
        let button = UIButton(title: "注册", titleColor: UIColor.orange, fontSize: 14)
        
        button.setBackgroundImage(#imageLiteral(resourceName: "common_button_white"), for: .normal)
        
        return button
    }()
}
