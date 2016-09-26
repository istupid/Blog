//
//  XCHomeController.swift
//  Sina
//
//  Created by huaqian58 on 16/9/21.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit
import SVProgressHUD

class XCHomeController: XCBaseController {

    lazy var statuses: [XCStatus] = [XCStatus]()
    
    private lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier:"cell")
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(push))
        
        loginView.LoginView(title: "关注一些人，有惊喜")
        
        self.view.addSubview(tableView)
        
        loadData()
        
    }

    @objc private func push() {
        
        let temp = UIViewController()
        
        temp.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(temp, animated: true)
    }
    
    // TODO: 家族数据
    @objc private func loadData() {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        let parameters = ["access_token" : XCUserAccountViewModel.sharedAccountViewModel.userAccount?.access_token ?? ""]
        
        XCNetworkTools.sharedTools.request(method: .GET, urlString: urlString, parameters: parameters) { (responseObject, error) in
            
            if error != nil {
                SVProgressHUD.showError(withStatus: errorTip)
                return
            }
            
            // 解析数据
            let dict = responseObject as! [String:Any]
            
            // 取出statuses
            guard let array = dict["statuses"] as? [[String : Any]] else {
                return
            }
            
            // 遍历字典转模型
            for item in array {
                let status = XCStatus(dict: item)
                self.statuses.append(status)
            }
            
            self.tableView.reloadData()
        }
    
    }
}


// TODO: 遵守协议

extension XCHomeController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = statuses[indexPath.row].text
        return cell
    }
}
