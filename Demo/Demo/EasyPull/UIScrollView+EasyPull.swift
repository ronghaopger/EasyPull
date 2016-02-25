//
//  UIScrollView+EasyPull.swift
//  Demo
//
//  Created by 荣浩 on 16/2/22.
//  Copyright © 2016年 荣浩. All rights reserved.
//

import UIKit

extension UIScrollView {
// MARK: - associateKeys
    private struct AssociatedKeys {
        static var ContentOffsetObserver = "easy_ContentOffsetObserver"
    }
// MARK: - constant and veriable and property
    private var observer: NSObject {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ContentOffsetObserver) as! NSObject
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ContentOffsetObserver, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
// MARK: - public method
    public func easy_addDropPull(action:() ->Void) {
        self.observer = EasyObserver(scrollView: self)
        self.addObserver(self.observer, forKeyPath: "contentOffset", options: .New, context: nil)
    }
    
    public func easy_addUpPull(action:() ->Void) {
        self.addObserver(self.observer, forKeyPath: "contentOffset", options: .New, context: nil)
    }
    
    public func easy_addLoadMore(action:() ->Void) {
        
    }
}