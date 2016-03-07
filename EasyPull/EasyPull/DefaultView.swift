//
//  DefaultView.swift
//  Demo
//
//  Created by 荣浩 on 16/3/3.
//  Copyright © 2016年 荣浩. All rights reserved.
//

import UIKit

public class DefaultDropView: UIView, EasyViewManual {
    // MARK: - constant and veriable and property
    let kMainBoundsWidth = UIScreen.mainScreen().bounds.size.width
    
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
        titleLabel.text = "下拉刷新..."
        NSLog("%f", progress)
    }
    
    public func showManualPullingOver() {
        titleLabel.text = "松开刷新..."
        UIView.animateWithDuration(0.4) { () -> Void in
            self.arrowImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI));
        }
    }
    
    public func showManualExcuting() {
        arrowImage.hidden = true
        indicatorView.hidden = false
        titleLabel.text = "正在刷新..."
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
        
        arrowImage.frame = CGRectMake(kMainBoundsWidth * 0.5 - 40, self.frame.size.height * 0.5, 10, 13)
        self.addSubview(arrowImage)
        
        indicatorView.frame = CGRectMake(kMainBoundsWidth * 0.5 - 40, self.frame.size.height * 0.5, 10, 13)
        indicatorView.startAnimating()
        self.addSubview(indicatorView)
        
        titleLabel.frame = CGRectMake(kMainBoundsWidth * 0.5 - 17, self.frame.size.height * 0.5 - 3, 100, 20)
        titleLabel.font = UIFont.systemFontOfSize(14.0)
        titleLabel.textColor = UIColor.blackColor()
        self.addSubview(titleLabel)
    }
}

public class DefaultUpView: UIView, EasyViewManual, EasyViewAutomatic {
    // MARK: - constant and veriable and property
    let kMainBoundsWidth = UIScreen.mainScreen().bounds.size.width
    
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
    
    // MARK: - EasyViewManual
    public func showManualPulling(progress:CGFloat) {
        arrowImage.hidden = false
        indicatorView.hidden = true
        titleLabel.text = "上拉加载更多..."
        NSLog("%f", progress)
    }
    
    public func showManualPullingOver() {
        titleLabel.text = "松开即可加载..."
        UIView.animateWithDuration(0.4) { () -> Void in
            self.arrowImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 2));
        }
    }
    
    public func showManualExcuting() {
        arrowImage.hidden = true
        indicatorView.hidden = false
        titleLabel.text = "正在加载更多..."
    }
    
    public func resetManual() {
        arrowImage.hidden = false
        indicatorView.hidden = true
        titleLabel.text = ""
        arrowImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
    }
    
    // MARK: - EasyViewAutomatic
    public func showAutomaticPulling(progress: CGFloat) {
        titleLabel.text = "上拉加载更多"
    }
    
    public func showAutomaticExcuting() {
        indicatorView.hidden = false
        titleLabel.text = "正在加载更多..."
    }
    
    public func resetAutomatic() {
        arrowImage.hidden = true
        indicatorView.hidden = true
        titleLabel.text = ""
    }
    
    // MARK: - private method
    private func initView() {
        self.backgroundColor = UIColor.whiteColor()
        
        arrowImage.frame = CGRectMake(kMainBoundsWidth * 0.5 - 40, self.frame.size.height * 0.5 - 10, 10, 13)
        arrowImage.hidden = true
        arrowImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        self.addSubview(arrowImage)
        
        indicatorView.frame = CGRectMake(kMainBoundsWidth * 0.5 - 40, self.frame.size.height * 0.5 - 10, 10, 13)
        indicatorView.startAnimating()
        self.addSubview(indicatorView)
        
        titleLabel.frame = CGRectMake(kMainBoundsWidth * 0.5 - 17, self.frame.size.height * 0.5 - 13, 100, 20)
        titleLabel.font = UIFont.systemFontOfSize(14.0)
        titleLabel.textColor = UIColor.blackColor()
        self.addSubview(titleLabel)
    }
}
