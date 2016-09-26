//
//  XCBaseController.swift
//  Blog
//
//  Created by huaqian58 on 16/9/23.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

class XCBaseController: UIViewController, XCLoginViewDelegate {

    var userlogin = XCUserAccountViewModel.sharedAccountViewModel.userLogin
    
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
        
        // 跳转到认证页面
        present(UINavigationController(rootViewController:XCOAuthController()), animated: true, completion: nil)
    }
    
    func userWillRegister() {
        print("注册接口")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

   

}
