//
//  MyCustomView.swift
//  Demo
//
//  Created by 荣浩 on 16/3/4.
//  Copyright © 2016年 荣浩. All rights reserved.
//

import UIKit

open class MyCustomDropView: UIView, EasyViewManual {
    // MARK: - constant and veriable and property
    let titleLabel:UILabel = UILabel()
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - public method
    open func showManualPulling(_ progress:CGFloat) {
        titleLabel.text = "custom Pull..."
        NSLog("%f", progress)
    }
    
    open func showManualPullingOver() {
        titleLabel.text = "custom Release..."
    }
    
    open func showManualExcuting() {
        titleLabel.text = "custom Loading..."
    }
    
    open func resetManual() {
        titleLabel.text = ""
    }
    
    // MARK: - private method
    fileprivate func initView() {
        backgroundColor = UIColor.white
        
        titleLabel.frame = CGRect(x: frame.size.width * 0.5 - 50, y: frame.size.height * 0.5 - 3, width: 150, height: 20)
        titleLabel.font = UIFont.systemFont(ofSize: 14.0)
        titleLabel.textColor = UIColor.black
        addSubview(titleLabel)
    }
}


open class MyCustomUpView: UIView, EasyViewManual, EasyViewAutomatic {
    // MARK: - constant and veriable and property
    let titleLabel:UILabel = UILabel()
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - EasyViewManual
    open func showManualPulling(_ progress:CGFloat) {
        titleLabel.text = "custom Pull..."
        NSLog("%f", progress)
    }
    
    open func showManualPullingOver() {
        titleLabel.text = "custom Release..."
    }
    
    open func showManualExcuting() {
        titleLabel.text = "custom Loading..."
    }
    
    open func resetManual() {
        titleLabel.text = ""
    }
    
    // MARK: - EasyViewAutomatic
    open func showAutomaticPulling(_ progress: CGFloat) {
        titleLabel.text = "custom Pull"
    }
    
    open func showAutomaticExcuting() {
        titleLabel.text = "custom Loading..."
    }
    
    open func showAutomaticUnable() {
        titleLabel.text = "Nothing more..."
    }
    
    open func resetAutomatic() {
        titleLabel.text = ""
    }
    
    // MARK: - private method
    fileprivate func initView() {
        backgroundColor = UIColor.white
        
        titleLabel.frame = CGRect(x: frame.size.width * 0.5 - 50, y: frame.size.height * 0.5 - 13, width: 150, height: 20)
        titleLabel.font = UIFont.systemFont(ofSize: 14.0)
        titleLabel.textColor = UIColor.black
        addSubview(titleLabel)
    }
}

