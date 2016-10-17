//
//  UIScrollView+EasyPull.swift
//  Demo
//
//  Created by 荣浩 on 16/2/22.
//  Copyright © 2016年 荣浩. All rights reserved.
//

import UIKit

extension UIScrollView: EasyPullCompatible {
    public var easy: EasyPull {
        get {
            return EasyPull(self)
        }
    }

}
