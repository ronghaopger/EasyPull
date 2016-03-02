//
//  ViewController.swift
//  Demo
//
//  Created by 荣浩 on 16/2/22.
//  Copyright © 2016年 荣浩. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let kMainBoundsWidth = UIScreen.mainScreen().bounds.size.width
    let kMainBoundsHeight = UIScreen.mainScreen().bounds.size.height

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView(frame: CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.easy_addDropPull({
            NSLog("执行啦")
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                tableView.easy_stopDropPull()
            })
        })
        tableView.easy_addUpPull({
            NSLog("执行啦")
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                tableView.easy_stopUpPull()
            })
            }, style: EasyUpPullStyle.UpPullManual)
        self.view.addSubview(tableView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30.0
    }
    
    // MARK: - datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("myCell")
        if (cell == nil) {
            cell = MyTableViewCell(style: .Default, reuseIdentifier: "myCell")
            cell?.frame = CGRectMake(0, 0, kMainBoundsWidth, 30.0)
        }
        return cell!
    }
}
