//
//  tableViewCellTableViewCell.swift
//  Demo
//
//  Created by 荣浩 on 16/2/22.
//  Copyright © 2016年 荣浩. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    let kMainBoundsWidth = UIScreen.mainScreen().bounds.size.width
    let kMainBoundsHeight = UIScreen.mainScreen().bounds.size.height
    
    var titleLabel: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.lightGrayColor()
        titleLabel = UILabel(frame: CGRectMake(0, 0, kMainBoundsWidth, 30.0))
        titleLabel!.textColor = UIColor.blackColor()
        self.addSubview(titleLabel!)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
