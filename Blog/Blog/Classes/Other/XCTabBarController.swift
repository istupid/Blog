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

        // 创建tabbar
        createControllers()
    }

    // 创建控制器
    func createControllers() {
        
        // 主页
        createController(viewController: XCHomeController(), imageString: "", title: "Home")
        

        
        // 消息
        let msg = XCMsgController()
        msg.title = "Message"
        let msgNavi = UINavigationController(rootViewController: msg)
        
        // 发现
        let discover = XCDiscoverController()
        let discoverNavi = UINavigationController(rootViewController: discover)
        
        let me = XCMeController()
        me.title = "Me"
        let meNavi = UINavigationController(rootViewController: me)
        
        
    }
    
    func createController(viewController:UIViewController, imageString:String, title:String) {
        
        // 设置标题
        viewController.tabBarItem.title = title
        
        // 设置图片
        viewController.tabBarItem.image = UIImage(named: imageString)
        
        let navi = UINavigationController()
        
        addChildViewController(navi)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
