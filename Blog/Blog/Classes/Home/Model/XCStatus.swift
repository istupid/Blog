//
//  XCStatus.swift
//  Blog
//
//  Created by huaqian58 on 16/9/26.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

class XCStatus: NSObject {
    
    var id: Int = 0 // Int 看机型，32位机型上面会出错
    
    var text: String?
    
    var created_at: String? // 创建时间
    
    var source: String? // 来源
    
//    init(dict: [String : Any]) {
//        super.init()
//        setValuesForKeys(dict)
//    }
    
//    override func setValue(_ value: Any?, forUndefinedKey key: String) { }

}
