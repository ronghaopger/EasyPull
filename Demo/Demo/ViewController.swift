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
        
        
        func delayStopDrop() {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                tableView.reloadData()
                tableView.easy_stopDropPull()
            })
        }
        //drop pull
        //default view
        tableView.easy_addDropPull({
            NSLog("Run")
            delayStopDrop()
        })
        //custom view
//        tableView.easy_addDropPull({
//            NSLog("custom Run")
//            delayStopDrop()
//        }, customDropView: MyCustomDropView(frame: CGRectMake(0, -60, kMainBoundsWidth, 60)))
        
        
        
        func delayStopUp() {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                tableView.reloadData()
                tableView.easy_stopUpPull()
            })
        }
        //up pull
        //default view
        //Manual mode
//        tableView.easy_addUpPullManual({
//            NSLog("Run")
//            delayStopUp()
//        })

        //Automatic mode
        tableView.easy_addUpPullAutomatic({
            NSLog("Run")
            delayStopUp()
        })
        
        //custom view
        //Manual mode
//        tableView.easy_addUpPullManual({
//            NSLog("custom Run")
//            delayStopUp()
//        }, customUpView: MyCustomUpView(frame: CGRectMake(0, -60, kMainBoundsWidth, 60)))
    
        //Automatic mode
//        tableView.easy_addUpPullAutomatic({
//            NSLog("custom Run")
//            delayStopUp()
//        }, customUpView: MyCustomUpView(frame: CGRectMake(0, -60, kMainBoundsWidth, 60)))
        
        
        
        self.view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 11 {
            //set Excuting directly
            tableView.easy_triggerDropExcuting()
        }
    }
    
    // MARK: - datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: MyTableViewCell? = tableView.dequeueReusableCellWithIdentifier("myCell") as? MyTableViewCell
        if (cell == nil) {
            cell = MyTableViewCell(style: .Default, reuseIdentifier: "myCell")
        }
        switch indexPath.row {
        case 1:
            cell?.titleLabel?.text = " pull-to-refresh have two mode:"
        case 2:
            cell?.titleLabel?.text = " Manual mode and Automatic mode"
        case 3:
            cell?.titleLabel?.text = " drop-pull only support Manual mode"
        case 4:
            cell?.titleLabel?.text = " up-pull support all modes"
        case 6:
            cell?.titleLabel?.text = " you can use the default view"
        case 7:
            cell?.titleLabel?.text = " or set your custom view"
        case 8:
            cell?.titleLabel?.text = " it's easy."
        case 10:
            cell?.titleLabel?.text = "                 ____________"
        case 11:
            cell?.titleLabel?.text = "                | click here | "
        case 12:
            cell?.titleLabel?.text = "                |____________|"
        default:
            cell?.titleLabel?.text = " "
            break
        }
        return cell!
    }
}

