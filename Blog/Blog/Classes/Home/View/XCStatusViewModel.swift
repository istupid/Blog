//
//  XCStatusViewModel.swift
//  Blog
//
//  Created by huaqian58 on 16/9/26.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit
import YYText

let emotionRegex = try! NSRegularExpression(pattern: "\\[.*?\\]", options: [])
let topicRegex = try! NSRegularExpression(pattern: "#.*?#", options: []) // 话题
let atSomeOneRegex = try! NSRegularExpression(pattern: "@\\w+", options: [])

let urlRegex = try! NSRegularExpression(pattern: "[a-zA-Z]+://[^\\s]*", options: [])

class XCStatusViewModel: NSObject {
    
    // TODO: 模型数据需要额外处理
    var iconURL: URL?
    var memberImage: UIImage?
    var createdDate: String? // 不用，使用timeText代替
    var source: String?
    var avatarImage: UIImage?
    
    var comment_text: String?
    var repost_text: String?
    var ohYeahText: String?
    
    var originalAttributeString: NSAttributedString?
    
    // 模型数据
    var status: XCStatus? {
        // 赋值完成操作
        didSet {
            dealIconURL()
            dealMemberImage()
//            dealCreatedDate()
            dealAvatarImage()
            dealSourceText()
            
            comment_text = dealToolBarText(count: status?.comments_count ?? 0, defaultText: "评论")
            repost_text = dealToolBarText(count: status?.reposts_count ?? 0, defaultText: "转发")
            ohYeahText = dealToolBarText(count: status?.attitudes_count ?? 0, defaultText: "赞")
            
            originalAttributeString = dealStatusText(text: status?.text ?? "")
        }
    }
    
    @objc private func dealStatusText(text: String) -> NSAttributedString {
        let strM = NSMutableAttributedString(string: status?.text ?? "")
        
        let matchResults = emotionRegex.matches(in: text, options: [], range: NSRange(location: 0, length: text.characters.count))
        
        for result in matchResults.reversed() {
            let range = result.rangeAt(0)
            let subStr = (text as NSString).substring(with: range)
            
            let lineHeight = UIFont.systemFont(ofSize: 15).lineHeight
            
            if let emotion = XCEmotionTools.shareEmotionTools.findEmotion(chs: subStr) {
            
                let bundle = XCEmotionTools.shareEmotionTools.emotionBundle // 获取图片的bundle
                
                let image = UIImage(named: emotion.imagePath!, in: bundle, compatibleWith: nil)
                
                // 将附件对象包装富文本
                let imageText = NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: .scaleAspectFill, attachmentSize: CGSize(width:lineHeight, height: lineHeight), alignTo: UIFont.systemFont(ofSize: 15), alignment: .center)
                
                //4. 向可变的富文本中插入 图片富文本
                strM.replaceCharacters(in: range, with: imageText)
            }
        }
        
        addHighlighted(regex: topicRegex, strM: strM)
        addHighlighted(regex: atSomeOneRegex, strM: strM)
        addHighlighted(regex: urlRegex, strM: strM)

        return strM
    }
    
    private func addHighlighted(regex: NSRegularExpression, strM: NSMutableAttributedString) {
    
        let text = strM.string
        
        let matchResults = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.characters.count))
        for result in matchResults {
            let range = result.rangeAt(0)
            strM.addAttributes([NSForegroundColorAttributeName: UIColor.blue], range: range)
            
            let border = YYTextBorder.init(fill: UIColor.darkGray, cornerRadius: 3)
            let highLighted = YYTextHighlight.init()
            
            highLighted.setColor(UIColor.red)
            highLighted.setBackgroundBorder(border)
            strM.yy_setTextHighlight(highLighted, range: range)
        }
    }
    
    // MARK: 头像处理
    @objc private func dealIconURL() {
        
        let urlString = status?.user?.avatar_large ?? ""
        
        iconURL = URL(string: urlString)
    }
    
    // MARK: 处理等级图片
    @objc private func dealMemberImage() {
        
        if let mbrank = status?.user?.mbrank, mbrank > 0 && mbrank < 7 {
            
            let imageName = "common_icon_membership_level\(mbrank)"
            
            memberImage = UIImage(named: imageName)
        }
    }
    
    // 日期转换
//    @objc private func dealCreatedDate() {
//    
//        //Tue Sep 27 12:08:31 +0800 2016
//        
//        let dateFormatter = DateFormatter()
//        
//        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
//        
//        dateFormatter.locale = Locale(identifier: "en")
//        
//        let date = dateFormatter.date(from: status?.created_at ?? "")
//        
//        dateFormatter.dateFormat = "M-d"
//        
//        createdDate = dateFormatter.string(from: date!)
//    }
    
    var timeText: String? {
        
        let dateString = status?.created_at ?? ""
    
//        let dateFormatter = DateFormatter()
        
        sharedDateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
        
        sharedDateFormatter.locale = Locale(identifier: "en")
        
        let createDate = sharedDateFormatter.date(from: dateString)

        guard let sinaDate = createDate else {
            return ""
        }
        
        // 当前日期
        let calendar = Calendar.current
        
        // 判断日期
        if isDateInThisYear(targetDate: sinaDate) {
        
            if calendar.isDateInToday(sinaDate) {
                let date = Date()
                let detla = date.timeIntervalSince(sinaDate)
                if detla < 60 {
                    return "刚刚"
                } else if detla < 3600 {
                    return "\(Int(detla / 60))分钟前"
                } else {
                    return "\(Int(detla / 3600))小时前"
                }
                
            } else if calendar.isDateInYesterday(sinaDate) {
                sharedDateFormatter.dateFormat = "昨天 HH:mm"
                return sharedDateFormatter.string(from: sinaDate)
            } else {
                sharedDateFormatter.dateFormat = "MM-dd"
                return sharedDateFormatter.string(from: sinaDate)
            }
            
        } else {
            sharedDateFormatter.dateFormat = "yyyy-MM-dd"
            return sharedDateFormatter.string(from: sinaDate)
        }
    }
    
    private func isDateInThisYear(targetDate: Date) -> Bool {
        let dateFormater = DateFormatter()
        // 设置日期本地化信息, 真机上面转换会失败
        // 设置什么本地化信息是根据字符串中包含的信息来设置
        dateFormater.locale = Locale(identifier: "en")
        //3. 需要将日期字符串转换 日期(Date)对象
        
        let currentDate = Date()
        //重新设置日期格式符
        dateFormater.dateFormat = "yyyy"
        //如果创建的日期转换不成工就直接return一个空串
        //获取创建的年份
        let creatYear = dateFormater.string(from: targetDate)
        //获取当前的年份
        let currentYear = dateFormater.string(from: currentDate)
        //返回比较的结果
        return currentYear == creatYear
    }

    
    // TODO: 来源
    @objc private func dealSourceText() {
        
        let source = status?.source ?? ""
        
        do {
            let pattern = ">.*<" // <a .*>(\\d+|\\D+)</a>
            
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            
            let res = regex.matches(in: source, options: .withTransparentBounds, range: NSRange(location: 0, length: source.characters.count))
            
            if res.count == 0 {
                self.source = source
                return
            }
            
            for item in res {
                let location = item.range.location + 1
                let length = item.range.length - 2
        
                self.source = (source as NSString).substring(with: NSRange(location: location, length: length))
            }
            
        } catch {
            print(error)
        }
    }
    
    // MARK: 认证类型处理
    @objc private func dealAvatarImage() {
        let verified_type = status?.user?.verified_type ?? -1
        
        switch verified_type {
            
        case 0:
            avatarImage = #imageLiteral(resourceName: "avatar_vip")
            
        case 2,3,5:
            avatarImage = #imageLiteral(resourceName: "avatar_enterprise_vip")
            
        case 220:
            avatarImage = #imageLiteral(resourceName: "avatar_grassroot")
            
        default:
            avatarImage = nil
        }
    }
    
    @objc private func dealToolBarText(count: Int, defaultText: String) -> String {
        
        if count == 0 {
            return defaultText
        }
        
        if count > 10000 {
            return "\(Double(count / 1000))万"
        }
        
        return count.description
    }
}
