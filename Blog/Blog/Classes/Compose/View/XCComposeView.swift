//
//  XCComposeView.swift
//  Blog
//
//  Created by huaqian58 on 16/10/6.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit
import pop

class XCComposeView: UIControl {

    var targetVC: UIViewController?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        settingComponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: 子控件
    func settingComponent() {
        // 将图片设置为背景图片 高斯模糊
        let bgImageView = UIImageView(image: UIImage.snapShotCurrentScreen().applyLightEffect())
//        let toolbar = UIToolbar(frame: UIScreen.main.bounds)
//        toolbar.barStyle = .black
//        
//        self.addSubview(toolbar)
        self.addSubview(bgImageView)
        
        // 背景东西
        let slogan = UIImageView(image: #imageLiteral(resourceName: "compose_slogan"))
        addSubview(slogan)
        
        slogan.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(100)
        }
        
        
        // 添加按钮
        addChildButton()
    }
    
    lazy var buttonArray = [XCComposeButton]()
    
    private func addChildButton() {
    
        let margin = (kScreenW - 3 * composeBtnW) / (3 + 1)
        for i in 0..<6 {
            let btn = XCComposeButton()
            btn.setTitle("位置", for: .normal)
            btn.setImage(#imageLiteral(resourceName: "tabbar_compose_lbs"), for: .normal)
            // btn.backgroundColor = UIColor.cyan
            
            let btnX = margin + (composeBtnW + margin) * CGFloat(i % 3)
            let btnY = (margin + composeBtnH) * CGFloat(i / 3) + kScreenH
            
            btn.frame = CGRect(x: btnX, y: btnY, width: composeBtnW, height: composeBtnH)
            
            btn.addTarget(self, action: #selector(composeTypeBtnClick(button:)), for: .touchUpInside)
            
            self.addSubview(btn)
            
            buttonArray.append(btn)
        }
    }
    
    @objc private func composeTypeBtnClick(button: XCComposeButton) {
    
        // 对点击的按钮执行放大，对其他按钮缩小
        UIView.animate(withDuration: 0.5, animations: { 
            
            for composeButton in self.buttonArray {
                
                composeButton.alpha = 0.1
                
                if composeButton == button {
                    // 执行放大
                    composeButton.transform = CGAffineTransform.init(scaleX: 2, y: 2)
                } else {
                    composeButton.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                }
            }
            }) { (_) in
                
                let productName = Bundle.main.infoDictionary!["CFBundleName"] as! String
                
                let className = productName + "." + "XCComposeController"
                
                print(className)
                
                let type = NSClassFromString(className) as! UIViewController.Type
                
                let vc = type.init()
                
                let nav = UINavigationController(rootViewController: vc)
                
                self.targetVC?.present(nav, animated: true, completion: {
                    // 移除视图
                    self.removeFromSuperview()
                })
        }
    }
    
    // 动画效果展示按钮
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        // 便利阿牛
        for button in buttonArray.enumerated() {
            
//            // 实现pop弹出动画
//            let anim = POPSpringAnimation(propertyNamed: kPOPViewCenter)
//            
//            // 设置动画的基本属性
//            anim?.springSpeed = 12
//            anim?.springBounciness = 10
//            
//            // 设置动画时间
//            anim?.beginTime = CACurrentMediaTime() + Double(button.offset) * 0.025
//            
//            // 设置toValue 结构体 应该包装为NSValue
//            anim?.toValue = NSValue.init(cgPoint: CGPoint(x: button.element.center.x, y: button.element.center.y - 350))
//            
//            button.element.pop_add(anim, forKey: nil)
            
            startAnimation(button: button.element, index: button.offset)
        }
    }
    
    
    // MARK: 将视图添加到控制器中
    func show(target: UIViewController?) {
        target?.view.addSubview(self)
        
        targetVC = target
    }
    
    // MARK: 移除视图
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // 便利阿牛
        for button in buttonArray.enumerated() {
            
//            // 实现pop弹出动画
//            let anim = POPSpringAnimation(propertyNamed: kPOPViewCenter)
//            
//            // 设置动画的基本属性
//            anim?.springSpeed = 12
//            anim?.springBounciness = 10
//            
//            // 设置动画时间
//            anim?.beginTime = CACurrentMediaTime() + Double(button.offset) * 0.025
//            
//            // 设置toValue 结构体 应该包装为NSValue
//            anim?.toValue = NSValue.init(cgPoint: CGPoint(x: button.element.center.x, y: button.element.center.y + 350))
//            
//            button.element.pop_add(anim, forKey: nil)
            
            startAnimation(button: button.element, index: button.offset, isUp: false)
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            
            self.removeFromSuperview()
        }
    }

    // 动画
    
    private func startAnimation(button: XCComposeButton, index: Int, isUp: Bool = true) {
        
        // 实现pop弹出动画
        let anim = POPSpringAnimation(propertyNamed: kPOPViewCenter)
        
        // 设置动画的基本属性
        anim?.springSpeed = 12
        anim?.springBounciness = 10
        
        // 设置动画时间
        anim?.beginTime = CACurrentMediaTime() + Double(index) * 0.025
        
        // 设置toValue 结构体 应该包装为NSValue
        anim?.toValue = NSValue.init(cgPoint: CGPoint(x: button.center.x, y: button.center.y + (isUp == true ? -350 : 350)))
        
        button.pop_add(anim, forKey: nil)
    }
}
