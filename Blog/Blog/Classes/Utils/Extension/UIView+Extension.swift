//
//  UIView+Extension.swift
//  Blog
//
//  Created by huaqian58 on 16/9/22.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

extension UIView {

    // 视图的响应者链 查找导航视图控制器 -> 跳转页面
    func navController() -> UINavigationController? {
    
        // 1. 获取当前视图对象的下一个响应者
        var next = self.next
        
        // 循环遍历响应者链
        while next != nil {
            // 1. 先判断next 是否为UINavigationController
            if let resp = next as? UINavigationController {
                return resp
            }
            
            // 如果不是 就获取next 的下一个响应者
            next = next?.next
        }
        return nil
    }
}
