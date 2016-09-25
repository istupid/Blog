//
//  XCUserAccount.swift
//  Blog
//
//  Created by huaqian58 on 16/9/25.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

class XCUserAccount: NSObject, NSCoding {
    
    var access_token: String?
    
    // 过期
    var expires_in: Int = 0 {
        didSet {
            expires_date = Date(timeIntervalSinceNow: Double(expires_in))
        }
    }
    //替代过期时间
    var expires_date: Date?
    
    //授权用户的UID，本字段只是为了方便开发者，减少一次user/show接口调用而返回的，第三方应用不能用此字段作为用户登录状态的识别，只有access_token才是用户授权的唯一票据。
    var uid: String?
    
    var name: String?
    
    var avatar_large: String?
    
    // TODO: 字典转模型
    init(dict: [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    // 未定义字段处理
    override func setValue(_ value: Any?, forUndefinedKey key: String) {    }
    
    // MARK: 归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
//        aCoder.encode(expires_in, forKey: "expires_in")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(expires_date, forKey: "expires_date")
    }
    
    // MARK: 解档
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? Date
    }
    
}
