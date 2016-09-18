//
//  tableViewCellTableViewCell.swift
//  Demo
//
//  Created by 荣浩 on 16/2/22.
//  Copyright © 2016年 荣浩. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    let kMainBoundsWidth = UIScreen.main.bounds.size.width
    let kMainBoundsHeight = UIScreen.main.bounds.size.height
    
    var titleLabel: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.lightGray
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: kMainBoundsWidth, height: 30.0))
        titleLabel!.textColor = UIColor.black
        addSubview(titleLabel!)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
