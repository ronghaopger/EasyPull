//
//  EasyObserver.swift
//  Demo
//
//  Created by 荣浩 on 16/2/25.
//  Copyright © 2016年 荣浩. All rights reserved.
//

import UIKit

// MARK: protocol
public protocol EasyViewManual {
    func showManualPulling(_ progress:CGFloat)
    func showManualPullingOver()
    func showManualExcuting()
    func resetManual()
}

public protocol EasyViewAutomatic {
    func showAutomaticPulling(_ progress:CGFloat)
    func showAutomaticExcuting()
    func showAutomaticUnable()
    func resetAutomatic()
}

// MARK: enum
internal enum EasyUpPullMode {
    case easyUpPullModeAutomatic
    case easyUpPullModeManual
}

internal enum EasyState {
    case dropPulling(CGFloat)
    case dropPullingOver
    case dropPullingExcuting
    case dropPullingFree
    case upPulling(CGFloat)
    case upPullingOver
    case upPullingExcuting
    case upPullingFree
}


open class EasyObserver: NSObject {
    // MARK: - constant and veriable and property
    fileprivate var scrollView: UIScrollView?
    lazy fileprivate var dropViewSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: 65.0)
    lazy fileprivate var upViewSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: 65.0)
    
    internal var upPullMode: EasyUpPullMode = .easyUpPullModeAutomatic
    internal var dropPullEnable: Bool = false
    internal var upPullEnable: Bool = false
    internal var dropAction: (() ->Void)?
    internal var upAction: (() ->Void)?
    
    fileprivate var dropView: EasyViewManual?
    internal var DropView: EasyViewManual {
        get {
            if dropView == nil {
                dropView = DefaultDropView(frame: CGRect(x: 0, y: -dropViewSize.height, width: dropViewSize.width, height: dropViewSize.height))
            }
            if let view = dropView as? UIView {
                if view.superview == nil
                    && dropPullEnable {
                    scrollView?.addSubview(view)
                }
            }
            return dropView!
        }
        set {
            if let view = newValue as? UIView {
                dropView = newValue
                dropViewSize = view.frame.size
            }
        }
    }
    
    fileprivate var upViewForManual: EasyViewManual?
    internal var UpViewForManual: EasyViewManual {
        get {
            if upViewForManual == nil {
                upViewForManual = DefaultUpView(frame: CGRect(x: 0, y: scrollView!.contentSize.height, width: upViewSize.width, height: upViewSize.height))
            }
            if let view = upViewForManual as? UIView {
                if view.superview == nil
                    && upPullEnable {
                    scrollView!.addSubview(view)
                }
                view.frame.origin.y = scrollView!.contentSize.height
            }
            return upViewForManual!
        }
        set {
            if let view = newValue as? UIView {
                upViewForManual = newValue
                upViewSize = view.frame.size
            }
        }
    }
    
    fileprivate var upViewForAutomatic: EasyViewAutomatic?
    internal var UpViewForAutomatic: EasyViewAutomatic {
        get {
            if upViewForAutomatic == nil {
                upViewForAutomatic = DefaultUpView(frame: CGRect(x: 0, y: scrollView!.contentSize.height, width: upViewSize.width, height: upViewSize.height))
            }
            if let view = upViewForAutomatic as? UIView {
                if view.superview == nil
                    && upPullEnable {
                    scrollView!.addSubview(view)
                }
                view.frame.origin.y = scrollView!.contentSize.height
            }
            return upViewForAutomatic!
        }
        set {
            if let view = newValue as? UIView {
                upViewForAutomatic = newValue
                upViewSize = view.frame.size
            }
        }
    }
    
    fileprivate var state: EasyState = .dropPullingFree
    internal var State: EasyState {
        get {
            return state
        }
        set {
            state = newValue
            switch state {
            case .dropPulling(let progress):
                DropView.showManualPulling(progress)
            case .dropPullingOver:
                DropView.showManualPullingOver()
            case .dropPullingExcuting:
                DispatchQueue.main.async(execute: { () -> Void in
                    UIView.animate(withDuration: 0.2, animations: { () -> Void in
                        self.scrollView!.contentInset.top = self.dropViewSize.height
                    })
                })
                DropView.showManualExcuting()
                dropAction?()
            case .dropPullingFree:
                DropView.resetManual()
                (DropView as! UIView).removeFromSuperview()
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.scrollView!.contentInset.top = 0
                })
            case .upPulling(let progress):
                if upPullMode == .easyUpPullModeAutomatic {
                    scrollView!.contentInset.bottom = upViewSize.height
                    UpViewForAutomatic.showAutomaticPulling(progress)
                }
                else {
                    UpViewForManual.showManualPulling(progress)
                }
            case .upPullingOver:
                if upPullMode == .easyUpPullModeManual {
                    UpViewForManual.showManualPullingOver()
                }
                else {
                    UpViewForAutomatic.showAutomaticExcuting()
                    upAction?()
                }
            case .upPullingExcuting:
                if upPullMode == .easyUpPullModeManual {
                    DispatchQueue.main.async(execute: { () -> Void in
                        UIView.animate(withDuration: 0.2, animations: { () -> Void in
                            self.scrollView!.contentInset.bottom = self.upViewSize.height
                        })
                    })
                    UpViewForManual.showManualExcuting()
                    upAction?()
                }
            case .upPullingFree:
                if upPullMode == .easyUpPullModeAutomatic {
                    UpViewForAutomatic.resetAutomatic()
                    (UpViewForAutomatic as! UIView).removeFromSuperview()
                }
                else {
                    UpViewForManual.resetManual()
                    (UpViewForManual as! UIView).removeFromSuperview()
                    UIView.animate(withDuration: 0.2, animations: { () -> Void in
                        self.scrollView!.contentInset.bottom = 0
                    })
                }
            }
        }
    }
    
    // MARK: - life cycle
    init(scrollView: UIScrollView) {
        super.init()
        self.scrollView = scrollView
    }
    
    
    
    // MARK: - observer
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            switch State {
            case .upPullingExcuting,
                 .dropPullingExcuting:
                return
            default: break
            }
            
            let newPoint = (object as! UIScrollView).contentOffset
            let yOffset = newPoint.y //== nil ? 0 : (newPoint.y)
            let frameHeight = scrollView!.frame.size.height
            let contentHeight = scrollView!.contentSize.height
            let pullLength = yOffset + frameHeight - contentHeight
            if contentHeight >= frameHeight
                && pullLength >= upViewSize.height
                && upPullEnable
            {
                if scrollView!.isDragging {
                    switch State {
                    case .upPullingOver:
                        break
                    default:
                        State = .upPullingOver
                    }
                }
                else {
                    State = .upPullingExcuting
                }
            }
            else if contentHeight >= frameHeight
                && pullLength > 0
                && pullLength < upViewSize.height
                && upPullEnable
            {
                State = .upPulling(pullLength / upViewSize.height)
            }
            else if yOffset <= -dropViewSize.height
                && dropPullEnable {
                if scrollView!.isDragging {
                    switch State {
                    case .dropPullingOver:
                        break
                    default:
                        State = .dropPullingOver
                    }
                }
                else {
                    State = .dropPullingExcuting
                }
            }
            else if yOffset < 0
                && yOffset > -dropViewSize.height
                && dropPullEnable {
                State = .dropPulling(-yOffset / dropViewSize.height)
            }
        }
    }
    
    // MARK: - private method
    
    
    // MARK: - public method
    open func stopDropExcuting() {
        State = .dropPullingFree
    }
    
    open func stopUpExcuting() {
        State = .upPullingFree
    }
    
    open func enableUpExcuting() {
        upPullEnable = true
        State = .upPullingFree
    }
    
    open func unableUpExcuting() {
        upPullEnable = false
        UpViewForAutomatic.showAutomaticUnable()
        scrollView!.contentInset.bottom = self.upViewSize.height
    }
    
    open func triggerDropExcuting() {
        State = .dropPullingExcuting
        scrollView?.setContentOffset(CGPoint(x: 0, y: -dropViewSize.height), animated: true)
    }
}
