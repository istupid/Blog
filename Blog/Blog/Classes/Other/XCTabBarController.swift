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
            
            print("接口未写"+"\(self)")
        }
        
        // 创建tabbar
        createControllers()
        
    }

    // TODO: 创建控制器
    func createControllers() {
        
        // 主页
        createController(viewController: XCHomeController(), imageString: "tabbar_home", title: "Home")
        
        // 消息
        createController(viewController: XCMsgController(), imageString: "tabbar_message_center", title: "Message")
        
        // 发现
        createController(viewController: XCDiscoverController(), imageString: "tabbar_discover", title: "Discover")
        
        // 自己
        createController(viewController: XCMeController(), imageString: "tabbar_profile", title: "Me")
        
    }
    
    // MARK: 添加控制器
    func createController(viewController:UIViewController, imageString:String, title:String) {
        
        // 设置标题
        viewController.tabBarItem.title = title
        viewController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orange], for: .selected)
        // 字体大小
        viewController.tabBarItem.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 12)], for: .normal)
        
        // 设置图片
        viewController.tabBarItem.image = UIImage(named: imageString)
        viewController.tabBarItem.selectedImage = UIImage(named: imageString+"_selected")?.withRenderingMode(.alwaysOriginal)
        
        viewController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
        
        
        let navi = XCNavigationController(rootViewController: viewController)
        
        addChildViewController(navi)
    }

}
