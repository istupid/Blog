//
//  XCTabBar.swift
//  Blog
//
//  Created by huaqian58 on 16/9/22.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

class XCTabBar: UITabBar {
    
    // 闭包处理控制器跳转
    var composeClickClosure : (() -> ())?
    
    lazy var composeButton: UIButton = {
        
        let btn = UIButton()
        
        btn.setImage(#imageLiteral(resourceName: "tabbar_compose_icon_add"), for: .normal)
        btn.setBackgroundImage(#imageLiteral(resourceName: "tabbar_compose_button"), for: .normal)
        
        btn.setImage(#imageLiteral(resourceName: "tabbar_compose_icon_add_highlighted"), for: .highlighted)
        btn.setBackgroundImage(#imageLiteral(resourceName: "tabbar_compose_button_highlighted"), for: .highlighted)
        
        btn.sizeToFit()
        
        return btn
    }()
    
    // TODO: 重写构造方法
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        // 添加子控件
        addSubview(composeButton)
        
        composeButton.addTarget(self, action: #selector(composeDidClick), for: .touchUpInside)
    }
    
    func composeDidClick() {
        
        composeClickClosure?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: 重写TabBar布局
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let itemW = bounds.width / 5
        let itemH = bounds.height
        
        // 便利子控件
        var index = 0
        for subview in subviews {
        
            if subview.isKind(of: NSClassFromString("UITabBarButton")!) {
                
                subview.frame = CGRect(x: itemW * CGFloat(index), y: 0, width: itemW, height: itemH)
                
                index += index == 1 ? 2 : 1
            }
        }
        
        //FIXME: 添加中间的按钮
//        composeButton.frame = CGRect(x: itemW * 2, y: 0, width: itemW, height: itemH)
        
        composeButton.bounds.size = CGSize(width: itemW, height: itemH)
        composeButton.center = CGPoint(x: center.x, y: bounds.height * 0.5)
    }

}
