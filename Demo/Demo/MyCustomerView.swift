//
//  MyCustomerView.swift
//  Demo
//
//  Created by 荣浩 on 16/3/4.
//  Copyright © 2016年 荣浩. All rights reserved.
//

import UIKit

public class MyCustomerDropView: UIView, EasyViewManual {
    // MARK: - constant and veriable and property
    let kMainBoundsWidth = UIScreen.mainScreen().bounds.size.width
    let kMainBoundsHeight = UIScreen.mainScreen().bounds.size.height
    
    let arrowImage:UIImageView = UIImageView(image: UIImage(named: "icon_arrow.png"))
    let indicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
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
    public func showManualPulling(progress:CGFloat) {
        indicatorView.hidden = true
        titleLabel.text = "自定义页面下拉刷新..."
        NSLog("%f", progress)
    }
    
    public func showManualPullingOver() {
        titleLabel.text = "自定义页面松开刷新..."
        UIView.animateWithDuration(0.5) { () -> Void in
            self.arrowImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI));
        }
    }
    
    public func showManualExcuting() {
        arrowImage.hidden = true
        indicatorView.hidden = false
        titleLabel.text = "自定义页面正在刷新..."
    }
    
    public func resetManual() {
        arrowImage.hidden = false
        indicatorView.hidden = true
        titleLabel.text = ""
        arrowImage.transform = CGAffineTransformMakeRotation(0);
    }
    
    // MARK: - private method
    private func initView() {
        self.backgroundColor = UIColor.whiteColor()
        
        arrowImage.frame = CGRectMake(kMainBoundsWidth * 0.5 - 55, self.frame.size.height * 0.5 - 10, 10, 13)
        self.addSubview(arrowImage)
        
        indicatorView.frame = CGRectMake(kMainBoundsWidth * 0.5 - 55, self.frame.size.height * 0.5 - 10, 10, 13)
        indicatorView.startAnimating()
        self.addSubview(indicatorView)
        
        titleLabel.frame = CGRectMake(kMainBoundsWidth * 0.5 - 35, self.frame.size.height * 0.5 - 10, 150, 20)
        titleLabel.font = UIFont.systemFontOfSize(14.0)
        titleLabel.textColor = UIColor.blackColor()
        self.addSubview(titleLabel)
    }
}
