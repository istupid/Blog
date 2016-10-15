//
//  XCHomeViewModel.swift
//  Blog
//
//  Created by huaqian58 on 16/9/26.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit
import SDWebImage

class XCHomeViewModel: NSObject {
    
    // 数据模型数组
    lazy var viewModelArray: [XCStatusViewModel] = [XCStatusViewModel]()
    
    /// TODO: 加载网络数据，并转模型
    ///
    /// - parameter isPullUp: 上拉加载跟多数据
    /// - parameter finished: 闭包回调
    func loadData(isPullUp: Bool,finished: @escaping(Bool,Int) -> ()) {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        var parameters = ["access_token" : XCUserAccountViewModel.sharedAccountViewModel.userAccount?.access_token ?? ""]
        
        if isPullUp {
            parameters["max_id"] = "\((viewModelArray.last?.status?.id ?? 0) - 1)"
        } else {
            parameters["since_id"] = "\(viewModelArray.first?.status?.id ?? 0)"
        }
        
        XCNetworkTools.sharedTools.request(method: .GET, urlString: urlString, parameters: parameters) { (responseObject, error) in
            
            if error != nil {
                finished(false, 0)
                return
            }
            
            // 解析数据
            let dict = responseObject as! [String:Any]
            
            // 取出statuses
            guard let array = dict["statuses"] as? [[String : Any]] else {
                finished(false, 0)
                return
            }
            
            var tempArray = [XCStatusViewModel]()
            for item in array {
                
                let status = XCStatus()
                status.yy_modelSet(with: item)
                
                let statusViewModel = XCStatusViewModel()
                statusViewModel.status = status
                
                tempArray.append(statusViewModel)
            }
            
            if isPullUp {
                self.viewModelArray = self.viewModelArray + tempArray
            } else {
                self.viewModelArray = tempArray + self.viewModelArray
            }
//            print(self.viewModelArray.count)
            // 执行闭包
//            finished(true, tempArray.count)
            self.cacheSingleImage(dataArray: tempArray, cacheImageFinished: finished)
        }
    }
    
    
    private func cacheSingleImage(dataArray: [XCStatusViewModel], cacheImageFinished: @escaping(Bool,Int) -> ()) {
        
        // 在外界显示实例化调度组 用来监听一组任务完成
        let group = DispatchGroup.init()
        
        print(NSHomeDirectory())
        
        for viewModel in dataArray {
            // 是否是单张图片
            if viewModel.status?.pic_urls?.count == 1 {
                let url = URL(string: viewModel.status?.pic_urls?.first?.thumbnail_pic ?? "")
                
                // 开始异步之前 就应该入组 调度组中的异步任务 + 1
                group.enter()
                
                SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _, _) in
                    
                    print("单张下载完成")
                    // 出组
                    group.leave()
                })
            }
        }
        
        // 执行回调
        group.notify(queue: DispatchQueue.main) { 
            // 所有单张图片下载完成
            cacheImageFinished(true, dataArray.count)
        }
    }
}
