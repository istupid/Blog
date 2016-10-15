//
//  XCEmotionTextView.swift
//  Blog
//
//  Created by huaqian58 on 16/10/12.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

class XCEmotionTextView: UITextView {

    func imagesEmotion2Chs() -> String {
        
        var strM = String()
        attributedText.enumerateAttributes(in: NSRange(location: 0, length: attributedText.length), options: []) { (dict, range, stop) in
            // 完成字符串的拼接
            if let attachment = dict["NSAttachment"] as? XCTextAttachment {
                
                // 图片
                strM += (attachment.chs ?? "")
                
            } else {
                
                // 文字
                let subString = (self.text as NSString).substring(with: range)
                strM += subString
            }
        }
        return strM
    }

    func inputEmotion(emotion: XCEmotion) {
        
        // 图片包装到附件对象
        let attachment = XCTextAttachment()
        attachment.chs = emotion.chs
        let bundle = XCEmotionTools.shareEmotionTools.emotionBundle // 获取图片的bundle
        attachment.image = UIImage(named: emotion.imagePath!, in: bundle, compatibleWith: nil)
        let lineHight = font?.lineHeight ?? 0
        attachment.bounds = CGRect(x: 0, y: -5, width: lineHight, height: lineHight)
        
        // 将附件对象包装富文本
        let imageText = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        imageText.addAttributes([NSFontAttributeName: font!], range: NSMakeRange(0, 1))
        
        //3. 获取textView的富文本 --> 可变的属性文本
        let strM = NSMutableAttributedString(attributedString: attributedText)
        // 方法1
        //        strM.append(imageText)
        
        //3.1 在替换之前 记录之前选中的range
        let range = selectedRange
        //4. 向可变的富文本中插入 图片富文本
        strM.replaceCharacters(in: selectedRange, with: imageText)
        
        //5. 将插入完成之后的富文本赋值 给textView.attributeText
        attributedText = strM
        
        //6.赋值结束之后恢复光标位置
        selectedRange = NSMakeRange(range.location + 1, 0)
        
        // 主动调用代理方法
        self.delegate?.textViewDidChange?(self)
    }
}
