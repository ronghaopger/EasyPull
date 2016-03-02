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
    case UpPulling(CGFloat)
    case UpPullingOver
    case Excuting
    case Free
}

public protocol EasyViewable {
    func showPulling(progress:CGFloat)
    func showPullingOver()
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
    
    public var scrollView: UIScrollView = UIScrollView()
    public var dropViewHeight: CGFloat = 60.0
    public var upViewHeight: CGFloat = 60.0
    private var dropView: DefaultView?
    
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
            default: break
            }
        }
    }
    
    // MARK: - life cycle
    init(scrollView:UIScrollView) {
        super.init()
        
        self.scrollView = scrollView
        self.scrollView.delegate = self
        dropView = DefaultView(frame: CGRectMake(0, -dropViewHeight, kMainBoundsWidth, dropViewHeight))
        dropView!.backgroundColor = UIColor.yellowColor()
        self.scrollView.addSubview(dropView!)
        
//        let pullupView = UIView(frame: CGRectMake(0, self.scrollView.contentSize.height, kMainBoundsWidth, upViewHeight))
//        pullupView.backgroundColor = UIColor.redColor()
//        self.scrollView.addSubview(pullupView)
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "contentOffset" {
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
            self.scrollView.contentInset = UIEdgeInsets(top: dropViewHeight, left: 0, bottom: 0, right: 0)
        case .UpPullingOver:
            self.scrollView.setContentOffset(CGPoint(x: 0, y: upViewHeight + self.scrollView.contentSize.height - self.scrollView.frame.size.height), animated: false)
        default: break
        }
    }
}
