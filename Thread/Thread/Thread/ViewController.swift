//
//  ViewController.swift
//  Thread
//
//  Created by Stan on 2017-08-12.
//  Copyright © 2017 stan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var downImages: Thread?
    var downArticles: Thread?
    
    let imageCondition = NSCondition()
    let articleCondition = NSCondition()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         //        Creatging a Thread, it can run automatically.
         Thread.detachNewThread {
         print("A new thread,name:\(Thread.current)")
         }
         
         //Creating a thread which is included a Selector.
         Thread.detachNewThreadSelector(#selector(threadPrint), toTarget: self, with: nil)
         
         
         //Using the convenience method to create a thread. You need manually start this thread.
         let customThread = Thread(target: self, selector: #selector(threadPrint), object: nil)
         customThread.qualityOfService = .default
         customThread.start()
         
         //        Using NSObject extension method
         self.performSelector(inBackground: #selector(threadPrint), with: nil)
         
         */
        downImages = Thread(target: self, selector: #selector(downloadImages), object: nil)
        downArticles = Thread(target: self, selector: #selector(downloadArticles), object: nil)
        downImages?.start()
        
        
        
        
    }
    
    @objc private func threadPrint() {
        Thread.sleep(forTimeInterval: 2)
        print("After 2 seconds, I have been performed. I am \(Thread.current)")
    }
    
    @objc fileprivate func downloadImages() {
        for index in 1...5 {
            print("Downloading No.\(index) image.")
            Thread.sleep(forTimeInterval: 1)
            
            if index == 2 {
                //start downArticles.开启下载文章的线程
                downArticles?.start()
                
                //Lock the image thread.加锁，让下载图片的线程进入等待状态
                imageCondition.lock()
                imageCondition.wait()
                imageCondition.unlock()
            }
        }
        print("All images have been completed.")
        
        //Signaling the article when all images completed.
        //        等图片都下载完成之后，激活下载文章的进程
        articleCondition.signal()
    }
    
    @objc fileprivate func downloadArticles() {
        for index in 1...5 {
            print("The No.\(index) article will be downloading.")
            Thread.sleep(forTimeInterval: 1)
            if index == 3 {
                //Signaling the image thread, let it continue to down.
                //激活图片的线程，让它继续下载图片
                imageCondition.signal()
                
                //Lock the article thread.加锁，让下载文章的线程进入等待状态
                articleCondition.lock()
                articleCondition.wait()
                articleCondition.unlock()
                
            }
        }
        print("There are 5 articles.")
        
    }
}
