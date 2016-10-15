//
//  XCPicSelectViewController.swift
//  Blog
//
//  Created by huaqian58 on 16/10/7.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit
import SVProgressHUD

private let reuseIdentifier = "Cell"

private let maxImageCount = 2

let selectMargin: CGFloat = 4

let count: Int = 3

let itemW: CGFloat = (kScreenW - CGFloat(count + 1) * selectMargin) / CGFloat(count)

class XCPicSelectViewController: UICollectionViewController {

    // 图片数据
    lazy var images:[UIImage] = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell classes
        self.collectionView!.register(XCPicSelectCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + (images.count == 0 || images.count == maxImageCount ? 0 : 1)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! XCPicSelectCell
        cell.backgroundColor = UIColor.gray
        
        if indexPath.item == images.count {
            cell.image = nil
        } else {
            cell.image = images[indexPath.item]
        }
        
        cell.delegate = self
        return cell
    }
}

extension XCPicSelectViewController: XCPictureCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    func userWillAddPic() {
        // 是否允许访问相册
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//            SVProgressHUD.showInfo(withStatus: "请到设置->Blog->开启当前应用访问相册的权限")
//            return
//        }
        if images.count >= maxImageCount {
            SVProgressHUD.showInfo(withStatus: "已经添加了最大张数，不能再添加了")
            return
        }
        // 打开相册
        let picker = UIImagePickerController()
        picker.delegate = self
        // picker.allowsEditing = true // 允许编辑，目前没发现有什么用
        present(picker, animated: true, completion: nil)
    }
    
    func userWillRemovePic(cell: XCPicSelectCell) {
        let indexPath = collectionView?.indexPath(for: cell)
        images.remove(at: indexPath!.item)
        collectionView?.reloadData()
    }
    
    // 相册的代理方法
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //images.append(image)
        images.append(image.scaleImage(width: 600))
        collectionView?.reloadData() // 刷新所有数据
        // 实现了代理方法，控制器的dismiss 就叫给了程序员
        dismiss(animated: true, completion: nil)
    }
}

// TODO: 协议
@objc protocol XCPictureCellDelegate: NSObjectProtocol {

    @objc optional func userWillAddPic()
    
    @objc optional func userWillRemovePic(cell: XCPicSelectCell)
    
}

// TODO: cell

class XCPicSelectCell: UICollectionViewCell {

    // MARK: 重写构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingComponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 代理
    weak var delegate: XCPictureCellDelegate?
    
    // MARK: 添加控件
    private func settingComponent() {
        // 添加按钮
        contentView.addSubview(addButton)
        // 添加删除按钮
        contentView.addSubview(removeButton)
        
        addButton.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        removeButton.snp.makeConstraints { (make) in
            make.top.trailing.equalTo(contentView)
        }
    }
    
    var image: UIImage? {
        didSet {
            addButton.setImage(image, for: .normal)
            removeButton.isHidden = image == nil // 没有图片就隐藏
            let backImage: UIImage? = (image == nil ? #imageLiteral(resourceName: "compose_pic_add") : nil)
            addButton.setBackgroundImage(backImage, for: .normal)
        }
    }
    
    // MARK: 懒加载
    private lazy var addButton: UIButton = {
        let button = UIButton()
//        button.setBackgroundImage(#imageLiteral(resourceName: "compose_pic_add"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill //设置视图模式
        button.addTarget(self, action: #selector(addPicClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "compose_photo_close"), for: .normal)
        button.addTarget(self, action: #selector(removePicClick), for: .touchUpInside)
        return button
    }()
    
    @objc private func addPicClick() {
        if image != nil {
            return
        }
        delegate?.userWillAddPic?()
    }
    
    @objc private func removePicClick() {
        delegate?.userWillRemovePic?(cell: self)
    }
}
