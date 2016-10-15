//
//  XCUser.swift
//  Blog
//
//  Created by huaqian58 on 16/9/26.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

class XCUser: NSObject {

    // 用户名
    var name: String?
    
    // 用户头像
    var avatar_large: String?
    
    // 认证类型：-1 没有认证，0 认证用户，2 3 5 企业认证，220 达人
    var verified_type: Int = 0
    
    // 会员认证
    var mbrank: Int = 0
    
}
