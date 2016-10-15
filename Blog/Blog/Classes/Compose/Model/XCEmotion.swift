//
//  XCEmotion.swift
//  Blog
//
//  Created by huaqian58 on 16/10/9.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit
import YYModel

class XCEmotion: NSObject, NSCoding {
    
    //想服务器发送的表情文字
    var chs: String?
    //本地用来匹配文字 显示对应的图片
    var png: String?
    //0 就是图片表情 1 就是Emoji表情
    var type: Int = 0
    //Emoji表情的十六进制的字符串
    var code: String? {
        didSet {
            emojiStr = ((code ?? "") as NSString).emoji()
        }
    }
    
    var imagePath: String?
    
    var emojiStr: String?
    
    override init() {
        super.init()
    }
    
    // 解档
    func encode(with aCoder: NSCoder) {
        yy_modelEncode(with: aCoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        yy_modelInit(with: aDecoder)
    }
}
