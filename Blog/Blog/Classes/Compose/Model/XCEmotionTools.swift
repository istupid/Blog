//
//  XCEmotionTools.swift
//  Blog
//
//  Created by huaqian58 on 16/10/9.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

let emotionPageCount = 20
let kSaveRecentEmotion = "kSaveRecentEmotion"
let KSelectEmoticon =  "KSelectEmoticon"

private let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString).appendingPathComponent("recent.plist")

class XCEmotionTools: NSObject {
    
    static let shareEmotionTools = XCEmotionTools()
    
    lazy var emotionBundle:Bundle = {
        // 获取bundle的路径
        let path = Bundle.main.path(forResource: "Emoticons", ofType: "bundle")
        // 根据bundle路径获取bundle对象
        let emotionBundle = Bundle.init(path: path!)
        return emotionBundle!
    }()
    
    // 最近发送表情
    private lazy var recentEmotions: [XCEmotion] = {
        
        // 解档
        if let array = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [XCEmotion] {
            return array
        }
        
        return [XCEmotion]()
    }()
    
    // 默认表情
    private lazy var defaultEmotions: [XCEmotion] = {
        return self.loadEmotions(path: "default/info.plist")
    }()
    // Emoji表情
    private lazy var emojiEmotions: [XCEmotion] = {
        return self.loadEmotions(path: "emoji/info.plist")
    }()
    // 浪小花
    private lazy var lxhEmotions: [XCEmotion] = {
        return self.loadEmotions(path: "lxh/info.plist")
    }()
    
    func loadEmotions(path: String) -> [XCEmotion] {
        // 根据bundle对象获取bundle中资源
        let infoPath = self.emotionBundle.path(forResource: path, ofType: nil)
        let array = NSArray(contentsOfFile: infoPath!) as! [[String : Any]]
    
        var emotions = [XCEmotion]()
        for item in array {
            let emotion = XCEmotion()
            emotion.yy_modelSet(with: item)
            
            if let img = emotion.png {
                emotion.imagePath = (path as NSString).deletingLastPathComponent + "/" + img
            }
            
            emotions.append(emotion)
        }
        
        return emotions
    }
    
    // 所有表情
    lazy var allEmotions:[[[XCEmotion]]] = {
        return [[self.recentEmotions],
                self.emotionPages(emotions: self.defaultEmotions),
                self.emotionPages(emotions: self.emojiEmotions),
                self.emotionPages(emotions: self.lxhEmotions)]
    }()
    
    // 分页
    private func emotionPages(emotions: [XCEmotion]) -> [[XCEmotion]] {
        let pageCount = (emotions.count - 1) / emotionPageCount + 1
        var sectionEmotion = [[XCEmotion]]()
        
        for i in 0..<pageCount {
            //截取数组
            let loc = i * emotionPageCount
            var len = emotionPageCount
            //需要判断 loc + len > emoticons.count
            if loc + len > emotions.count {
                len = emotions.count - loc
            }

            let array = (emotions as NSArray).subarray(with: NSMakeRange(loc, len))
            
            sectionEmotion.append(array as! [XCEmotion])
        }
        
        return sectionEmotion
    }
    
    func saveRecentEmotion(emotion: XCEmotion) {
        
        // 判断表情是不在常用表情包中
        if let imagePath = emotion.imagePath {
            for (index, item) in recentEmotions.enumerated() {
                if imagePath == item.imagePath {
                    recentEmotions.remove(at: index)
                    break
                }
            }
        } else {
            for (index, item) in recentEmotions.enumerated() {
                if emotion.emojiStr == item.emojiStr {
                    recentEmotions.remove(at: index)
                    break
                }
            }
        }
        
        recentEmotions.insert(emotion, at: 0) // 每次都是插入到第一位置
        
        if recentEmotions.count > 20 {
            recentEmotions.removeLast()
        }
        
        allEmotions[0][0] = recentEmotions // 赋值
        
        // 存储
        NSKeyedArchiver.archiveRootObject(recentEmotions, toFile: path)
        
        // 发送通知
        NotificationCenter.default.post(name: NSNotification.Name(kSaveRecentEmotion), object: nil)
    }
    
    // 根据chs查找模型数据
    func findEmotion(chs: String) -> XCEmotion? {
        // 需要在default 和lxh数组中查找模型对象
        let result1 = defaultEmotions.filter { (emotion) -> Bool in
            return emotion.chs == chs
        }
        if result1.count > 0 {
            return result1.first
        }
        let result2 = lxhEmotions.filter { (emotion) -> Bool in
            return emotion.chs == chs
        }
        if result2.count > 0 {
            return result2.first
        }
        return nil
    }
}
