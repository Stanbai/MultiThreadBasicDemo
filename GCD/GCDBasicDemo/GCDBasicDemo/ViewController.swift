//
//  ViewController.swift
//  GCDBasicDemo
//
//  Created by Stan on 2017-07-26.
//  Copyright © 2017 stan. All rights reserved.
//

import UIKit
import Dispatch

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func delayProcessDispatchTime(_ sender: Any) {
        //dispatch_time用于计算相对时间,当设备睡眠时，dispatch_time也就跟着睡眠了.
        //Creates a `DispatchTime` relative to the system clock that ticks since boot.
        let time = DispatchTimeInterval.seconds(3)
        let delayTime: DispatchTime = DispatchTime.now() + time
        DispatchQueue.global().asyncAfter(deadline: delayTime) {
            Thread.current.name = "dispatch_time_Thread"
            print("Thread Name: \(String(describing: Thread.current.name))\n dispatch_time: Deplay \(time) seconds.\n")
        }
    }
    
    
    @IBAction func delayProcessDispatchWallTime(_ sender: Any) {
        //dispatch_walltime用于计算绝对时间。
        let delaytimeInterval = Date().timeIntervalSinceNow + 2.0
        let nowTimespec = timespec(tv_sec: __darwin_time_t(delaytimeInterval), tv_nsec: 0)
        let delayWalltime = DispatchWallTime(timespec: nowTimespec)
        
        //wallDeadline需要一个DispatchWallTime类型。创建DispatchWallTime类型，需要timespec的结构体。
        DispatchQueue.global().asyncAfter(wallDeadline: delayWalltime) {
            Thread.current.name = "dispatch_Wall_time_Thread"
            print("Thread Name: \(String(describing: Thread.current.name))\n dispatchWalltime: Deplay \(delaytimeInterval) seconds.\n")
        }
        
    }
    
    
    /// global Queue + 异步任务
    @IBAction func globalAsyn(_ sender: Any) {
        //创建一个全局队列。
        //get a global queue
        let globalQueue = DispatchQueue.global()
        for i in 0...10 {
            
            //使用全局队列，开启异步任务。
            //use the global queue , run in asynchronous
            globalQueue.async {
                print("I am No.\(i), current thread name is:\(Thread.current)")
            }
        }
        
    }
    
    
    
    /// main Queue + 异步任务
    @IBAction func mainAsyn(_ sender: Any) {
        //创建一个主队列
        //get a main queue
        let mainQueue = DispatchQueue.main
        
        for i in 0...10 {
            
            //使用主队列，开启异步任务
            //use the main queue, run in asynchronous
            mainQueue.async {
                print("I am No.\(i), current thread name is:\(Thread.current)")
                
            }
        }
    }
    
    @IBAction func asynDownloadImage(_ sender: Any) {
        let imageVC = ImageVC()
        
        
        
        DispatchQueue.global().async {
            
            if let url = URL.init(string: "https://placebeard.it/355/140") {
                do {
                    let imageData = try Data(contentsOf: url)
                    let image = UIImage(data: imageData)
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2), execute: {
                        imageVC.imageView.image = image
                        imageVC.imageView .sizeToFit()
                    })
                    
                } catch {
                    print(error)
                }
            }
            
        }
        navigationController?.pushViewController(imageVC, animated: true)
        
    }
    
    
    @IBAction func useDispatchApply(_ sender: Any) {
        
        print("Begin to start a DispatchApply")
        DispatchQueue.concurrentPerform(iterations: 10) { (index) in
            
            print("Iteration times:\(index),Thread = \(Thread.current)")
        }
        
        print("Iteration have completed.")
        
    }
    
    @IBAction func useDispatchSuspend(_ sender: Any) {
        let queue = DispatchQueue(label: "new thread")
        //        挂起
        queue.suspend()
        
        queue.async {
            print("The queue is suspended. Now it has completed.\n The queue is \"\(queue.label)\". ")
        }
        
        print("The thread will sleep for 3 seconds' time")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(3)) {
            //            唤醒，开始执行
            queue.resume()
        }
    }
    
    @IBAction func useSemaphore(_ sender: Any) {
        semaphoreDemo()
        let semaphoreSignal = DispatchSemaphore(value: 1)
        
        for index in 1...5 {
            DispatchQueue.global().async {
                semaphoreSignal.wait()
                Thread.sleep(forTimeInterval: 1)
                print(Thread.current)
                print("这是第\(index)次执行.\n")
                semaphoreSignal.signal()
            }
            print("测试打印")
            
        }
        
    }
    
    func semaphoreDemo() -> Void {
        let sema = DispatchSemaphore.init(value: 0)
        getListData { (result) in
            if result == true {
                sema.signal()
            }
        }
        sema.wait()
        print("我终于可以开始干活了")
    }
    
    private func getListData(isFinish:@escaping (Bool) -> ()) {
        
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 1)
            print("global queue has completed!")
            isFinish(true)
        }
        
    }
    
    @IBAction func useGroupQueue(_ sender: UIButton) {
        let group = DispatchGroup()
        //模拟循环建立几个全局队列
        for index in 0...3 {
            
            //创建队列的同时，加入到任务组中
            DispatchQueue.global().async(group: group, execute: DispatchWorkItem.init(block: {
                Thread.sleep(forTimeInterval: TimeInterval(arc4random_uniform(2) + 1))
                print("*****任务\(index)执行完毕")
            }))
        }
        
        //组中所有任务都执行完了会发送通知
        group.notify(queue: DispatchQueue.main) {
            print("任务组的任务都已经执行完毕啦！")
        }
        
        
        print("打印测试一下")
        
        
        let manualGroup = DispatchGroup()
        //模拟循环建立几个全局队列
        for manualIndex in 0...3 {
            
            //进入队列管理
            manualGroup.enter()
            DispatchQueue.global().async {
                //让线程随机休息几秒钟
                Thread.sleep(forTimeInterval: TimeInterval(arc4random_uniform(2) + 1))
                print("-----手动任务\(manualIndex)执行完毕")
                
                //配置完队列之后，离开队列管理
                manualGroup.leave()
            }
        }
        
        //发送通知
        manualGroup.notify(queue: DispatchQueue.main) {
            print("手动任务组的任务都已经执行完毕啦！")
        }
    }
    
}



