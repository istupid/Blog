//
//  XCComposeButton.swift
//  Blog
//
//  Created by huaqian58 on 16/10/6.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

let composeBtnW: CGFloat = 80
let composeBtnH: CGFloat = 110

class XCComposeButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        titleLabel?.textAlignment = .center
        setTitleColor(UIColor.darkGray, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 修改按钮的大小，计算文字大小
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: composeBtnW, width: composeBtnW, height: composeBtnH - composeBtnW)
    }
    
    //
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: composeBtnW, height: composeBtnW)
    }
}
