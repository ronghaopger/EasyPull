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
                tableView.reloadData()
                tableView.easy_stopDropPull()
            })
        })
        //自定义下拉
//        tableView.easy_addDropPull({
//            NSLog("Run")
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
//                tableView.reloadData()
//                tableView.easy_stopDropPull()
//            })
//        }, customerDropView: MyCustomerDropView(frame: CGRectMake(0, -60, kMainBoundsWidth, 60)))
        
        
        //默认上拉
        //手动模式
//        tableView.easy_addUpPullManual({
//            NSLog("Run")
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
//                tableView.reloadData()
//                tableView.easy_stopUpPull()
//            })
//        })
        //自动模式
        tableView.easy_addUpPullAutomatic({
            NSLog("Run")
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                tableView.reloadData()
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
        var cell: MyTableViewCell? = tableView.dequeueReusableCellWithIdentifier("myCell") as? MyTableViewCell
        if (cell == nil) {
            cell = MyTableViewCell(style: .Default, reuseIdentifier: "myCell")
            cell?.frame = CGRectMake(0, 0, kMainBoundsWidth, 30.0)
        }
        switch indexPath.row {
        case 1:
            cell?.titleLabel?.text = " pull-to-refresh have two mode:"
        case 2:
            cell?.titleLabel?.text = " Manual mode and Automatic mode"
        case 3:
            cell?.titleLabel?.text = " drop-pull support Manual mode"
        case 4:
            cell?.titleLabel?.text = " up-pull support all modes"
        case 6:
            cell?.titleLabel?.text = " you can use the default view"
        case 7:
            cell?.titleLabel?.text = " or make your customer view"
        case 8:
            cell?.titleLabel?.text = " it's easy."
        default:
            cell?.titleLabel?.text = " "
            break
        }
        return cell!
    }
}

