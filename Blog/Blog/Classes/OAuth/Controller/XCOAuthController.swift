//
//  XCOAuthController.swift
//  Blog
//
//  Created by huaqian58 on 16/9/25.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit
import SVProgressHUD


class XCOAuthController: UIViewController {
    
    lazy var webView: UIWebView = {
        
        let webView = UIWebView()
        
        // 透明 解决webview没有数据的时候黑条
        webView.isOpaque = false
        
        webView.delegate = self
        
        webView.backgroundColor = UIColor.white
        
        return webView
    }()
    
    override func loadView() {
        view = webView
        
        setNaviBar()
        
        loadOAuthPage()
    }
    
    @objc private func setNaviBar() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "close", target: self, action: #selector(close))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "fillAccount", target: self, action: #selector(fillAccount))
    }
    
    @objc private func loadOAuthPage() {

        let urlString = "https://api.weibo.com/oauth2/authorize?"+"client_id=\(client_id)"+"&redirect_uri=\(redirect_uri)"
        
        let reuqest = URLRequest(url: URL(string: urlString)!)
        
        webView.loadRequest(reuqest)
    }

    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func fillAccount() {
    
        let jsString = "document.getElementById('userId').value = 'mr_xiongchun@sina.com',document.getElementById('passwd').value = '130480519dq'"
        webView.stringByEvaluatingJavaScript(from: jsString)
    }
}

extension XCOAuthController: UIWebViewDelegate {

    func webViewDidStartLoad(_ webView: UIWebView) {
        // 开始加载页面
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // 页面加载完成
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 获取重定向url
        let urlString = request.url?.absoluteString ?? ""
        let flag = "code="
        if urlString.contains("code=") {
            
            let query = request.url?.query ?? ""
            
            // 方法选错to,错误
            let code = (query as NSString).substring(from: flag.characters.count)
            
            // viewmodel 加载数据
            XCUserAccountViewModel.sharedAccountViewModel.loadAccessToken(code: code, finished: {(success) in
                
                if !success {
                    SVProgressHUD.showError(withStatus: errorTip)
                    return
                }
                SVProgressHUD.dismiss()
//                // 回到主页面（不是home）
//                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: NSNotification.Name(KchangeRootViewController), object: "Welcome")
                
            })
            
            return false
        }
        
        return true
    }
}
