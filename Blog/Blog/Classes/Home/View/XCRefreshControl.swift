//
//  XCRefreshControl.swift
//  Blog
//
//  Created by huaqian58 on 16/9/28.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

enum RefreshStatue: Int {
    case Normal = 0
    case Pulling
    case Refreshing
}

private let refreshHeight: CGFloat = 50

class XCRefreshControl: UIControl {

    override init(frame: CGRect) {
        
        let rect = CGRect(x: 0, y: -refreshHeight, width: kScreenW, height: refreshHeight)
        
        super.init(frame: rect)
        
//        self.backgroundColor = UIColor.gray
        
        settingComponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func settingComponent() {
        
        addSubview(bgImage)
        addSubview(tipLabel)
        addSubview(indicator)
//        indicator.isHidden = true
        addSubview(arrowIcon)
        
        bgImage.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalTo(self)
        }
        
        tipLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.leading.equalTo(self.snp.centerX).offset(10)
        }
        
        indicator.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.trailing.equalTo(self.snp.centerX).offset(-10)
        }
        
        arrowIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.centerX.equalTo(self).offset(-10)
        }
    }

    private var scrollViw: UIScrollView?
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if let view = newSuperview as? UIScrollView {
            self.scrollViw = view
            view.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        }
    }
    
    var refreshStatue: RefreshStatue = .Normal {
        didSet {
            switch refreshStatue {
            case .Normal:
                tipLabel.text = "下拉刷新"
                arrowIcon.isHidden = false
                indicator.stopAnimating()
                if oldValue == .Refreshing {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.scrollViw!.contentInset.top = self.scrollViw!.contentInset.top - refreshHeight
                    })
                }
                UIView.animate(withDuration: 0.25, animations: {
                    self.arrowIcon.transform = CGAffineTransform.identity
                })
            case .Pulling:
                tipLabel.text = "释手更新"
                UIView.animate(withDuration: 0.25, animations: { 
                    self.arrowIcon.transform = CGAffineTransform.init(rotationAngle: CGFloat(M_PI))
                })
            case .Refreshing:
                self.sendActions(for: .valueChanged)
                arrowIcon.isHidden = true
                indicator.startAnimating()
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.scrollViw!.contentInset.top = self.scrollViw!.contentInset.top + refreshHeight
                })
            }
        }
    }
    
    func stopAnimation () {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            self.refreshStatue = .Normal
        })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        let offsetY = scrollViw?.contentOffset.y ?? 0
        
        let targetY: CGFloat = -(scrollViw!.contentInset.top + refreshHeight)
        if scrollViw!.isDragging {
            
            if refreshStatue == .Normal && offsetY < targetY {
                refreshStatue = .Pulling
            } else if refreshStatue == .Pulling && offsetY > targetY {
                refreshStatue = .Normal
            }
        } else {
            if refreshStatue == .Pulling {
                refreshStatue = .Refreshing
            }
        }
    }
    
    deinit {
        self.scrollViw?.removeObserver(self, forKeyPath: "conentOffset")
    }
    
    // TODO: 子控件
    private lazy var arrowIcon: UIImageView = UIImageView(image: #imageLiteral(resourceName: "tableview_pull_refresh"))
    
    // 提示文字
    private lazy var tipLabel: UILabel = UILabel(text: "下拉刷新", textColor: UIColor.orange, fontSize: 14)
    
    // 菊花按钮
    private lazy var indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    private lazy var bgImage = UIImageView(image: #imageLiteral(resourceName: "refreshbg"))
}
