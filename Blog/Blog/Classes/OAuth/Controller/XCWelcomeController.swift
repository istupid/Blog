//
//  XCWelcomeController.swift
//  Blog
//
//  Created by huaqian58 on 16/9/25.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit
import SDWebImage

private let bottonH: CGFloat = 120

class XCWelcomeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingComponent()
    }

    private func settingComponent() {
        
        view.addSubview(iconView)
        
        view.addSubview(titleLabel)
        
        iconView.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(view).offset(-bottonH)
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 85, height: 85))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(iconView.snp.bottom).offset(20)
            make.centerX.equalTo(iconView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        startAnimation()
    }
    
    // TODO: 移动子控件
    private func startAnimation() {
        
        let offsetX = -(UIScreen.main.bounds.height - bottonH - 85)
        
        iconView.snp.updateConstraints { (make) in
            make.bottom.equalTo(view).offset(offsetX)
        }
        
        // usingSpringWithDamping 弹簧阻力系数 0-1 initialSpringVelocity 加速度
        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: [], animations: { 
            
                self.view.layoutIfNeeded()
            
            }) { (_) in
              
                UIView.animate(withDuration: 0.5, animations: {
                    
                    self.titleLabel.alpha = 1
                    }, completion: {(_) in
                        NotificationCenter.default.post(name: Notification.Name(KchangeRootViewController), object: nil)
                })
        }
        
    }
    
    
    // TODO: 懒加载子控件
    
    private lazy var iconView: UIImageView = {
    
        let iconView = UIImageView() // UIImageView(image: #imageLiteral(resourceName: "avatar_default_big"))
        iconView.sd_setImage(with: XCUserAccountViewModel.sharedAccountViewModel.iconURL, placeholderImage:#imageLiteral(resourceName: "avatar_default_big"))
        
        iconView.cornerRadius = 42.5
        
        iconView.layer.borderWidth = 1
        
        iconView.layer.borderColor = UIColor.orange.cgColor
        
        return iconView
    }()

    private lazy var titleLabel: UILabel = {
        
        let titleLabel = UILabel(text: "欢迎归来，🌹", textColor: UIColor.darkGray, fontSize: 16)
        
        titleLabel.alpha = 0
        
        return titleLabel
    }()
}
