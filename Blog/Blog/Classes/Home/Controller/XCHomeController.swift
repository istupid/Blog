//
//  XCHomeController.swift
//  Sina
//
//  Created by huaqian58 on 16/9/21.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit
import SVProgressHUD
import YYModel

private let cellId = "XCStatusCell"

class XCHomeController: XCBaseController {

    lazy var statuses: [XCStatus] = [XCStatus]()
    
    // 视图控制器视图数据源
    lazy var homeViewModel: XCHomeViewModel = XCHomeViewModel()
    
    lazy var tableView: UITableView = {
        
        let tableView: UITableView = UITableView(frame: self.view.bounds, style: .plain)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        tableView.separatorStyle = .none // 分割线
        
//        tableView.addSubview(self.refreshControl) // 下拉刷新
        
        tableView.tableFooterView = self.indicatorView // 上拉刷新
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(XCStatusCell.self, forCellReuseIdentifier: cellId)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if !userlogin {
            
            loginView.LoginView(title: "关注一些人，有惊喜")
            
            return
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(push))
        
        self.view.addSubview(tableView)
        
        self.navigationController?.view.addSubview(self.tipLabel)
        self.navigationController?.view.insertSubview(self.tipLabel, belowSubview: self.navigationController!.navigationBar)
        
        tableView.addSubview(refresh)
        
        loadData()
    }
    
    internal func loadData() {
        
        homeViewModel.loadData(isPullUp: indicatorView.isAnimating) { (success, count) in
            if !success {
                SVProgressHUD.showError(withStatus: errorTip)
                return
            }
            self.refreshControl.endRefreshing() // 结束刷新
            
//            self.refresh.refreshStatue = .Normal
            
            self.refresh.stopAnimation()
            
            if !self.indicatorView.isAnimating {
                
                self.startTipAnimation(count: count)
            }
            self.indicatorView.stopAnimating() // 加载完成就停止小菊花
            
            self.tableView.reloadData()
        }
    }

    @objc private func push() {
        let temp = UIViewController()
        temp.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(temp, animated: true)
    }
    
    // TODO: 下拉自定义
    internal lazy var refresh: XCRefreshControl = {
        let refresh = XCRefreshControl()
        refresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
        return refresh
    }()
    
    // TODO: 下拉提示
    internal lazy var tipLabel: UILabel = {
        let tip = UILabel(textColor: UIColor.white, fontSize: 14)
        tip.backgroundColor = UIColor.orange
        tip.textAlignment = .center
        tip.frame = CGRect(x: 0, y: maxNavY - 35, width: kScreenW, height: 35)
//        tip.alpha = 0
        tip.isHidden = true
        return tip
    }()
    
    private func startTipAnimation(count: Int) {
        
        self.tipLabel.text = count == 0 ? "没有新博客数据" : "有\(count)条新博客数据"
        
        self.tipLabel.isHidden = false
        
        let lastY = self.tipLabel.frame.origin.y
        UIView.animate(withDuration: 1, animations: { 
            self.tipLabel.frame.origin.y = maxNavY
            }) { (_) in
                UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                    self.tipLabel.frame.origin.y = lastY
                    }, completion: { (_) in
                        self.tipLabel.isHidden = true;
                })
        }
        
    }
    
    // TODO: 下拉刷新
    internal lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
        return refresh
    }()
    
    // TODO: 上拉刷新
    internal lazy var indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        return indicator
    }()
    
}

// TODO: 遵守协议

extension XCHomeController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.viewModelArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        print(indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! XCStatusCell
//        print("----"+"\(cell)")
        cell.statusViewModel = homeViewModel.viewModelArray[indexPath.row]
        
        return cell
    }
    
    // 加载跟多数据
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if (indexPath.row == homeViewModel.viewModelArray.count - 2) && indicatorView.isAnimating == false {
            
            indicatorView.startAnimating()
            
            loadData()
        }
    }
}
