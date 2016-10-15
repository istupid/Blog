//
//  XCTabBarController.swift
//  Sina
//
//  Created by huaqian58 on 16/9/21.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

class XCTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 自定义TabBar
        let tabBar = XCTabBar()
        setValue(tabBar, forKey: "tabBar")
        
        tabBar.composeClickClosure = { [weak self] in
            
            let composeView = XCComposeView(frame: UIScreen.main.bounds)
            
            composeView.show(target: self)
        }
        
        // 创建tabbar
        createControllers()
        
    }

    // TODO: 创建控制器
    func createControllers() {
        
        // 主页
        createController(viewController: XCHomeController(), imageString: "tabbar_home", title: "Home", tag: 0)
        
        // 消息
        createController(viewController: XCMsgController(), imageString: "tabbar_message_center", title: "Message", tag: 1)
        
        // 发现
        createController(viewController: XCDiscoverController(), imageString: "tabbar_discover", title: "Discover", tag: 2)
        
        // 自己
        createController(viewController: XCMeController(), imageString: "tabbar_profile", title: "Me", tag: 3)
        
    }
    
    // MARK: 添加控制器
    func createController(viewController:UIViewController, imageString:String, title:String, tag: Int) {
        
        // 设置标题
        viewController.tabBarItem.title = title
        viewController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orange], for: .selected)
        // 字体大小
        viewController.tabBarItem.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 12)], for: .normal)
        
        // 设置图片
        viewController.tabBarItem.image = UIImage(named: imageString)
        viewController.tabBarItem.selectedImage = UIImage(named: imageString+"_selected")?.withRenderingMode(.alwaysOriginal)
        
        viewController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
        
        viewController.tabBarItem.tag = tag
        
        let navi = XCNavigationController(rootViewController: viewController)
        
        addChildViewController(navi)
    }

    // MARK: 当用户点击UITabBarButton就会触发改事件
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        var index = 0
        for subview in tabBar.subviews {
            
            if subview.isKind(of: NSClassFromString("UITabBarButton")!) {
             
                if index == item.tag {
                
                    for target in subview.subviews {
                        
                        if target.isKind(of: NSClassFromString("UITabBarSwappableImageView")!) {
                        
                            // 修改transform
                            target.transform = CGAffineTransform.init(scaleX: 0.4, y: 0.4)
                        
                            // 在动画闭包中执行放大的操作
                            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: { 
                                target.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                                }, completion: { (_) in
                                    //print("OK")
                            })
                        }
                    }
                }
                
                index += 1
            }
        }
    }
    
}
