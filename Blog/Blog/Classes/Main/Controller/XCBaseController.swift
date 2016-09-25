//
//  XCBaseController.swift
//  Blog
//
//  Created by huaqian58 on 16/9/23.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

class XCBaseController: UIViewController, XCLoginViewDelegate {

    var userlogin = false
    
    lazy var loginView : XCLoginView = XCLoginView()
    
    override func loadView() {
        
        if userlogin {
            
            super.loadView()
            
        } else {
        
            setLoginView()
        }
    }
    
    private func setLoginView() {
        
        view = loginView
        
        loginView.delegate = self
    }
    
    func userWillLogin() {
        print("登录接口")
    }
    
    func userWillRegister() {
        print("注册接口")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

   

}