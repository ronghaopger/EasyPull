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
    func showManualPulling(progress:CGFloat)
    func showManualPullingOver()
    func showManualExcuting()
    func resetManual()
}

public protocol EasyViewAutomatic {
    func showAutomaticPulling(progress:CGFloat)
    func showAutomaticExcuting()
    func resetAutomatic()
}

// MARK: enum
internal enum EasyUpPullMode {
    case EasyUpPullModeAutomatic
    case EasyUpPullModeManual
}

internal enum EasyState {
    case DropPulling(CGFloat)
    case DropPullingOver
    case DropPullingExcuting
    case UpPulling(CGFloat)
    case UpPullingOver
    case UpPullingExcuting
    case Free
}


public class EasyObserver: NSObject {
    // MARK: - constant and veriable and property
    private var scrollView: UIScrollView?
    lazy private var dropViewSize: CGSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, 60.0)
    lazy private var upViewSize: CGSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, 60.0)
    
    internal var upPullMode: EasyUpPullMode = .EasyUpPullModeAutomatic
    internal var dropPullEnable: Bool = false
    internal var upPullEnable: Bool = false
    internal var dropAction: (() ->Void)?
    internal var upAction: (() ->Void)?
    
    private var dropView: EasyViewManual?
    internal var DropView: EasyViewManual {
        get {
            if dropView == nil {
                dropView = DefaultDropView(frame: CGRectMake(0, -dropViewSize.height, dropViewSize.width, dropViewSize.height))
            }
            if let view = dropView as? UIView {
                if view.superview == nil
                    && dropPullEnable {
                        self.scrollView?.addSubview(view)
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
    
    private var upViewForManual: EasyViewManual?
    internal var UpViewForManual: EasyViewManual {
        get {
            if upViewForManual == nil {
                upViewForManual = DefaultUpView(frame: CGRectMake(0, self.scrollView!.contentSize.height, upViewSize.width, upViewSize.height))
            }
            if let view = upViewForManual as? UIView {
                if view.superview == nil
                    && upPullEnable {
                        self.scrollView!.addSubview(view)
                }
                view.frame.origin.y = self.scrollView!.contentSize.height
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
    
    private var upViewForAutomatic: EasyViewAutomatic?
    internal var UpViewForAutomatic: EasyViewAutomatic {
        get {
            if upViewForAutomatic == nil {
                upViewForAutomatic = DefaultUpView(frame: CGRectMake(0, self.scrollView!.contentSize.height, upViewSize.width, upViewSize.height))
            }
            if let view = upViewForAutomatic as? UIView {
                if view.superview == nil
                    && upPullEnable {
                        self.scrollView!.addSubview(view)
                }
                view.frame.origin.y = self.scrollView!.contentSize.height
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
    
    private var state: EasyState = .Free
    internal var State: EasyState {
        get {
            return state
        }
        set {
            state = newValue
            switch state {
            case .DropPulling(let progress):
                DropView.showManualPulling(progress)
            case .DropPullingOver:
                DropView.showManualPullingOver()
            case .DropPullingExcuting:
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.scrollView!.contentInset = UIEdgeInsets(top: self.dropViewSize.height, left: 0, bottom: 0, right: 0)
                    })
                })
                DropView.showManualExcuting()
                dropAction?()
            case .UpPulling(let progress):
                if upPullMode == .EasyUpPullModeAutomatic {
                    self.scrollView!.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: upViewSize.height, right: 0)
                    UpViewForAutomatic.showAutomaticPulling(progress)
                }
                else {
                    UpViewForManual.showManualPulling(progress)
                }
            case .UpPullingOver:
                if upPullMode == .EasyUpPullModeManual {
                    UpViewForManual.showManualPullingOver()
                }
                else {
                    UpViewForAutomatic.showAutomaticExcuting()
                    upAction?()
                }
            case .UpPullingExcuting:
                if upPullMode == .EasyUpPullModeManual {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        UIView.animateWithDuration(0.2, animations: { () -> Void in
                            self.scrollView!.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.upViewSize.height, right: 0)
                        })
                    })
                    UpViewForManual.showManualExcuting()
                    upAction?()
                }
            case .Free:
                DropView.resetManual()
                upPullMode == .EasyUpPullModeAutomatic ? UpViewForAutomatic.resetAutomatic() : UpViewForManual.resetManual()
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.scrollView!.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                })
            }
        }
    }
    
    // MARK: - life cycle
    init(scrollView: UIScrollView) {
        super.init()
        
        self.scrollView = scrollView
    }
    
    
    
    // MARK: - observer
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "contentOffset" {
            switch State {
            case .UpPullingExcuting,
            .DropPullingExcuting:
                return
            default: break
            }
            
            let newPoint = change![NSKeyValueChangeNewKey]?.CGPointValue
            let yOffset = newPoint?.y == nil ? 0 : (newPoint?.y)!
            let frameHeight = self.scrollView!.frame.size.height
            let contentHeight = self.scrollView!.contentSize.height
            let pullLength = yOffset + frameHeight - contentHeight
            if contentHeight >= frameHeight
                && pullLength >= upViewSize.height
                && upPullEnable
            {
                if self.scrollView!.dragging {
                    switch State {
                    case .UpPullingOver:
                        break
                    default:
                        State = .UpPullingOver
                    }
                }
                else {
                    State = .UpPullingExcuting
                }
            }
            else if contentHeight >= frameHeight
                && pullLength > 0
                && pullLength < upViewSize.height
                && upPullEnable
            {
                State = .UpPulling(pullLength / upViewSize.height)
            }
            else if yOffset <= -dropViewSize.height
                && dropPullEnable {
                    if self.scrollView!.dragging {
                        switch State {
                        case .DropPullingOver:
                            break
                        default:
                            State = .DropPullingOver
                        }
                    }
                    else {
                        State = .DropPullingExcuting
                    }
            }
            else if yOffset < 0
                && yOffset > -dropViewSize.height
                && dropPullEnable {
                    State = .DropPulling(-yOffset / dropViewSize.height)
            }
        }
    }
    
    // MARK: - private method
    
    
    // MARK: - public method
    public func stopExcuting() {
        State = .Free
    }
}
