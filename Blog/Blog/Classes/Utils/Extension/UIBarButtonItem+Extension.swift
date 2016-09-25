//
//  UIBarButtonItem+Extension.swift
//  Blog
//
//  Created by huaqian58 on 16/9/22.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

extension UIBarButtonItem {

    // TODO: 便利构造函数
    convenience init(title: String = "", imageName: String? = nil, target: Any?, action: Selector?) {
        
        let button = UIButton()
        
        if let imageName = imageName {
            button.setImage(UIImage(named:imageName), for: .normal)
            button.setImage(UIImage(named:imageName + "_highlighted"), for: .highlighted)
        }
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setTitleColor(UIColor.orange, for: .highlighted)
        button.sizeToFit() // 不加显示不出
        
        if let target = target, let action = action {
            
            button.addTarget(target, action: action, for: .touchUpInside)
        }
        
        self.init()
        
        self.customView = button
    }

}
