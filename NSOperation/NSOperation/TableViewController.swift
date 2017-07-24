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
    
    var selectCellIndexPath : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("跳转前打印：\(String(describing: segue.identifier))")
        if let identifier = segue.identifier {
            if identifier == "basicDemosVCId" {
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
                default:
                    break
                }
  
            } else {
                segue.destination.title = "Collection Demo"
            }
        }
        
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectCellIndexPath = indexPath
        
        switch indexPath.row {
        case 0,1,2:
            performSegue(withIdentifier: "basicDemosVCId", sender: self)
            break
        case 3:
            performSegue(withIdentifier: "toCollectionView", sender: self)
            break
        default:
            break
        }
        
        
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
            cell.textLabel?.text = "Basic Demo\n基本应用"
            break
        case 1:
            cell.textLabel?.text = "Priority Demo\n设置了Operation优先级的小案例"
            break
        case 2:
            cell.textLabel?.text = "Dependency Demo\n设置了依赖关系"
            break
        case 3:
            cell.textLabel?.text = "Collection Demo\n展示子线程加载图片"
            break
        default:
            break
        }
        
        
        return cell
    }
    
}
