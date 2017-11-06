//
//  ViewController.swift
//  ResumptionDemo
//
//  Created by Stan on 2017-08-19.
//  Copyright © 2017 stan. All rights reserved.
//

import UIKit


private let reuseIdentifier = "reuseIdentifier"

class SBTVC: UITableViewController {
    var downDataArray = [SBDownloadModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = UIColor.darkGray
        title = "Resumption Demo"
        
        
        let downloadCellNib = UINib(nibName: "SBTableViewCell", bundle: nil)
        tableView.register(downloadCellNib, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.rowHeight = 80
        
        createDownDataArray()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    private func createDownDataArray() {
        let firstModel = SBDownloadModel()
        
        //Libaray/Caches
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        
        
        
        
        firstModel.name = "哈哈哈老孙来了"
        firstModel.urlString = "http://imgcache.qq.com/qzone/biz/gdt/dev/sdk/ios/release/GDT_iOS_SDK.zip"
        firstModel.cacheString = String(format: "%@/%@", cachePath,firstModel.urlString)
        downDataArray.append(firstModel)
        
        let secondModel = SBDownloadModel()
        
        secondModel.name = "猪八戒娶媳妇"
        secondModel.urlString = "http://imgcache.qq.com/qzone/biz/gdt/dev/sdk/ios/release/GDT_iOS_SDK.zip"
        secondModel.cacheString = String(format: "%@/%@", cachePath,secondModel.urlString)
        downDataArray.append(secondModel)
        
        let thirdModel = SBDownloadModel()
        
        thirdModel.name = "沙和尚过流沙河"
        thirdModel.urlString = "http://imgcache.qq.com/qzone/biz/gdt/dev/sdk/ios/release/GDT_iOS_SDK.zip"
        thirdModel.cacheString = String(format: "%@/%@", cachePath,thirdModel.urlString)

        downDataArray.append(thirdModel)
        
        
        tableView.reloadData()
    }
    
    
    
    
    
    //    MARK: - tableView Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downDataArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SBTableViewCell
        
        let model = downDataArray[indexPath.row]
        cell.setupCellModel(model: model)
        
        cell.downloadBlock = { (sender) -> Void in
            
            self.downWithSender(downBtn: sender, model: model, cell: cell)
        }

        return cell
    }
}

extension SBTVC {
    fileprivate func downWithSender(downBtn: UIButton?, model: SBDownloadModel?, cell: SBTableViewCell?) {
        let originalTitle = downBtn?.currentTitle
        
        if originalTitle == "开始" || originalTitle == "恢复"{
            downBtn?.setTitle("暂停", for: .normal)
//            开始下载
            
            SBDownload.shared.download(urlString: model?.urlString, cacheString: model?.cacheString, process: { (progressValue, size) in
                cell?.progressView.progress = progressValue
                cell?.sizeLabel.text = size
                
            }, completion: { 
                downBtn?.setTitle("完成", for: .normal)
//                弹窗提醒一下
                let alertView = UIAlertController(title: "\(String(describing: model?.name))下载完成", message: nil, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: { (action) in
                    
                })
                alertView.addAction(cancelAction)
                alertView.show(self, sender: nil)
                
            }, failure: { (error) in
                print("取消下载")
                SBDownload.shared.cancelDownloadTaskWithUrlString(urlString: (model?.urlString)!)
                
                let alertVC = UIAlertController(title: "ERROR", message: nil, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: { (action) in
                })
                alertVC.addAction(cancelAction)
                alertVC.show(self, sender: nil)
            })
        } else {
            downBtn?.setTitle("恢复", for: .normal)
//            从暂停状态恢复下载
            print("从暂停状态恢复下载")
            SBDownload.shared.cancelDownloadTaskWithUrlString(urlString: (model?.urlString)!)

        }
    }
    
    

}

