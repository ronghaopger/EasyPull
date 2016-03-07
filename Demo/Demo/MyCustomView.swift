//
//  MyCustomView.swift
//  Demo
//
//  Created by 荣浩 on 16/3/4.
//  Copyright © 2016年 荣浩. All rights reserved.
//

import UIKit

public class MyCustomDropView: UIView, EasyViewManual {
    // MARK: - constant and veriable and property
    let kMainBoundsWidth = UIScreen.mainScreen().bounds.size.width
    
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
        titleLabel.text = "custom Pull..."
        NSLog("%f", progress)
    }
    
    public func showManualPullingOver() {
        titleLabel.text = "custom Release..."
    }
    
    public func showManualExcuting() {
        titleLabel.text = "custom Loading..."
    }
    
    public func resetManual() {
        titleLabel.text = ""
    }
    
    // MARK: - private method
    private func initView() {
        self.backgroundColor = UIColor.whiteColor()
        
        titleLabel.frame = CGRectMake(kMainBoundsWidth * 0.5 - 50, self.frame.size.height * 0.5 - 3, 150, 20)
        titleLabel.font = UIFont.systemFontOfSize(14.0)
        titleLabel.textColor = UIColor.blackColor()
        self.addSubview(titleLabel)
    }
}


public class MyCustomUpView: UIView, EasyViewManual, EasyViewAutomatic {
    // MARK: - constant and veriable and property
    let kMainBoundsWidth = UIScreen.mainScreen().bounds.size.width
    
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
        titleLabel.text = "custom Pull..."
        NSLog("%f", progress)
    }
    
    public func showManualPullingOver() {
        titleLabel.text = "custom Release..."
    }
    
    public func showManualExcuting() {
        titleLabel.text = "custom Loading..."
    }
    
    public func resetManual() {
        titleLabel.text = ""
    }
    
    // MARK: - EasyViewAutomatic
    public func showAutomaticPulling(progress: CGFloat) {
        titleLabel.text = "custom Pull"
    }
    
    public func showAutomaticExcuting() {
        titleLabel.text = "custom Loading..."
    }
    
    public func resetAutomatic() {
        titleLabel.text = ""
    }
    
    // MARK: - private method
    private func initView() {
        self.backgroundColor = UIColor.whiteColor()
        
        titleLabel.frame = CGRectMake(kMainBoundsWidth * 0.5 - 50, self.frame.size.height * 0.5 - 13, 150, 20)
        titleLabel.font = UIFont.systemFontOfSize(14.0)
        titleLabel.textColor = UIColor.blackColor()
        self.addSubview(titleLabel)
    }
}

