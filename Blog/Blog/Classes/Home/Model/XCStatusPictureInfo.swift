//
//  XCStatusPictureInfo.swift
//  Blog
//
//  Created by huaqian58 on 16/9/26.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

class XCStatusPictureInfo: NSObject {
    
    // 缩略图
    var thumbnail_pic: String? {
        
        didSet {
            let picture: String = thumbnail_pic!
            
            thumbnail_pic = picture.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        }
    
    }

}
