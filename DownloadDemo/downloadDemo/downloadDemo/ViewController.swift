//
//  ViewController.swift
//  downloadDemo
//
//  Created by Stan on 2017-08-24.
//  Copyright © 2017 stan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    private let tableViewCellIdentifier = "withIdentifier"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath)
        
        cell.backgroundColor = UIColor.darkGray
        return cell
    }

}

