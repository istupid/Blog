//
//  XCEmotionCell.swift
//  Blog
//
//  Created by huaqian58 on 16/10/9.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

private let bottomMargin: CGFloat = 30
private let buttonW = kScreenW / 7
private let buttonH = (kKeyboardHeight - kEmotionToolBarH - bottomMargin) / 3

class XCEmotionCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let longpre = UILongPressGestureRecognizer(target: self, action: #selector(longPress(ges:)))
        addGestureRecognizer(longpre)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func longPress(ges: UILongPressGestureRecognizer) {
        // 点击的点
        let point = ges.location(in: contentView)
        
        guard let button = findEmotionBtn(point: point) else {
            popoView.removeFromSuperview()
            return
        }
        
        switch ges.state {
        case .began,.changed:
            let window = UIApplication.shared.windows.last!
            //转换左边  按钮需要将坐标转换到哪一个视图上
            //转换的坐标填什么有规律: 转换自己的坐标的时候就是用bounds 如果转换到父视图的坐标的就用frame
            let rect = button.superview!.convert(button.frame, to: window)
            popoView.center.x = rect.midX
            popoView.frame.origin.y = rect.maxY - popoView.bounds.height
            popoView.button.emotion = button.emotion // 显示表情
            window.addSubview(popoView)
            popoView.show()

        default:
            popoView.removeFromSuperview()
        }
        
    }
    
    // 查找按钮
    private func findEmotionBtn(point: CGPoint) -> XCEmotionButton? {
        for button in buttonArray {
        
            if button.frame.contains(point) {
                return button
            }
        }
        
        return nil
    }
    
    // 存按钮
    lazy var buttonArray: [XCEmotionButton] = [XCEmotionButton]()
    lazy var delButton: UIButton = UIButton()
    
    // 接受外部传值
    var emotions: [XCEmotion]? {
        didSet {
            self.emotionButtons(count: emotions!.count)
            for i in 0..<buttonArray.count {
                buttonArray[i].emotion = emotions?[i]
            }
        }
    }
    
    // 创建控件
    private func emotionButtons(count: Int) {

        if count < buttonArray.count { // 移除多余的空间
            for i in count..<buttonArray.count {
                buttonArray[i].removeFromSuperview() // 从视图中移除
            }
            buttonArray.removeSubrange(count..<buttonArray.count) // 移除数组中的元素
        }
        
        createButton(start: buttonArray.count, end: count)
    
        // 删除按钮
        createDelButton(count: count)
    }
    
    // 创建少于的控件
    private func createButton(start: Int, end: Int) {
        for i in start..<end {
            
            let button = XCEmotionButton()
            
            let colIndex = i % 7
            let rowIndex = i / 7
            
            let buttonX = CGFloat(colIndex) * buttonW
            let buttonY = CGFloat(rowIndex) * buttonH
            
            button.frame = CGRect(x: buttonX, y: buttonY, width: buttonW, height: buttonH)
        
            // 监听事件
            button.addTarget(self, action: #selector(emotionClick(button:)), for: .touchUpInside)
            // 存储Button
            buttonArray.append(button)
            
            contentView.addSubview(button)
        }
    }
    
    @objc private func emotionClick(button: XCEmotionButton) {
        // 存储表情
        XCEmotionTools.shareEmotionTools.saveRecentEmotion(emotion: button.emotion!)

        NotificationCenter.default.post(name: NSNotification.Name(KSelectEmoticon), object: button.emotion)
    }
    
    lazy var popoView: XCEmotionPopoView = {
        let popo = XCEmotionPopoView(frame: CGRect(x: 0, y: 0, width: 64, height: 91))
        
        return popo
    }()
    
    // 创建删除按钮
    private func createDelButton(count: Int) {
        
        if count == 0 { // 没有表情
            delButton.removeFromSuperview()
            return
        }
    
        let buttonX = CGFloat(count % 7) * buttonW
        let buttonY = CGFloat(count / 7) * buttonH
        
        delButton.frame = CGRect(x: buttonX, y: buttonY, width: buttonW, height: buttonH)
        delButton.setImage(#imageLiteral(resourceName: "compose_emotion_delete"), for: .normal)
        delButton.setImage(#imageLiteral(resourceName: "compose_emotion_delete_highlighted"), for: .highlighted)
        
        delButton.addTarget(self, action: #selector(deleteClick), for: .touchUpInside)
        contentView.addSubview(delButton)
    }
    
    @objc private func deleteClick() {
        print("删除")
        NotificationCenter.default.post(name: NSNotification.Name(KSelectEmoticon), object: nil)
    }
}
