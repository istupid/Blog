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

    let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString).appendingPathComponent("account.plist")
    
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
        
//        loadAccessToken()
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
            
            loadAccessToken(code: code)
            
            return false
        }
        
        return true
    }
    
    internal func loadAccessToken(code: String) {
        
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let parameters = ["client_id":client_id,
                          "client_secret":client_secret,
                          "grant_type":"authorization_code",
                          "code":code,
                          "redirect_uri":redirect_uri]
        
        // 请求方法GET报错
        XCNetworkTools.sharedTools.request(method: .POST, urlString: urlString, parameters: parameters) { (responseObject, error) in
            
            if error != nil {
                return
            }
            
            // 请求用户信息
            self.loadUserInfo(dict: responseObject as! [String : Any])
//            print(responseObject!)
        }
    }
    
    internal func loadUserInfo(dict:[String : Any]) {
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        let parameters = ["access_token":dict["access_token"]!,
                          "uid":dict["uid"]!]
        
        XCNetworkTools.sharedTools.request(method: .GET, urlString: urlString, parameters: parameters) { (responseObject, error) in
            
            if error != nil {
                return
            }
            
            // 获取用户信息，将字典类型转换为模型
            var userInfoDict = responseObject as! [String : Any]
            
            for keyValues in dict {
                userInfoDict[keyValues.key] = keyValues.value
            }
            
//            print(userInfoDict)
            
            // 字典转模型
            let userAccount = XCUserAccount(dict: userInfoDict)
            print(userAccount)
            
            // 模型数据存储到本地
            self.saveUserAccount(userAccount: userAccount)
        }
    }
    
    // MARK: 通过归档存储数据
    private func saveUserAccount(userAccount: XCUserAccount) {
        
        NSKeyedArchiver.archiveRootObject(userAccount, toFile: path)
        
        // 答应保存的路径
        print(path)
    }
}
