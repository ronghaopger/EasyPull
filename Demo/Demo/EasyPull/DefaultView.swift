//
//  DefaultView.swift
//  Demo
//
//  Created by 荣浩 on 16/3/3.
//  Copyright © 2016年 荣浩. All rights reserved.
//

import UIKit

open class DefaultDropView: UIView, EasyViewManual {
    // MARK: - constant and veriable and property
    let arrowImage:UIImageView = UIImageView(image: UIImage(named: "icon_arrow.png", in: Bundle(for: DefaultDropView.self), compatibleWith: nil))
    let indicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
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
        arrowImage.isHidden = false
        indicatorView.isHidden = true
        titleLabel.text = "Pull to refresh..."
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.arrowImage.transform = CGAffineTransform(rotationAngle: 0);
        }) 
    }
    
    open func showManualPullingOver() {
        titleLabel.text = "Release to refresh..."
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
        }) 
    }
    
    open func showManualExcuting() {
        arrowImage.isHidden = true
        indicatorView.isHidden = false
        titleLabel.text = "Loading..."
    }
    
    open func resetManual() {
        arrowImage.isHidden = true
        indicatorView.isHidden = true
        titleLabel.text = ""
        arrowImage.transform = CGAffineTransform(rotationAngle: 0);
    }
    
    // MARK: - private method
    fileprivate func initView() {
        backgroundColor = UIColor.white
        
        let width = frame.size.width,
        height = frame.size.height
        
        arrowImage.frame = CGRect(x: width * 0.5 - 50, y: height * 0.5, width: 10, height: 13)
        arrowImage.isHidden = true
        addSubview(arrowImage)
        
        indicatorView.frame = CGRect(x: width * 0.5 - 50, y: height * 0.5, width: 10, height: 13)
        indicatorView.hidesWhenStopped = false
        indicatorView.startAnimating()
        addSubview(indicatorView)
        
        titleLabel.frame = CGRect(x: width * 0.5 - 27, y: height * 0.5 - 3, width: 150, height: 20)
        titleLabel.font = UIFont.systemFont(ofSize: 14.0)
        titleLabel.textColor = UIColor.black
        addSubview(titleLabel)
    }
}

open class DefaultUpView: UIView, EasyViewManual, EasyViewAutomatic {
    // MARK: - constant and veriable and property
    let arrowImage:UIImageView = UIImageView(image: UIImage(named: "icon_arrow.png", in: Bundle(for: DefaultDropView.self), compatibleWith: nil))
    let indicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
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
        arrowImage.isHidden = false
        indicatorView.isHidden = true
        titleLabel.text = "Pull to load more..."
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
        }) 
    }
    
    open func showManualPullingOver() {
        titleLabel.text = "Release to load more..."
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * 2));
        }) 
    }
    
    open func showManualExcuting() {
        arrowImage.isHidden = true
        indicatorView.isHidden = false
        titleLabel.text = "Loading..."
    }
    
    open func resetManual() {
        arrowImage.isHidden = true
        indicatorView.isHidden = true
        titleLabel.text = ""
        arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
    }
    
    // MARK: - EasyViewAutomatic
    open func showAutomaticPulling(_ progress: CGFloat) {
        indicatorView.isHidden = true
        titleLabel.text = "Pull to load more"
    }
    
    open func showAutomaticExcuting() {
        indicatorView.isHidden = false
        titleLabel.text = "Loading..."
    }
    
    open func showAutomaticUnable() {
        indicatorView.isHidden = true
        titleLabel.text = "Nothing more..."
    }
    
    open func resetAutomatic() {
        arrowImage.isHidden = true
        indicatorView.isHidden = true
        titleLabel.text = ""
    }
    
    // MARK: - private method
    fileprivate func initView() {
        backgroundColor = UIColor.white
        
        let width = frame.size.width,
        height = frame.size.height
        
        arrowImage.frame = CGRect(x: width * 0.5 - 50, y: height * 0.5 - 10, width: 10, height: 13)
        arrowImage.isHidden = true
        arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
        addSubview(arrowImage)
        
        indicatorView.frame = CGRect(x: width * 0.5 - 50, y: height * 0.5 - 10, width: 10, height: 13)
        indicatorView.hidesWhenStopped = false
        indicatorView.startAnimating()
        addSubview(indicatorView)
        
        titleLabel.frame = CGRect(x: width * 0.5 - 27, y: height * 0.5 - 13, width: 150, height: 20)
        titleLabel.font = UIFont.systemFont(ofSize: 14.0)
        titleLabel.textColor = UIColor.black
        addSubview(titleLabel)
    }
}
