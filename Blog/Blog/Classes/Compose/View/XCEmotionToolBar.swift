//
//  XCEmotionToolBar.swift
//  Blog
//
//  Created by huaqian58 on 16/10/9.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

enum EmotionType: Int {
    case RECENT = 0
    case DEFAULT
    case EMOJI
    case LXH
}

class XCEmotionToolBar: UIStackView {

    var selectButton: UIButton? // 记录选择的按钮
    var emotionTypeSelect:((EmotionType)->())?
    
    // TODO: 重写构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        settingComponent()
        
        axis = .horizontal  // 设置轴
        distribution = .fillEqually // 设置填充方式
        
        self.tag = 10000
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // TODO: 控件
    private func settingComponent() {
        addChildButtons(title: "最近", backImage: "compose_emotion_table_left", index: .RECENT)
        addChildButtons(title: "默认", backImage: "compose_emotion_table_mid", index: .DEFAULT)
        addChildButtons(title: "Emoji", backImage: "compose_emotion_table_mid", index: .EMOJI)
        addChildButtons(title: "浪小花", backImage: "compose_emotion_table_right", index: .LXH)
    }
    
    private func addChildButtons(title: String, backImage: String, index: EmotionType) {
    
        let button = UIButton()
        
        button.setBackgroundImage(UIImage(named: backImage+"_normal"), for: .normal)
        button.setBackgroundImage(UIImage(named: backImage+"_selected"), for: .selected)
    
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .selected)
        
        button.tag = index.rawValue
        self.addArrangedSubview(button)
        
        button.addTarget(self, action: #selector(emotionTypeDidSelector(button:)), for: .touchUpInside)
        
        if index == .RECENT {
            button.isSelected = true
            selectButton = button
        }
    }
    
    @objc private func emotionTypeDidSelector(button: UIButton) {
        // 已经选择就不在被选择
        if button.isSelected {
            return
        }
        selectButton?.isSelected = false
        
        button.isSelected = true
        selectButton = button
        
        // 执行闭包，对外抛出按钮的点击事件
        emotionTypeSelect?(EmotionType.init(rawValue: button.tag)!)
    }
    
    // 外部设置toolBar
    func setEmotionTypeSelect(indexPath: IndexPath) {
        let button = self.viewWithTag(indexPath.section) as! UIButton
        // 已经选择就不在被选择
        if button.isSelected {
            return
        }
        selectButton?.isSelected = false
        
        button.isSelected = true
        selectButton = button
    }
}
