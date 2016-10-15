//
//  XCEmotionButton.swift
//  Blog
//
//  Created by huaqian58 on 16/10/10.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

class XCEmotionButton: UIButton {

    var emotion: XCEmotion? {

        didSet {
            let bundle = XCEmotionTools.shareEmotionTools.emotionBundle
            
            if emotion?.type == 0 {
                let image = UIImage(named: emotion?.imagePath ?? "", in: bundle, compatibleWith: nil)
                self.setImage(image, for: .normal)
                self.setTitle(nil, for: .normal)
            } else {
                self.setTitle(emotion?.emojiStr, for: .normal)
                self.titleLabel?.font = UIFont.systemFont(ofSize: 32)
                self.setImage(nil, for: .normal)
            }
        }
    }
    

}
