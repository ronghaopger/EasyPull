//
//  EasyObserver.swift
//  Demo
//
//  Created by 荣浩 on 16/2/25.
//  Copyright © 2016年 荣浩. All rights reserved.
//

import UIKit

public enum EasyState {
    case DropPulling
    case DropPullingOver
    case UpPulling
    case UpPullingOver
    case Excuting
    case Free
}

public class DefaultView: UIView {
    // MARK: - constant and veriable and property
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - public method
    
    // MARK: - private method
    private func initView() {
        
    }
}

public class EasyObserver: NSObject {
    // MARK: - constant and veriable and property
    let kMainBoundsWidth = UIScreen.mainScreen().bounds.size.width
    let kMainBoundsHeight = UIScreen.mainScreen().bounds.size.height
    
    public var scrollView: UIScrollView = UIScrollView()
    public var dropViewHeight: CGFloat = 60.0
    public var upViewHeight: CGFloat = 60.0
    
    private var state: EasyState = .Free
    public var State: EasyState {
        get {
            return state
        }
        set {
            if state != newValue {
                state = newValue
            }
        }
    }
    
    // MARK: - life cycle
    init(scrollView:UIScrollView) {
        super.init()
        
        self.scrollView = scrollView
        let dropView = DefaultView(frame: CGRectMake(0, -dropViewHeight, kMainBoundsWidth, dropViewHeight))
        dropView.backgroundColor = UIColor.yellowColor()
        self.scrollView.addSubview(dropView)
        
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
                    NSLog("up pulling over")
            }
            else if self.scrollView.contentSize.height >= self.scrollView.frame.size.height
                && yOffset + self.scrollView.frame.size.height - self.scrollView.contentSize.height > 0
                && yOffset + self.scrollView.frame.size.height - self.scrollView.contentSize.height < upViewHeight {
                    State = .UpPulling
                    NSLog("up pulling")
            }
            else if yOffset <= -dropViewHeight {
                State = .DropPullingOver
                NSLog("drop pulling over")
            }
            else if yOffset < 0 && yOffset > -dropViewHeight {
                State = .DropPulling
                NSLog("drop pulling")
            }
        }
    }
}
