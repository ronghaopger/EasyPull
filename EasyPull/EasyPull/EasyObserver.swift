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


public class EasyObserver: NSObject, UIScrollViewDelegate {
    
// MARK: - constant and veriable and property
    let kMainBoundsWidth = UIScreen.mainScreen().bounds.size.width
    
    private var scrollView: UIScrollView?
    private var dropViewHeight: CGFloat = 60.0
    private var upViewHeight: CGFloat = 60.0
    
    internal var upPullMode: EasyUpPullMode = .EasyUpPullModeAutomatic
    internal var dropPullEnable: Bool = false
    internal var upPullEnable: Bool = false
    internal var dropAction: (() ->Void)?
    internal var upAction: (() ->Void)?
    
    private var dropView: EasyViewManual?
    internal var DropView: EasyViewManual {
        get {
            if dropView == nil {
                dropView = DefaultDropView(frame: CGRectMake(0, -dropViewHeight, kMainBoundsWidth, dropViewHeight))
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
                dropViewHeight = view.frame.size.height
            }
        }
    }
    
    private var upViewForManual: EasyViewManual?
    internal var UpViewForManual: EasyViewManual {
        get {
            if upViewForManual == nil {
                upViewForManual = DefaultUpView(frame: CGRectMake(0, self.scrollView!.contentSize.height, kMainBoundsWidth, upViewHeight))
            }
            if let view = upViewForManual as? UIView {
                if view.superview == nil
                    && upPullEnable {
                    self.scrollView!.addSubview(view)
                }
                view.frame = CGRectMake(0, self.scrollView!.contentSize.height, kMainBoundsWidth, upViewHeight)
            }
            return upViewForManual!
        }
        set {
            if let view = newValue as? UIView {
                upViewForManual = newValue
                upViewHeight = view.frame.size.height
            }
        }
    }
    
    private var upViewForAutomatic: EasyViewAutomatic?
    internal var UpViewForAutomatic: EasyViewAutomatic {
        get {
            if upViewForAutomatic == nil {
                upViewForAutomatic = DefaultUpView(frame: CGRectMake(0, self.scrollView!.contentSize.height, kMainBoundsWidth, upViewHeight))
            }
            if let view = upViewForAutomatic as? UIView {
                if view.superview == nil
                    && upPullEnable {
                    self.scrollView!.addSubview(view)
                }
                view.frame = CGRectMake(0, self.scrollView!.contentSize.height, kMainBoundsWidth, upViewHeight)
            }
            return upViewForAutomatic!
        }
        set {
            if let view = newValue as? UIView {
                upViewForAutomatic = newValue
                upViewHeight = view.frame.size.height
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
                DropView.showManualExcuting()
                self.scrollView!.contentInset = UIEdgeInsets(top: dropViewHeight, left: 0, bottom: 0, right: 0)
                dropAction?()
            case .UpPulling(let progress):
                if upPullMode == .EasyUpPullModeAutomatic {
                    self.scrollView!.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: upViewHeight, right: 0)
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
                    self.scrollView!.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: upViewHeight, right: 0)
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
        self.scrollView!.delegate = self
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
                && pullLength >= upViewHeight
                && upPullEnable
            {
                switch State {
                case .UpPullingOver:
                    break
                default:
                    State = .UpPullingOver
                }
            }
            else if contentHeight >= frameHeight
                && pullLength > 0
                && pullLength < upViewHeight
                && upPullEnable
            {
                State = .UpPulling(pullLength / upViewHeight)
            }
            else if yOffset <= -dropViewHeight
                && dropPullEnable {
                switch State {
                case .DropPullingOver:
                    break
                default:
                    State = .DropPullingOver
                }
            }
            else if yOffset < 0
                && yOffset > -dropViewHeight
                && dropPullEnable {
                State = .DropPulling(-yOffset / dropViewHeight)
            }
        }
    }

// MARK: - UIScrollViewDelegate
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        switch State {
        case .DropPullingOver:
            State = .DropPullingExcuting
        case .UpPullingOver:
            State = .UpPullingExcuting
        default: break
        }
    }
    
// MARK: - private method

    
// MARK: - public method
    public func stopExcuting() {
        State = .Free
    }
}
