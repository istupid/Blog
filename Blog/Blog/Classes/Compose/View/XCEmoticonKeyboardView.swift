//
//  XCEmoticonKeyboardView.swift
//  Blog
//
//  Created by huaqian58 on 16/10/9.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit
let kKeyboardHeight: CGFloat = 220
let kEmotionToolBarH: CGFloat = 37

private let kEmotionCellId = "EmotionCellId"

class XCEmoticonKeyboardView: UIView {

    // TODO: 重写构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingComponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // TODO: 控件
    private func settingComponent() {
        addSubview(collectionView)
        addSubview(toolBar)
        addSubview(pageControl)
        addSubview(recentLabel)
        
        collectionView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(self)
        }
        
        toolBar.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView.snp.bottom)
            make.leading.bottom.trailing.equalTo(self)
            make.height.equalTo(kEmotionToolBarH)
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.bottom.equalTo(toolBar.snp.top)
        }
        
        recentLabel.snp.makeConstraints { (make) in
            make.center.equalTo(pageControl)
        }
        
        // 点击事件
        toolBar.emotionTypeSelect = {type in
            let indexPath = IndexPath(item: 0, section: type.rawValue)
            self.collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            // 分页空间
            self.updatePageControlData(indexPath: indexPath)
        }
        
        //DispatchQueue.global().async { // 子线程
            DispatchQueue.main.async {
                self.updatePageControlData(indexPath: IndexPath(item: 0, section: 0))
            }
        //}
        
        // 监听通知
        registerNotification()
    }
    
    private func registerNotification () {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(kSaveRecentEmotion), object: nil)
    }
    
    @objc private func reloadData() {
        // 当前显示的组
        let indexPath = collectionView.indexPathsForVisibleItems.last!
        // 显示常用表情不刷新
        if indexPath.section != 0 {
            collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
    }
    
    // 控件懒加载
    internal lazy var collectionView: UICollectionView = {
        // 实例化流水布局
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: kScreenW, height: kKeyboardHeight - kEmotionToolBarH)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(XCEmotionCell.self, forCellWithReuseIdentifier: kEmotionCellId)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    internal lazy var toolBar: XCEmotionToolBar = XCEmotionToolBar()
    
    
    internal lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        
//        pageControl.currentPage = 0
//        pageControl.numberOfPages = 5
        
        pageControl.setValue(#imageLiteral(resourceName: "compose_keyboard_dot_normal"), forKey: "_pageImage")
        pageControl.setValue(#imageLiteral(resourceName: "compose_keyboard_dot_selected"), forKey: "_currentPageImage")
        
        return pageControl
    }()
    
    private lazy var recentLabel: UILabel = UILabel(text: "最近使用的表情", textColor: UIColor.orange, fontSize: 10)
    
    internal func updatePageControlData(indexPath: IndexPath) {
        let pageEmotions = XCEmotionTools.shareEmotionTools.allEmotions[indexPath.section] // 组
        pageControl.numberOfPages = pageEmotions.count
        pageControl.currentPage = indexPath.item
        
        pageControl.isHidden = indexPath.section == 0
        recentLabel.isHidden = indexPath.section != 0
    }
}


extension XCEmoticonKeyboardView: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return XCEmotionTools.shareEmotionTools.allEmotions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return XCEmotionTools.shareEmotionTools.allEmotions[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEmotionCellId, for: indexPath) as! XCEmotionCell
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.emotions = XCEmotionTools.shareEmotionTools.allEmotions[indexPath.section][indexPath.row]

        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x + 0.5 * kScreenW
        
        let indexPath = collectionView.indexPathForItem(at: CGPoint(x: contentOffsetX, y: 1))
        
        toolBar.setEmotionTypeSelect(indexPath: indexPath!)
     
        self.updatePageControlData(indexPath: indexPath!)
    }
}
