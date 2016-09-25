//
//  XCDiscoverController.swift
//  Sina
//
//  Created by huaqian58 on 16/9/21.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

class XCDiscoverController: XCBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = XCSearchView.searchView()
        
        loginView.LoginView(title: "回来看看，有什么惊喜", imageName: "visitordiscover_image_message")
        
    }



}
