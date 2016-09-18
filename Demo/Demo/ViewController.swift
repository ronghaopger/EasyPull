//
//  ViewController.swift
//  Demo
//
//  Created by 荣浩 on 16/2/22.
//  Copyright © 2016年 荣浩. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let kMainBoundsWidth = UIScreen.main.bounds.size.width
    let kMainBoundsHeight = UIScreen.main.bounds.size.height

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: kMainBoundsWidth, height: kMainBoundsHeight))
        tableView.delegate = self
        tableView.dataSource = self
        
        
        func delayStopDrop() {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
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
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == 11 {
            //set Excuting directly
            tableView.easy_triggerDropExcuting()
        }
    }
    
    // MARK: - datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: MyTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "myCell") as? MyTableViewCell
        if (cell == nil) {
            cell = MyTableViewCell(style: .default, reuseIdentifier: "myCell")
        }
        switch (indexPath as NSIndexPath).row {
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

