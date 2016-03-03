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
    private var observer: EasyObserver {
        get {
            var obj = objc_getAssociatedObject(self, &AssociatedKeys.ContentOffsetObserver) as? EasyObserver
            if obj == nil {
                obj = EasyObserver(scrollView: self)
                objc_setAssociatedObject(self, &AssociatedKeys.ContentOffsetObserver, obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return obj!
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ContentOffsetObserver, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
// MARK: - public method
    public func easy_addDropPull(action: () ->Void) {
        self.observer.dropAction = action
        self.addObserver(self.observer, forKeyPath: "contentOffset", options: .New, context: nil)
    }
    
    public func easy_stopDropPull() {
        self.observer.stopExcuting()
    }
    
    public func easy_addUpPull(action: () ->Void, style: EasyUpPullStyle) {
        self.observer.upPullStyle = style
        self.observer.upAction = action
        self.addObserver(self.observer, forKeyPath: "contentOffset", options: .New, context: nil)
    }
    
    public func easy_stopUpPull() {
        self.observer.stopExcuting()
    }
    
}