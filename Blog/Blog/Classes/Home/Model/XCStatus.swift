//
//  XCStatus.swift
//  Blog
//
//  Created by huaqian58 on 16/9/26.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit
import YYModel

class XCStatus: NSObject, YYModel {
    
    var id: Int = 0 // Int 看机型，32位机型上面会出错
    
    var text: String?
    
    var created_at: String? // 创建时间
    
    var source: String? // 来源
    
    var user: XCUser?   // 用户信息
    
    var pic_urls: [XCStatusPictureInfo]? //配视图的模型数组
    
    var comments_count: Int = 0     // 评论数
    
    var reposts_count: Int = 0      // 转发数
    
    var attitudes_count: Int = 0    // 点赞数
    
    var retweeted_status: XCStatus? // 被转发的原创微博
    
    class func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["pic_urls" : XCStatusPictureInfo.self]
    }
    
//    init(dict: [String : Any]) {
//        super.init()
//        setValuesForKeys(dict)
//    }
    
//    override func setValue(_ value: Any?, forUndefinedKey key: String) { }

}
