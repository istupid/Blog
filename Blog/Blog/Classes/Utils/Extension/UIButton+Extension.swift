//
//  UIButton+Extension.swift
//  Blog
//
//  Created by huaqian58 on 16/9/23.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

extension UIButton {

    // TODO: 便利构造函数
    convenience init(title: String, titleColor: UIColor, fontSize: CGFloat) {
        
        self.init();
     
        setTitle(title, for: .normal)
        
        setTitleColor(titleColor, for: .normal)
        
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
        sizeToFit()
    }

}
