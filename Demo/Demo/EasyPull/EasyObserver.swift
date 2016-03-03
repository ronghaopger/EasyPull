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
    private var dropView: DefaultDropView?
    private var upView: DefaultUpView?
    
    public var dropViewHeight: CGFloat = 60.0
    public var upViewHeight: CGFloat = 60.0
    public var upPullStyle: EasyUpPullStyle = .UpPullAutomatic
    public var dropAction: (() ->Void)?
    public var upAction: (() ->Void)?
    
    private var state: EasyState = .Free
    public var State: EasyState {
        get {
            return state
        }
        set {
            state = newValue
            switch state {
            case .DropPulling(let progress):
                dropView!.showManualPulling(progress)
            case .DropPullingOver:
                dropView!.showManualPullingOver()
            case .DropPullingExcuting:
                dropView!.showManualExcuting()
                self.scrollView.contentInset = UIEdgeInsets(top: dropViewHeight, left: 0, bottom: 0, right: 0)
                dropAction?()
            case .UpPulling(let progress):
                self.initUpView()
                upPullStyle == .UpPullManual ? upView!.showManualPulling(progress) : ()
            case .UpPullingOver:
                if upPullStyle == .UpPullManual {
                    upView!.showManualPullingOver()
                }
                else {
                    upView?.showAutomaticExcuting()
                    upAction?()
                }
            case .UpPullingExcuting:
                if upPullStyle == .UpPullManual {
                    self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: upViewHeight, right: 0)
                    upView!.showManualExcuting()
                    upAction?()
                }
            case .Free:
                dropView?.resetManual()
                upPullStyle == .UpPullAutomatic ? upView?.resetAutomatic() : upView?.resetManual()
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                })
            }
        }
    }
    
// MARK: - life cycle
    init(scrollView:UIScrollView) {
        super.init()
        
        self.scrollView = scrollView
        self.scrollView.delegate = self

        self.initDropView()
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
            if self.scrollView.contentSize.height >= self.scrollView.frame.size.height
                && yOffset + self.scrollView.frame.size.height - self.scrollView.contentSize.height >= upViewHeight {
                    State = .UpPullingOver
            }
            else if self.scrollView.contentSize.height >= self.scrollView.frame.size.height
                && yOffset + self.scrollView.frame.size.height - self.scrollView.contentSize.height > 0
                && yOffset + self.scrollView.frame.size.height - self.scrollView.contentSize.height < upViewHeight {
                    let progress: CGFloat = (yOffset + self.scrollView.frame.size.height - self.scrollView.contentSize.height) / upViewHeight
                    State = .UpPulling(progress)
            }
            else if yOffset <= -dropViewHeight {
                State = .DropPullingOver
            }
            else if yOffset < 0 && yOffset > -dropViewHeight {
                let progress = -yOffset / dropViewHeight
                State = .DropPulling(progress)
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
    private func initDropView() {
        dropView = DefaultDropView(frame: CGRectMake(0, -dropViewHeight, kMainBoundsWidth, dropViewHeight))
        self.scrollView.addSubview(dropView!)
    }
    
    private func initUpView() {
        if upView == nil {
            upView = DefaultUpView(frame: CGRectMake(0, self.scrollView.contentSize.height, kMainBoundsWidth, upViewHeight))
        }
        if upView!.superview == nil {
            self.scrollView.addSubview(upView!)
        }
        upView!.frame = CGRectMake(0, self.scrollView.contentSize.height, kMainBoundsWidth, upViewHeight)
        if upPullStyle == .UpPullAutomatic {
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: upViewHeight, right: 0)
        }
    }
    
// MARK: - public method
    public func stopExcuting() {
        State = .Free
    }
}
