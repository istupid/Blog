//
//  XCNetworkTools.swift
//  SwiftAFNetworking
//
//  Created by huaqian58 on 16/9/23.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit
import AFNetworking

// TODO: 网络请求类型
enum HTTPMethod {

    case GET    // get 请求
    case POST   // post 请求
    
}

class XCNetworkTools: AFHTTPSessionManager {

    // TODO: 单例
    static let sharedTools: XCNetworkTools = {
        
        // 单例
        let tools = XCNetworkTools()
        
        // 设置接收数据类型
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return tools
    }()
    
    // 核心功能
    func request(method: HTTPMethod, urlString: String, parameters: Any?, finished:@escaping (Any?, Error?) -> ()) {
        
        // 成功闭包
        let successCallBack = {(task: URLSessionDataTask, responseObject: Any?) -> () in
            
            // 调用闭包
            finished(responseObject, nil)
        }
        
        // 失败闭包
        let failureCallBack = {(task: URLSessionDataTask?, error: Error) -> () in
            print(error)
            finished(nil, error)
        }
        
        if method == .GET {
            get(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        } else {
            post(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
    }
    
}
