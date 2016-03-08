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
    
    let arrowImage:UIImageView = UIImageView(image: UIImage(named: "icon_arrow.png", inBundle: NSBundle(forClass: DefaultDropView.self), compatibleWithTraitCollection: nil))
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
        titleLabel.text = "Pull to refresh..."
        UIView.animateWithDuration(0.4) { () -> Void in
            self.arrowImage.transform = CGAffineTransformMakeRotation(0);
        }
    }
    
    public func showManualPullingOver() {
        titleLabel.text = "Release to refresh..."
        UIView.animateWithDuration(0.4) { () -> Void in
            self.arrowImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI));
        }
    }
    
    public func showManualExcuting() {
        arrowImage.hidden = true
        indicatorView.hidden = false
        titleLabel.text = "Loading..."
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
        
        arrowImage.frame = CGRectMake(kMainBoundsWidth * 0.5 - 50, self.frame.size.height * 0.5, 10, 13)
        self.addSubview(arrowImage)
        
        indicatorView.frame = CGRectMake(kMainBoundsWidth * 0.5 - 50, self.frame.size.height * 0.5, 10, 13)
        indicatorView.startAnimating()
        self.addSubview(indicatorView)
        
        titleLabel.frame = CGRectMake(kMainBoundsWidth * 0.5 - 27, self.frame.size.height * 0.5 - 3, 150, 20)
        titleLabel.font = UIFont.systemFontOfSize(14.0)
        titleLabel.textColor = UIColor.blackColor()
        self.addSubview(titleLabel)
    }
}

public class DefaultUpView: UIView, EasyViewManual, EasyViewAutomatic {
    // MARK: - constant and veriable and property
    let kMainBoundsWidth = UIScreen.mainScreen().bounds.size.width
    
    let arrowImage:UIImageView = UIImageView(image: UIImage(named: "icon_arrow.png", inBundle: NSBundle(forClass: DefaultDropView.self), compatibleWithTraitCollection: nil))
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
        titleLabel.text = "Pull to load more..."
        UIView.animateWithDuration(0.4) { () -> Void in
            self.arrowImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI));
        }
    }
    
    public func showManualPullingOver() {
        titleLabel.text = "Release to load more..."
        UIView.animateWithDuration(0.4) { () -> Void in
            self.arrowImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 2));
        }
    }
    
    public func showManualExcuting() {
        arrowImage.hidden = true
        indicatorView.hidden = false
        titleLabel.text = "Loading..."
    }
    
    public func resetManual() {
        arrowImage.hidden = false
        indicatorView.hidden = true
        titleLabel.text = ""
        arrowImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
    }
    
    // MARK: - EasyViewAutomatic
    public func showAutomaticPulling(progress: CGFloat) {
        titleLabel.text = "Pull to load more"
    }
    
    public func showAutomaticExcuting() {
        indicatorView.hidden = false
        titleLabel.text = "Loading..."
    }
    
    public func resetAutomatic() {
        arrowImage.hidden = true
        indicatorView.hidden = true
        titleLabel.text = ""
    }
    
    // MARK: - private method
    private func initView() {
        self.backgroundColor = UIColor.whiteColor()
        
        arrowImage.frame = CGRectMake(kMainBoundsWidth * 0.5 - 50, self.frame.size.height * 0.5 - 10, 10, 13)
        arrowImage.hidden = true
        arrowImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        self.addSubview(arrowImage)
        
        indicatorView.frame = CGRectMake(kMainBoundsWidth * 0.5 - 50, self.frame.size.height * 0.5 - 10, 10, 13)
        indicatorView.startAnimating()
        self.addSubview(indicatorView)
        
        titleLabel.frame = CGRectMake(kMainBoundsWidth * 0.5 - 27, self.frame.size.height * 0.5 - 13, 150, 20)
        titleLabel.font = UIFont.systemFontOfSize(14.0)
        titleLabel.textColor = UIColor.blackColor()
        self.addSubview(titleLabel)
    }
}
