//
//  AppDelegate.swift
//  Sina
//
//  Created by huaqian58 on 16/9/21.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        registerNotification() // 监听
        
        // 实例化一个窗口
        window = UIWindow()
        
        // 窗口背景
        window?.backgroundColor = UIColor.white
        
        // 设置主窗口
//        window?.rootViewController = XCTabBarController()
//        window?.rootViewController = XCWelcomeController()
        
        let compose = XCComposeController ()
        let nav = UINavigationController(rootViewController: compose)
        
        window?.rootViewController = XCUserAccountViewModel.sharedAccountViewModel.userLogin ? XCWelcomeController() : XCTabBarController()
        
        // 窗口设置为主窗口，并显示
        window?.makeKeyAndVisible()
        
        return true
    }

    // 注册监听
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(setRootViewController(n:)), name: Notification.Name(rawValue:KchangeRootViewController), object: nil)
    }
   
    @objc private func setRootViewController(n: Notification) {
        if n.object == nil {
            
            window?.rootViewController = XCTabBarController()
            
        } else {
            
            window?.rootViewController = XCWelcomeController()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

