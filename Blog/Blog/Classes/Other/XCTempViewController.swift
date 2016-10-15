//
//  XCTempViewController.swift
//  Blog
//
//  Created by huaqian58 on 16/10/12.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

class XCTempViewController: UIViewController {

    var urlString: String?
    
    let webView = UIWebView()
    
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        print(urlString)
        if let url = URL(string: urlString ?? "") {
            let req = URLRequest(url: url)
            webView.loadRequest(req)
        }
    }

}
