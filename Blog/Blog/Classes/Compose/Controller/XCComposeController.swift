//
//  XCComposeController.swift
//  Blog
//
//  Created by huaqian58 on 16/10/7.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit
import SVProgressHUD

class XCComposeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        setNav()
        
        setTextView()
        
        setPicSelectView()
        
        setToolBar()
        
        registerNotification()
    }

    // MARK: 设置导航条
    private func setNav() {
        //
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", target: self, action: #selector(close))
        
        // 自定义titleView
        let titleLabel = UILabel(text: "", textColor: UIColor.darkGray, fontSize: 16, lines: 0)
        titleLabel.textAlignment = .center
        
        var titleText = "发布微博"
        
        if let name = XCUserAccountViewModel.sharedAccountViewModel.userAccount?.name {
            
            titleText = "发布微博\n\(name)"
            
            // 通过富文本修改文字的样式
            let strM = NSMutableAttributedString(string: titleText)
            let range = (titleText as NSString).range(of: name)
            
            // 给可变字符串添加样式
            strM.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize:13), NSForegroundColorAttributeName:UIColor.orange], range: range)
            
            titleLabel.attributedText = strM
        } else {
            titleLabel.text = titleText
        }
        
        titleLabel.sizeToFit()
        
        self.navigationItem.titleView = titleLabel
        
        self.navigationItem.rightBarButtonItem = sendBlog
    }
    
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    internal lazy var sendBlog: UIBarButtonItem = {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 35))
        
        button.setTitle("Send", for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .disabled)
        button.setTitleColor(UIColor.white, for: .normal)
        
        button.setBackgroundImage(#imageLiteral(resourceName: "common_button_orange"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "common_button_orange_highlighted"), for: .highlighted)
        button.setBackgroundImage(#imageLiteral(resourceName: "common_button_white_disable"), for: .disabled)
        
        button.addTarget(self, action: #selector(sendButtonClick), for: .touchUpInside)
        
        let item = UIBarButtonItem(customView: button)
        
        item.isEnabled = false
        
        return item
    }()

    
    
    @objc private func sendButtonClick() {
        
        var urlString = "https://api.weibo.com/2/statuses/update.json"
        print(textView.imagesEmotion2Chs())
        let parameters = ["access_token" : XCUserAccountViewModel.sharedAccountViewModel.userAccount?.access_token ?? "",
                          "status" : textView.imagesEmotion2Chs()]
        
        if picSelectVC.images.count == 0 {
            XCNetworkTools.sharedTools.request(method: .POST, urlString: urlString, parameters: parameters) { (_, error) in
                if error != nil {
                    print(error)
                    SVProgressHUD.showError(withStatus: "发布微博失败，请检查网络")
                    return
                }
            
                SVProgressHUD.showSuccess(withStatus: "发布微博成功，棒棒的")
            }
        } else {
            urlString = "https://upload.api.weibo.com/2/statuses/upload.json"
            
            XCNetworkTools.sharedTools.post(urlString, parameters: parameters, constructingBodyWith: { (formdata) in
                for image in self.picSelectVC.images {
                    
                    print(image)
                    let imageData = UIImagePNGRepresentation(image)
                    formdata.appendPart(withFileData: imageData!, name: "pic", fileName: "abc", mimeType: "application/octet-stream")
                }
                
                }, progress: nil, success: { (_, _) in
                    SVProgressHUD.showSuccess(withStatus: "发布公告")
                }, failure: { (_, error) in
                    print(error)
                    SVProgressHUD.showError(withStatus: "发布微博失败，请检查网络")
            })
        }
    }
    
    private func setTextView() {
        self.view.addSubview(textView)
        
        textView.snp.makeConstraints { (make) in
            make.top.leading.equalTo(self.view).offset(8)
            make.trailing.equalTo(self.view).offset(-8)
            make.height.equalTo(kScreenH / 3)
        }
        
        textView.addSubview(placeHolderLabel)
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(textView).offset(8)
            make.leading.equalTo(textView).offset(5)
        }
    }
    
    internal lazy var textView: XCEmotionTextView = {
        
        let textView = XCEmotionTextView()
        
        textView.backgroundColor = UIColor.orange
        
        textView.textColor = UIColor.darkGray
        
        textView.font = UIFont.systemFont(ofSize: 18)
        
        textView.delegate = self
        
        // 键盘隐藏
        //textView.keyboardDismissMode = .onDrag
        // 开启垂直方向滚动
        textView.alwaysBounceVertical = true
    
        return textView
    }()
    
    internal lazy var placeHolderLabel: UILabel = UILabel(text: "听所下雨天", textColor: UIColor.lightGray, fontSize: 18)
    
    
    // MARK: 选择图片
    private func setPicSelectView() {
        self.addChildViewController(picSelectVC)
        self.view.addSubview(picSelectVC.view!)
    
        picSelectVC.view.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalTo(self.view)
            make.height.equalTo(kScreenH / 3 * 2)
        }
    }
    
    private lazy var picSelectVC: XCPicSelectViewController = {
    
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = selectMargin
        layout.minimumLineSpacing = selectMargin
        
        layout.itemSize = CGSize(width: itemW, height: itemW)
        layout.sectionInset = UIEdgeInsets(top: selectMargin, left: selectMargin, bottom: 0, right: selectMargin)
        
        let picSelectCV = XCPicSelectViewController(collectionViewLayout: layout)
        picSelectCV.collectionView?.backgroundColor = UIColor.white
    
        return picSelectCV
    }()
    
    
    // MARK: 设置工具栏
    
    private func setToolBar() {
        self.view.addSubview(toolBar)
        toolBar.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalTo(self.view)
            make.height.equalTo(36)
        }
    }
    
    private lazy var toolBar: UIToolbar = {
    
        let toolBar = UIToolbar()
        
        var items = [UIBarButtonItem]()
        // 添加五个按钮
        let imageNames = ["compose_toolbar_picture",
                          "compose_mentionbutton_background",
                          "compose_trendbutton_background",
                          "compose_emoticonbutton_background",
                          "compose_add_background"]
        
        for value in imageNames.enumerated() {
        
            let button = UIButton()
            button.setImage(UIImage(named: value.element), for: .normal)
            button.setImage(UIImage(named: value.element + "_highlighted"), for: .highlighted)
            button.tag = value.offset
            button.addTarget(self, action: #selector(statueTypeButtonClick(button:)), for: .touchUpInside)
        
            button.sizeToFit()
            
            let item = UIBarButtonItem(customView: button)
            items.append(item)
            
            let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            items.append(space)
        }
        
        items.removeLast()
        
        toolBar.items = items
        
        return toolBar
    }()
    
    @objc private func statueTypeButtonClick(button: UIButton) {
        
        switch button.tag {
        case 0:
            picSelectVC.userWillAddPic() // 添加图片
        case 1:
            print("@某人")
        case 2:
            print("发布话题")
        case 3:
            print(textView.inputView)
            // 不是第一响应者就作为第一响应者
            if !textView.isFirstResponder {
                textView.becomeFirstResponder()
            }
//            textView.inputView = keyboardView
            
            textView.inputView = textView.inputView == nil ? keyboardView : nil
            textView.reloadInputViews()
        case 4:
            print("更多")
        default:
            print("瞎点")
        }
    }
    
    // TODO: 注册监听
    private func registerNotification() {
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(n:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(inputEmotion(n:)), name: NSNotification.Name(KSelectEmoticon), object: nil)
    }
    
    @objc private func keyboardWillChange(n:Notification) {
    
        let endFrame = (n.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let offSetY = endFrame.origin.y - kScreenH
        
        toolBar.snp.updateConstraints { (make) in
            make.bottom.equalTo(offSetY)
        }
        
        // 添加动画时间
        UIView.animate(withDuration: 0.25) { 
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func inputEmotion(n: Notification) {
        guard let emotion = n.object as? XCEmotion else {
            textView.deleteBackward()
            return
        }
        
        // 程序走到这里，标示输入的是图片或者emoji
        if emotion.type == 1 {
            textView.replace(textView.selectedTextRange!, withText: emotion.emojiStr!)
            return
        }
        
        textView.inputEmotion(emotion: emotion)

    }
    
    // 自定义表情键盘
    lazy var keyboardView: XCEmoticonKeyboardView = {
        // plus 226 其他216
        let keyboard = XCEmoticonKeyboardView(frame: CGRect(x: 0, y: 0, width: 0, height: kKeyboardHeight))
        return keyboard
    }()
    
    // 释放
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension XCComposeController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {

        // 设置发送按钮
        self.sendBlog.isEnabled = textView.hasText
        
        // 设置占位符
        self.placeHolderLabel.isHidden = textView.hasText
    }
    
    // 失去第一响应这
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         textView.resignFirstResponder()
    }
}
