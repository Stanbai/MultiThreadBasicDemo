//
//  ImageVC.swift
//  GCDBasicDemo
//
//  Created by Stan on 2017-07-26.
//  Copyright © 2017 stan. All rights reserved.
//

import UIKit

class ImageVC: UIViewController {
    var imageView: UIImageView = UIImageView()
    
    override func viewWillAppear(_ animated: Bool) {
        imageView.center = view.center
imageView.bounds = CGRect(x: 0, y: 0, width: 355, height: 150)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        view.addSubview(imageView)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
