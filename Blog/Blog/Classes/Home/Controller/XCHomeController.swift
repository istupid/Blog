//
//  XCHomeController.swift
//  Sina
//
//  Created by huaqian58 on 16/9/21.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

class XCHomeController: XCBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(push))
        
        loginView.LoginView(title: "关注一些人，有惊喜")
    }

    @objc private func push() {
        
        let temp = UIViewController()
        
        temp.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(temp, animated: true)
    }
    
}
