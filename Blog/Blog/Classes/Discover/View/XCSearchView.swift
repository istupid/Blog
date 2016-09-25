//
//  XCSearchView.swift
//  Blog
//
//  Created by huaqian58 on 16/9/22.
//  Copyright © 2016年 William·James. All rights reserved.
//

import UIKit

@IBDesignable class XCSearchView: UIButton {

    class func searchView() -> XCSearchView {
        
        let nib = UINib(nibName: "XCSearchView", bundle: nil)
        
        return nib.instantiate(withOwner: nil, options: nil).last as! XCSearchView
    }
    
    override func awakeFromNib() {
        
        layer.borderWidth = 1
        bounds.size.width = UIScreen.main.bounds.width
        
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
    }

}
