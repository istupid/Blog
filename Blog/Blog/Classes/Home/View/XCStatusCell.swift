//
//  XCStatusCell.swift
//  Blog
//
//  Created by huaqian58 on 16/9/26.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit
import SDWebImage
import YYText
import SVProgressHUD

private let margin: CGFloat = 8
private let cellMargin: CGFloat = 5
private let maxWidth = kScreenW - 2 * margin
private let itemWH = (maxWidth - 2 * cellMargin) / 3

class XCStatusCell: UITableViewCell {
    
    private var pic_size: CGSize = CGSize.zero
    
    // 分隔视图
    lazy var topView: UIView! = {
    
        let topView = UIView()
        
        topView.backgroundColor = UIColor.lightGray
        
        return topView
    }()
    
    // 用户头像
    lazy var iconView: UIImageView! = {
        let iconView = UIImageView()
        
        return iconView
    }()
    
    // 用户名称
    lazy var nameLabel: UILabel! = {
        
        let nameLabel = UILabel()
        
        return nameLabel
    }()
    
    // 用户等级
    lazy var memberImage: UIImageView! = {
    
        let memberImage = UIImageView()
        
        return memberImage
    }()
    
    // 创建时间
    lazy var timeLabel: UILabel! = {
        
        let timeLabel = UILabel(textColor: UIColor.orange, fontSize: 14)
        
        return timeLabel
    }()
    
    // 微博来源
    lazy var sourceLabel: UILabel! = {
    
        let sourceLabel = UILabel(fontSize: 14)
        
        return sourceLabel
    }()
    
    // 微博正文
    lazy var contentLabel: YYLabel! = {
        
        let contentLabel = YYLabel() //UILabel(fontSize: 14, lines: 0)

        return contentLabel
    }()
    
    // 认证类型
    lazy var avatarImage: UIImageView! = {
    
        let avatarImage = UIImageView()
    
        return avatarImage
    }()
    
    // 转发微博
    lazy var retweetedLabel: YYLabel! = {
    
        let retweeted = YYLabel() //UILabel(fontSize: 14, lines: 0)
        retweeted.backgroundColor = UIColor.lightGray
        return retweeted
    }()
    
    
    lazy var layout = UICollectionViewFlowLayout()
    
    //配图视图
    lazy var pictureView: XCPictureView! = {
        
//        let layout = UICollectionViewFlowLayout()
    
        let pictureView = XCPictureView(frame: CGRect.zero, collectionViewLayout: self.layout)
        
        pictureView.backgroundColor = UIColor.white
        
//        self.layout.itemSize = CGSize(width: itemWH, height: itemWH)

        self.layout.minimumLineSpacing = cellMargin
        self.layout.minimumInteritemSpacing = cellMargin
        
        return pictureView
    }()
    
    // 底部视图
    lazy var bottomView: XCToolBarView! = {
        
        let bottomView = XCToolBarView()
        
        return bottomView
    }()
    
    // TODO: 重写构造方法
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none // 取消选择的背景
        // 子控件
        settingComponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: 子控件
    @objc private func settingComponent() {
        
        contentView.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(contentView)
            make.height.equalTo(10)
        }
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(topView).offset(16)
            make.leading.equalTo(contentView).offset(8)
            make.width.height.equalTo(40)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView)
            make.leading.equalTo(iconView.snp.trailing).offset(8)
        }
        
        contentView.addSubview(memberImage)
        memberImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameLabel)
            make.leading.equalTo(nameLabel.snp.trailing).offset(8)
        }
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(iconView.snp.trailing).offset(8)
            make.bottom.equalTo(iconView)
        }
        
        contentView.addSubview(sourceLabel)
        sourceLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(timeLabel.snp.trailing).offset(8)
            make.bottom.equalTo(timeLabel)
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(8)
            make.leading.equalTo(iconView)
            make.trailing.equalTo(contentView).offset(-8)
            //make.height.
        }
        
        contentView.addSubview(avatarImage)
        avatarImage.snp.makeConstraints { (make) in
            make.bottom.trailing.equalTo(iconView)
        }
        
        // 转载的微博
        contentView.addSubview(retweetedLabel)
        retweetedLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(0)
            make.leading.equalTo(iconView)
            make.trailing.equalTo(contentView).offset(-margin)
        }
        
        contentView.addSubview(pictureView)
        pictureView.snp.makeConstraints { (make) in
            make.top.equalTo(retweetedLabel.snp.bottom).offset(0)
            make.leading.equalTo(contentView).offset(margin)
            make.size.equalTo(pic_size)
        }
        
        contentView.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(pictureView.snp.bottom).offset(margin)
            make.leading.trailing.equalTo(contentView).offset(0)
            make.bottom.equalTo(contentView).offset(-8)
            make.height.equalTo(36)
        }
    }
    
    
    var statusViewModel: XCStatusViewModel? {
        
        didSet {
            iconView.sd_setImage(with: statusViewModel?.iconURL)
            
            nameLabel.text = statusViewModel?.status?.user?.name
            
            memberImage.image = statusViewModel?.memberImage
            
            avatarImage.image = statusViewModel?.avatarImage
            
//            timeLabel.text = statusViewModel?.createdDate
            timeLabel.text = statusViewModel?.timeText
            
            sourceLabel.text = statusViewModel?.source
            
//            contentLabel.text = statusViewModel?.status?.text
            contentLabel.attributedText = statusViewModel?.originalAttributeString
            contentLabel.preferredMaxLayoutWidth = kScreenW - 2 * margin
            contentLabel.numberOfLines = 0
            
            if statusViewModel?.status?.retweeted_status != nil {
            
                retweetedLabel.text = statusViewModel?.status?.retweeted_status?.text
                
                retweetedLabel.preferredMaxLayoutWidth = kScreenW - 2 * margin
                retweetedLabel.numberOfLines = 0
                
                retweetedLabel.snp.updateConstraints({ (make) in
                    make.top.equalTo(contentLabel.snp.bottom).offset(margin)
                })
                
                // 计算pictureView的size
                
                let value = pictureViewSize(count: statusViewModel?.status?.retweeted_status?.pic_urls?.count ?? 0)
                
                pic_size = value.pic_size
                
                layout.itemSize = value.itemSize
                
                pictureView.pictureInfos = statusViewModel?.status?.retweeted_status?.pic_urls
                
            } else {
            
                // 计算pictureView的size
                let value = pictureViewSize(count: statusViewModel?.status?.pic_urls?.count ?? 0)
                
                pic_size = value.pic_size
                
                layout.itemSize = value.itemSize
                
                pictureView.pictureInfos = statusViewModel?.status?.pic_urls
            }
            
            if pictureView.pictureInfos != nil {
                
                // 更新约束
                pictureView.snp.updateConstraints { (make) in
                    make.top.equalTo(retweetedLabel.snp.bottom).offset(margin)
                    make.size.equalTo(pic_size)
                }
            }
            
            // 获取高亮文本的点击事件
            contentLabel.highlightTapAction = {(container, text, range, rect) in
                print(container, text, range, rect)
                let subStr = (text.string as NSString).substring(with: range)
                SVProgressHUD.showInfo(withStatus: subStr)
                if subStr.contains("http") {
                    let temp = XCTempViewController()
                    temp.urlString = subStr
                    self.navController()?.pushViewController(temp, animated: true)
                }
            
            }
            
            bottomView.statusModel = statusViewModel!
            
            layoutIfNeeded()
        }
    }

    // MARK: 计算PictureView Size
    private func pictureViewSize(count: Int) -> (pic_size: CGSize,itemSize: CGSize) {
        
        if count == 0 {
            return (CGSize.zero, CGSize.zero)
        }
        
        if count == 1 {
            let urlString = statusViewModel?.status?.pic_urls?.first?.thumbnail_pic ?? ""
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: urlString)
            
            if image == nil {
                print(urlString)
                return (CGSize.zero, CGSize.zero)
            }
            var imageSize = image!.size
            
            if imageSize.width > maxWidth {
                
                imageSize = CGSize(width: maxWidth, height: imageSize.height * maxWidth / imageSize.width)
            }
            // 到了了图片不滚动 需要加0.5
            return (imageSize, CGSize(width: imageSize.width - 0.5, height: imageSize.height - 0.5))
        }
        
        if count == 4 {
            let width = itemWH * 2 + cellMargin
            return (CGSize(width: width + 0.5, height: width + 0.5),CGSize(width:itemWH, height: itemWH))
        }
        
        let rowCount = CGFloat((count - 1) / 3 + 1)
        let height = itemWH * rowCount + (rowCount - 1) * cellMargin
        return (CGSize(width: maxWidth, height: height), CGSize(width:itemWH, height: itemWH))
    }
}
