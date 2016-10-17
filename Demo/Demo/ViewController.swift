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
            let deadline = DispatchTime.now() + DispatchTimeInterval.seconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadline) { 
                tableView.reloadData()
                tableView.easy.stopDropPull()
            }
        }
        //drop pull
        //default view
        tableView.easy.addDropPull(with: {
            NSLog("Run")
            delayStopDrop()
        })
        //custom view
//        tableView.easy.addDropPull(with: {
//            NSLog("custom Run")
//            delayStopDrop()
//        }, customDropView: MyCustomDropView(frame: CGRect(x: 0, y: -60, width: kMainBoundsWidth, height: 60)))
        
        
        
        
        
        func delayStopUp() {
            let deadline = DispatchTime.now() + DispatchTimeInterval.seconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                tableView.reloadData()
                tableView.easy.stopUpPull()
            }
        }
        //up pull
        //default view (Manual mode)
//        tableView.easy.addUpPullManual(with: {
//            NSLog("Run")
//            delayStopUp()
//        })

        //default view (Automatic mode)
        tableView.easy.addUpPullAutomatic(with: {
            NSLog("Run")
            delayStopUp()
        })
        
        
        //custom view (Manual mode)
//        tableView.easy.addUpPullManual(with: {
//            NSLog("custom Run")
//            delayStopUp()
//        }, customUpView: MyCustomUpView(frame: CGRect(x: 0, y: -60, width: kMainBoundsWidth, height: 60)))
    
        //custom view (Automatic mode)
//        tableView.easy.addUpPullAutomatic(with: {
//            NSLog("custom Run")
//            delayStopUp()
//        }, customUpView: MyCustomUpView(frame: CGRect(x: 0, y: -60, width: kMainBoundsWidth, height: 60)))
        
        
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
            tableView.easy.triggerDropExcuting()
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

