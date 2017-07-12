//
//  BasicDemosVC.swift
//  NSOperation
//
//  Created by Stan on 2017-07-07.
//  Copyright © 2017 stan. All rights reserved.
//

import UIKit

enum DemoType : Int{
    case basic
    case priority
    case dependency
}




class BasicDemosVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    
    let operationQueue = OperationQueue.init()
    
    var imageViews : [UIImageView]?
    var demoType : DemoType?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let type = demoType else { return }
        switch type {
        case .basic:
            self.title = "Basic Demo"
            break
        case .priority :
            self.title = "Priority Demo"
            break
        case .dependency :
            self.title = "Dependency Demo"
            break
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViews = [imageView1,imageView2,imageView3,imageView4]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playItemClick(_ sender: Any) {
        guard let type = demoType else { return }
        switch type {
        case .basic:
            startBasicDemo()
            break
        case .priority :
            startPriorityDemo()
            break
        case .dependency :
            startDepencyDemo()
        }
    }
    
}

extension BasicDemosVC {
    
    fileprivate func startBasicDemo() {
        operationQueue.maxConcurrentOperationCount = 3
        
        
        activityIndicator.startAnimating()
        
        //        使用数组给图片赋值
        //        use Array set image
        for imageView in imageViews! {
            operationQueue.addOperation {
                if let url = URL(string: "https://placebeard.it/355/140") {
                    do {
                        let image = UIImage(data:try Data(contentsOf: url))
                        
                        DispatchQueue.main.async {
                            imageView.image = image
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
        
        
        //        global queue
        DispatchQueue.global().async {
            [weak self] in
            
            //            等待所有操作都完成了,回到主线程停止刷新器。
            //            wait Until All Operations are finished, then stop animation of activity indicator
            self?.operationQueue.waitUntilAllOperationsAreFinished()
            DispatchQueue.main.async {
                
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    
    fileprivate func startPriorityDemo() {
        operationQueue.maxConcurrentOperationCount = 2
        activityIndicator.startAnimating()
        
        var operations = [Operation]()
        for (index, imageView) in (imageViews?.enumerated())! {
            if let url = URL(string: "https://placebeard.it/355/140") {
                //                使用构造方法创建operation
                let operation = convenienceOperation(setImageView: imageView, withURL: url)
                
                //根据索引设置优先级
                switch index {
                case 0:
                    operation.queuePriority = .veryHigh
                case 1:
                    operation.queuePriority = .high
                case 2:
                    operation.queuePriority = .normal
                case 3:
                    operation.queuePriority = .low
                default:
                    operation.queuePriority = .veryLow
                }
                
                operations.append(operation)
            }
        }
        
        //        把任务数组加入到线程中
        DispatchQueue.global().async {
            [weak self] in
            self?.operationQueue.addOperations(operations, waitUntilFinished: true)
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
        }
        
    }
    
    fileprivate func startDepencyDemo() {
       operationQueue.maxConcurrentOperationCount = 4
        self.activityIndicator.startAnimating()
        
        
    }
}

class convenienceOperation: Operation {
    let url: URL
    let imageView: UIImageView
    
    init(setImageView: UIImageView, withURL: URL) {
        imageView = setImageView
        url = withURL
        super.init()
    }
    
    override func main() {
        do {
            
            //            当任务被取消的时候，立刻返回
            if isCancelled {
                return
            }
            let imageData = try Data(contentsOf: url)
            let image = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                [weak self] in
                self?.imageView.image = image
            }
        } catch  {
            print(error)
        }
    }
}
