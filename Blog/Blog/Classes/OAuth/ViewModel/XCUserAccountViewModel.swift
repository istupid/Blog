//
//  XCUserAccountViewModel.swift
//  Blog
//
//  Created by huaqian58 on 16/9/25.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

// viewmodel 负责请求网络数据，封装数据处理的逻辑

private let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString).appendingPathComponent("account.plist")

// 有且只有一处处于登录
class XCUserAccountViewModel: NSObject {
    
    static let sharedAccountViewModel = XCUserAccountViewModel()
    
    // 用于判断用户是否登录
    var userAccount: XCUserAccount? {
        didSet {
        
            iconURL = URL(string: userAccount?.avatar_large ?? "")
        }
    }
    var iconURL: URL?
    
    // TODO: 获取本地保存的用户信息
    override init() {
        super.init()
        userAccount = loadUserAccount()
        iconURL = URL(string: userAccount?.avatar_large ?? "")
    }
    
    // 判断用户是否登录
    var userLogin: Bool {
        
        if userAccount?.access_token != nil && isExpires == false {
            return true
        }
        return false
    }
    // 判断是否过期
    var isExpires: Bool {
        
        if userAccount?.expires_date?.compare(Date()) == ComparisonResult.orderedDescending {
            // 没有过期
            return false
        }
        
        return true
    }
    
    
    internal func loadAccessToken(code: String, finished: @escaping(Bool) -> ()) {
        
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let parameters = ["client_id":client_id,
                          "client_secret":client_secret,
                          "grant_type":"authorization_code",
                          "code":code,
                          "redirect_uri":redirect_uri]
        
        // 请求方法GET报错
        XCNetworkTools.sharedTools.request(method: .POST, urlString: urlString, parameters: parameters) { (responseObject, error) in
            
            if error != nil {
                finished(false) // 错误闭包回调
                return
            }
            
            // 请求用户信息，传递闭包
            self.loadUserInfo(dict: responseObject as! [String : Any], finished: finished)
        }
    }
    
    private func loadUserInfo(dict:[String : Any], finished: @escaping(Bool) -> ()) {
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        let parameters = ["access_token":dict["access_token"]!,
                          "uid":dict["uid"]!]
        
        XCNetworkTools.sharedTools.request(method: .GET, urlString: urlString, parameters: parameters) { (responseObject, error) in
            
            if error != nil {
                finished(false)
                return
            }
            
            // 获取用户信息，将字典类型转换为模型
            var userInfoDict = responseObject as! [String : Any]
            
            for keyValues in dict {
                userInfoDict[keyValues.key] = keyValues.value
            }
            
            // 字典转模型
            let userAccount = XCUserAccount(dict: userInfoDict)
            
            // 模型数据存储到本地
            self.saveUserAccount(userAccount: userAccount)
            
            // TODO: 登录成功 内存中保存用户信息
            self.userAccount = userAccount
            
            finished(true) //成功
        }
    }
    
    // MARK: 通过归档存储数据
    private func saveUserAccount(userAccount: XCUserAccount) {
        
        NSKeyedArchiver.archiveRootObject(userAccount, toFile: path)
    }

    // MARK: 解档存储的数据
    private func loadUserAccount() -> XCUserAccount? {
        
        return NSKeyedUnarchiver.unarchiveObject(withFile: path) as? XCUserAccount
    }

}
