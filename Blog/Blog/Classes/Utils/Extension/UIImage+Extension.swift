//
//  UIImage+Extension.swift
//  Blog
//
//  Created by huaqian58 on 16/10/6.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

extension UIImage {

    // 截取当前屏幕
    class func snapShotCurrentScreen() -> UIImage {
    
        let window = UIApplication.shared.keyWindow!
        
        // 开启图形上下文
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, UIScreen.main.scale)
        
        // 获取图形上下文
        //let context = UIGraphicsGetCurrentContext()
        
        // 将view的layer，渲染到上下文layer中
        //UIView().layer.render(in: context!)
        
        window.drawHierarchy(in: window.bounds, afterScreenUpdates: false)
        
        // 从图形上下文中获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
    
        // 关闭图像上下文
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    //
    func scaleImage(width: CGFloat) -> UIImage {
    
        if self.size.width < width {
            return self
        }
        let imagebounds = CGRect(x: 0, y: 0, width: width, height: self.size.height * width / self.size.width)
        UIGraphicsBeginImageContextWithOptions(imagebounds.size, false, UIScreen.main.scale)
        self.draw(in: imagebounds)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    

}
