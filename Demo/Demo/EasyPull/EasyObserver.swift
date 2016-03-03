//
//  EasyObserver.swift
//  Demo
//
//  Created by 荣浩 on 16/2/25.
//  Copyright © 2016年 荣浩. All rights reserved.
//

import UIKit

public enum EasyState {
    case DropPulling(CGFloat)
    case DropPullingOver
    case DropPullingExcuting
    case UpPulling(CGFloat)
    case UpPullingOver
    case UpPullingExcuting
    case Free
}

public enum EasyUpPullStyle {
    case UpPullAutomatic
    case UpPullManual
}

public protocol EasyViewManual {
    func showManualPulling(progress:CGFloat)
    func showManualPullingOver()
    func showManualExcuting()
    func resetManual()
}

public protocol EasyViewAutomatic {
    func showAutomaticExcuting()
    func resetAutomatic()
}


public class EasyObserver: NSObject, UIScrollViewDelegate {
    
// MARK: - constant and veriable and property
    let kMainBoundsWidth = UIScreen.mainScreen().bounds.size.width
    let kMainBoundsHeight = UIScreen.mainScreen().bounds.size.height
    
    private var scrollView: UIScrollView = UIScrollView()
    
    public var dropViewHeight: CGFloat = 60.0
    public var upViewHeight: CGFloat = 60.0
    public var upPullStyle: EasyUpPullStyle = .UpPullAutomatic
    public var dropAction: (() ->Void)?
    public var upAction: (() ->Void)?
    
    private var dropView: DefaultDropView?
    public var DropView: DefaultDropView {
        get {
            if dropView == nil {
                dropView = DefaultDropView(frame: CGRectMake(0, -dropViewHeight, kMainBoundsWidth, dropViewHeight))
                self.scrollView.addSubview(dropView!)
            }
            return dropView!
        }
        set {
            dropView = newValue
        }
    }
    
    private var upView: DefaultUpView?
    public var UpView: DefaultUpView {
        get {
            if upView == nil {
                upView = DefaultUpView(frame: CGRectMake(0, self.scrollView.contentSize.height, kMainBoundsWidth, upViewHeight))
            }
            if upView!.superview == nil {
                self.scrollView.addSubview(upView!)
            }
            upView!.frame = CGRectMake(0, self.scrollView.contentSize.height, kMainBoundsWidth, upViewHeight)
            return upView!
        }
        set {
            upView = newValue
        }
    }
    
    private var state: EasyState = .Free
    public var State: EasyState {
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
                self.scrollView.contentInset = UIEdgeInsets(top: dropViewHeight, left: 0, bottom: 0, right: 0)
                dropAction?()
            case .UpPulling(let progress):
                if upPullStyle == .UpPullAutomatic {
                    self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: upViewHeight, right: 0)
                }
                upPullStyle == .UpPullManual ? UpView.showManualPulling(progress) : ()
            case .UpPullingOver:
                if upPullStyle == .UpPullManual {
                    UpView.showManualPullingOver()
                }
                else {
                    UpView.showAutomaticExcuting()
                    upAction?()
                }
            case .UpPullingExcuting:
                if upPullStyle == .UpPullManual {
                    self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: upViewHeight, right: 0)
                    UpView.showManualExcuting()
                    upAction?()
                }
            case .Free:
                DropView.resetManual()
                upPullStyle == .UpPullAutomatic ? UpView.resetAutomatic() : UpView.resetManual()
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                })
            }
        }
    }
    
// MARK: - life cycle
    init(scrollView: UIScrollView) {
        super.init()
        
        self.scrollView = scrollView
        self.scrollView.delegate = self
    }
    
// MARK: - observer
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "contentOffset" {
            switch State {
            case .UpPullingExcuting:
                return
            case .DropPullingExcuting:
                return
            default: break
            }
            
            let newPoint = change![NSKeyValueChangeNewKey]?.CGPointValue
            let yOffset = newPoint?.y == nil ? 0 : (newPoint?.y)!
            let frameHeight = self.scrollView.frame.size.height
            let contentHeight = self.scrollView.contentSize.height
            let pullLength = yOffset + frameHeight - contentHeight
            if contentHeight >= frameHeight
                && pullLength >= upViewHeight
            {
                    State = .UpPullingOver
            }
            else if contentHeight >= frameHeight
                && pullLength > 0
                && pullLength < upViewHeight
            {
                    State = .UpPulling(pullLength / upViewHeight)
            }
            else if yOffset <= -dropViewHeight {
                State = .DropPullingOver
            }
            else if yOffset < 0 && yOffset > -dropViewHeight {
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
