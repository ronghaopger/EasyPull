//
//  EasyPullCompatible.swift
//  Demo
//
//  Created by 荣浩 on 2016/10/17.
//  Copyright © 2016年 荣浩. All rights reserved.
//

import UIKit

public protocol EasyPullCompatible {
    var easy: EasyPull {get}
}

public class EasyPull {
    // MARK: - associateKeys
    private struct AssociatedKeys {
        static var ContentOffsetObserver = "easy_ContentOffsetObserver"
        static var OnceToken = "easy_OnceToken"
    }
    
    //MARK: - life cycle
    init(_ scrollView: UIScrollView) {
        self.scrollView = scrollView
    }
    
    // MARK: - constant and veriable and property
    private var scrollView: UIScrollView?
    
    private var Observer: EasyObserver {
        get {
            if let obj = objc_getAssociatedObject(scrollView!, &AssociatedKeys.ContentOffsetObserver) as? EasyObserver {
                return obj
            } else {
                let obj = EasyObserver(scrollView: scrollView!)
                objc_setAssociatedObject(scrollView!, &AssociatedKeys.ContentOffsetObserver, obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return obj
            }
        }
    }
    
    // MARK: - public method
    /**
     add drop pull to refresh
     
     - parameter action:         excuting action
     - parameter customDropView: custom view(need to implement the EasyViewManual protocol). default is nil.
     */
    public func addDropPull(with action: @escaping (() ->Void),
                            customDropView: EasyViewManual? = nil) {
        Observer.dropPullEnable = true
        Observer.dropAction = action
        if let view = customDropView {
            Observer.DropView = view
        }
        addContentOffsetObserver()
    }
    
    /**
     stop drop pull
     */
    public func stopDropPull() {
        Observer.stopDropExcuting()
    }
    /**
     trigger drop Excuting Directly
     */
    public func triggerDropExcuting() {
        Observer.triggerDropExcuting()
    }
    
    /**
     add up pull refresh (Manual Mode)
     
     - parameter action:       excuting action
     - parameter customUpView: custom view(need to implement the EasyViewManual protocol). default is nil.
     */
    public func addUpPullManual(with action: @escaping (() ->Void),
                                customUpView: EasyViewManual? = nil) {
        Observer.upPullEnable = true
        Observer.upPullMode = .easyUpPullModeManual
        Observer.upAction = action
        if let view = customUpView {
            Observer.UpViewForManual = view
        }
        addContentOffsetObserver()
    }
    
    /**
     add up pull refresh (Automatic Mode)
     
     - parameter action:       excuting action
     - parameter customUpView: custom view(need to implement the EasyViewAutomatic protocol). default is nil.
     */
    public func addUpPullAutomatic(with action: @escaping (() ->Void),
                                   customUpView: EasyViewAutomatic? = nil) {
        Observer.upPullEnable = true
        Observer.upPullMode = .easyUpPullModeAutomatic
        Observer.upAction = action
        if let view = customUpView {
            Observer.UpViewForAutomatic = view
        }
        addContentOffsetObserver()
    }
    
    /**
     stop up pull
     */
    public func stopUpPull() {
        Observer.stopUpExcuting()
    }
    
    /**
     enable up pull
     */
    public func enableUpPull() {
        Observer.enableUpExcuting()
    }
    
    /**
     unable up pull (already load all)
     */
    public func unableUpPull() {
        Observer.unableUpExcuting()
    }
    
    /**
     release all of action
     */
    public func releaseAll() {
        Observer.dropAction = nil
        Observer.upAction = nil
    }
    
    // MARK: private method
    private func addContentOffsetObserver() {
        guard objc_getAssociatedObject(scrollView!, &AssociatedKeys.OnceToken) == nil else { return }
        
        objc_setAssociatedObject(scrollView!, &AssociatedKeys.OnceToken, "Runed", .OBJC_ASSOCIATION_RETAIN)
        scrollView!.addObserver(Observer, forKeyPath: "contentOffset", options: .new, context: nil)
    }
}
