//
//  TableViewController.swift
//  NSOperation
//
//  Created by Stan on 2017-07-12.
//  Copyright © 2017 stan. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    let cellIdentifier = "withIdentifier"
    let basicDemosVCId = "basicDemosVCId"

    var selectCellIndexPath : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let basicVC = segue.destination as! BasicDemosVC
        
        switch selectCellIndexPath!.row {
        case 0:
            basicVC.demoType = DemoType.basic
            break
        case 1:
            basicVC.demoType = DemoType.priority
            break
        case 2:
            basicVC.demoType = DemoType.dependency
            break
        case 3:
            
            
            break
        default:
            break
        }
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectCellIndexPath = indexPath
        
        performSegue(withIdentifier: basicDemosVCId, sender: self)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.numberOfLines = 0
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Basic Demo,基本应用"
            break
        case 1:
            cell.textLabel?.text = "Priority Demo,设置了Operation优先级的小案例"
            break
        case 2:
            cell.textLabel?.text = "Dependency Demo,设置了依赖关系"
            break
        case 3:

            
            break
        default:
            break
        }
        
        
       return cell
    }

}
