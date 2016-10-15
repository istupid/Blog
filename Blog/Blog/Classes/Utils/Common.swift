//
//  Common.swift
//  Blog
//
//  Created by huaqian58 on 16/9/25.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit


// 设备屏幕宽高
let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height

let client_id = "3424717392"
let client_secret = "0f51b13762d958f7e8c5e2f7e8268920"
let redirect_uri = "https://github.com/GodWilliam/"

let KchangeRootViewController = "KchangeRootViewController"

let errorTip = "世界上最遥远的距离就是没有网络"

let maxNavY: CGFloat = 64

let sharedDateFormatter = DateFormatter()

func randColor() -> UIColor {
    return UIColor(red: CGFloat(arc4random_uniform(255))/255.0,
                   green: CGFloat(arc4random_uniform(255))/255.0,
                   blue: CGFloat(arc4random_uniform(255))/255.0,
                   alpha: 1.0)
}
