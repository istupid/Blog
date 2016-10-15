//
//  XCNavigationController.swift
//  Blog
//
//  Created by huaqian58 on 16/9/22.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

class XCNavigationController: UINavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.interactivePopGestureRecognizer?.delegate = self // 解决手势问题
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return childViewControllers.count != 1
    }

    // TODO: 重写Push方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count > 0 {
            
            viewController.hidesBottomBarWhenPushed = true
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", imageName: "navigationbar_back_withtext", target: self, action: #selector(back))
        }
        
        super.pushViewController(viewController, animated: animated)
    }

    @objc private func back() {
        
        popViewController(animated: true)
    }
}
