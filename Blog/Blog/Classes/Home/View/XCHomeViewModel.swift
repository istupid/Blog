//
//  XCHomeViewModel.swift
//  Blog
//
//  Created by huaqian58 on 16/9/26.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

class XCHomeViewModel: NSObject {
    
    // 数据模型数组
    lazy var viewModelArray: [XCStatusViewModel] = [XCStatusViewModel]()
    
    // TODO: 加载网络数据转模型
    func loadData(finished: @escaping(Bool) -> ()) {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        let parameters = ["access_token" : XCUserAccountViewModel.sharedAccountViewModel.userAccount?.access_token ?? ""]
        
        XCNetworkTools.sharedTools.request(method: .GET, urlString: urlString, parameters: parameters) { (responseObject, error) in
            
            if error != nil {
                finished(false)
                return
            }
            
            // 解析数据
            let dict = responseObject as! [String:Any]
            
            // 取出statuses
            guard let array = dict["statuses"] as? [[String : Any]] else {
                finished(false)
                return
            }

            for item in array {
                
                let status = XCStatus()
                status.yy_modelSet(with: item)
                
                let statusViewModel = XCStatusViewModel()
                statusViewModel.status = status
                
                self.viewModelArray.append(statusViewModel)
            }
            
            // 执行闭包
            finished(true)
        }
        

    }

}
