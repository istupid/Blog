//
//  XCPictureView.swift
//  Blog
//
//  Created by huaqian58 on 16/9/26.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

private let cellId = "XCPictureCell"

class XCPictureView: UICollectionView {
    
    // MARK: 重写构造方法
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        // 注册 cell
        self.register(XCPictureCell.self, forCellWithReuseIdentifier: cellId)
        
//        self.isScrollEnabled = false
        // 代理
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: 数据源
    var pictureInfos: [XCStatusPictureInfo]? {
        
        didSet {
            reloadData() // 刷新数据
        }
    }
}

// TODO: 元素
extension XCPictureView: UICollectionViewDataSource,UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureInfos?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! XCPictureCell
        
        cell.pictureInfo = pictureInfos?[indexPath.item]
        
        return cell
    }
}

// TODO: 元素定义
class XCPictureCell: UICollectionViewCell {

    // MARK: 重写构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        contentView.addSubview(gificon)
        gificon.snp.makeConstraints { (make) in
            make.bottom.trailing.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:
    private lazy var imageView: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill //
        
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    var pictureInfo: XCStatusPictureInfo? {
        
        didSet {
            
            let url = URL(string: pictureInfo?.thumbnail_pic ?? "")
            
            imageView.sd_setImage(with: url)
            
            gificon.isHidden = !url!.absoluteString.hasSuffix(".gif")
        }
    }
    
    private lazy var gificon: UIImageView = UIImageView(image: #imageLiteral(resourceName: "timeline_image_gif"))
}
