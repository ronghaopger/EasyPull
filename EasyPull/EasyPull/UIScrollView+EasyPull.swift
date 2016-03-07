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
        static var OnceToken = "easy_OnceToken"
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
    
    private var OnceToken: dispatch_once_t {
        get {
            var token = objc_getAssociatedObject(self, &AssociatedKeys.OnceToken) as? dispatch_once_t
            if token == nil {
                token = 0
                objc_setAssociatedObject(self, &AssociatedKeys.OnceToken, token, .OBJC_ASSOCIATION_ASSIGN)
            }
            return token!
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.OnceToken, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
// MARK: - public method
    /**
    add drop pull to refresh
    
    - parameter action:         excuting action
    - parameter customDropView: custom view(need to implement the EasyViewManual protocol). default is nil.
    */
    public func easy_addDropPull(action: (() ->Void), customDropView: EasyViewManual? = nil) {
        self.Observer.dropAction = action
        if let view = customDropView {
            self.Observer.DropView = view
        }
        self.addContentOffsetObserver()
    }
    
    /**
     stop drop pull
     */
    public func easy_stopDropPull() {
        self.Observer.stopExcuting()
    }
    
    /**
     add up pull refresh (Manual Mode)
     
     - parameter action:       excuting action
     - parameter customUpView: custom view(need to implement the EasyViewManual protocol). default is nil.
     */
    public func easy_addUpPullManual(action: (() ->Void), customUpView: EasyViewManual? = nil) {
        self.Observer.upPullMode = .EasyUpPullModeManual
        self.Observer.upAction = action
        if let view = customUpView {
            self.Observer.UpViewForManual = view
        }
        self.addContentOffsetObserver()
    }
    
    /**
     add up pull refresh (Automatic Mode)
     
     - parameter action:       excuting action
     - parameter customUpView: custom view(need to implement the EasyViewAutomatic protocol). default is nil.
     */
    public func easy_addUpPullAutomatic(action: (() ->Void), customUpView: EasyViewAutomatic? = nil) {
        self.Observer.upPullMode = .EasyUpPullModeAutomatic
        self.Observer.upAction = action
        if let view = customUpView {
            self.Observer.UpViewForAutomatic = view
        }
        self.addContentOffsetObserver()
    }
    
    /**
     stop up pull
     */
    public func easy_stopUpPull() {
        self.Observer.stopExcuting()
    }
    
    
// MARK: private method
    private func addContentOffsetObserver() {
        dispatch_once(&self.OnceToken, {
            self.addObserver(self.Observer, forKeyPath: "contentOffset", options: .New, context: nil)
        })
    }
}