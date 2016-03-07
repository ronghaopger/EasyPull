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
    private var Observer: EasyObserver {
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
    public func easy_addDropPull(action: (() ->Void), customerDropView: EasyViewManual? = nil) {
        self.Observer.dropAction = action
        if let view = customerDropView {
            self.Observer.DropView = view
        }
        self.addObserver(self.Observer, forKeyPath: "contentOffset", options: .New, context: nil)
    }
    
    public func easy_stopDropPull() {
        self.Observer.stopExcuting()
    }
    
    public func easy_addUpPullManual(action: (() ->Void), customerUpView: EasyViewManual? = nil) {
        self.Observer.upPullMode = .EasyUpPullModeManual
        self.Observer.upAction = action
        if let view = customerUpView {
            self.Observer.UpViewForManual = view
        }
        self.addObserver(self.Observer, forKeyPath: "contentOffset", options: .New, context: nil)
    }
    
    public func easy_addUpPullAutomatic(action: (() ->Void), customerUpView: EasyViewAutomatic? = nil) {
        self.Observer.upPullMode = .EasyUpPullModeAutomatic
        self.Observer.upAction = action
        if let view = customerUpView {
            self.Observer.UpViewForAutomatic = view
        }
        self.addObserver(self.Observer, forKeyPath: "contentOffset", options: .New, context: nil)
    }
    
    public func easy_stopUpPull() {
        self.Observer.stopExcuting()
    }
    
}