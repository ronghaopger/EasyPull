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

public protocol EasyViewable {
    func showPulling(progress:CGFloat)
    func showPullingOver()
    func showExcuting()
}

public class DefaultView: UIView, EasyViewable {
    // MARK: - constant and veriable and property
    let kMainBoundsWidth = UIScreen.mainScreen().bounds.size.width
    let kMainBoundsHeight = UIScreen.mainScreen().bounds.size.height
    
    let titleLabel:UILabel = UILabel()
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - public method
    public func showPulling(progress:CGFloat) {
        self.backgroundColor = UIColor.greenColor()
        titleLabel.text = "下拉刷新"
        NSLog("%f", progress)
    }
    
    public func showPullingOver() {
        self.backgroundColor = UIColor.redColor()
        titleLabel.text = "放开即可刷新"
    }
    
    public func showExcuting() {
        self.backgroundColor = UIColor.blueColor()
        titleLabel.text = "正在刷新"
    }
    
    // MARK: - private method
    private func initView() {
        titleLabel.frame = CGRectMake(kMainBoundsWidth * 0.5, self.frame.size.height * 0.5 - 10, 100, 20)
        titleLabel.font = UIFont.systemFontOfSize(14.0)
        titleLabel.textColor = UIColor.blackColor()
        self.addSubview(titleLabel)
    }
}

public class EasyObserver: NSObject, UIScrollViewDelegate {
// MARK: - constant and veriable and property
    let kMainBoundsWidth = UIScreen.mainScreen().bounds.size.width
    let kMainBoundsHeight = UIScreen.mainScreen().bounds.size.height
    
    private var scrollView: UIScrollView = UIScrollView()
    private var dropView: DefaultView?
    private var upView: DefaultView?
    
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
                dropView!.showPulling(progress)
            case .DropPullingOver:
                dropView!.showPullingOver()
            case .DropPullingExcuting:
                dropView!.showExcuting()
                self.scrollView.contentInset = UIEdgeInsets(top: dropViewHeight, left: 0, bottom: 0, right: 0)
                dropAction?()
            case .UpPulling(let progress):
                self.initUpView()
                upView!.showPulling(progress)
            case .UpPullingOver:
                upView!.showPullingOver()
            case .UpPullingExcuting:
                upView!.showExcuting()
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: upViewHeight, right: 0)
                upAction?()
            case .Free:
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
        dropView = DefaultView(frame: CGRectMake(0, -dropViewHeight, kMainBoundsWidth, dropViewHeight))
        dropView!.backgroundColor = UIColor.yellowColor()
        self.scrollView.addSubview(dropView!)
    }
    
    private func initUpView() {
        if upView == nil {
            upView = DefaultView(frame: CGRectMake(0, self.scrollView.contentSize.height, kMainBoundsWidth, upViewHeight))
            upView!.backgroundColor = UIColor.redColor()
        }
        if upView!.superview == nil {
            upView!.frame = CGRectMake(0, self.scrollView.contentSize.height, kMainBoundsWidth, upViewHeight)
            self.scrollView.addSubview(upView!)
        }
        if upPullStyle == .UpPullAutomatic {
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: upViewHeight, right: 0)
        }
    }
    
// MARK: - public method
    public func stopExcuting() {
        State = .Free
    }
}
