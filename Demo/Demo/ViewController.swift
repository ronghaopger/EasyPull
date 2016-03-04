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

        //默认下拉
        tableView.easy_addDropPull({
            NSLog("Run")
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                tableView.easy_stopDropPull()
            })
        })
        //自定义下拉
//        tableView.easy_addDropPull({
//            NSLog("Run")
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
//                tableView.easy_stopDropPull()
//            })
//        }, customerDropView: MyCustomerDropView(frame: CGRectMake(0, -60, kMainBoundsWidth, 60)))
        
        
        //默认上拉
        //手动模式
//        tableView.easy_addUpPullManual({
//            NSLog("Run")
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
//                tableView.easy_stopUpPull()
//            })
//        })
        //自动模式
        tableView.easy_addUpPullAutomatic({
            NSLog("Run")
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                tableView.easy_stopUpPull()
            })
        })
        
        
        //自定义上拉
        
        self.view.addSubview(tableView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    // MARK: - datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
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

