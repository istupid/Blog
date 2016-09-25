//
//  UILabel+Extension.swift
//  Blog
//
//  Created by huaqian58 on 16/9/23.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

extension UILabel {

    // TODO: 便利构造函数
    convenience init(text: String, textColor: UIColor, fontSize: CGFloat) {
        
        self.init();
        
        self.text = text
        
        self.textColor = textColor
        
        self.font = UIFont.systemFont(ofSize: fontSize)
        
        self.textAlignment = .center
        
        sizeToFit()
    }

}
