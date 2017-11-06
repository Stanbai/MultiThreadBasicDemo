//
//  SBDownload.swift
//  ResumptionDemo
//
//  Created by Stan on 2017-08-20.
//  Copyright © 2017 stan. All rights reserved.
//

import UIKit


///  下载完成的通知名称
let SBDownloadCompletedNotificationName = "SBDownloadCompletedNotificationName"



class SBDownload: NSObject, URLSessionDelegate {
    static var shared = SBDownload()
    
    var connection: NSURLConnection?
    
    //在后台执行有限长度的任务
    var backgroundTask: UIBackgroundTaskIdentifier?
    //下载任务
    var taskDict: Dictionary<String, SBDownloadCenter>?
    
    
    override init() {
        super.init()
        taskDict = Dictionary()
        backgroundTask = UIBackgroundTaskInvalid
        
        let notiCenter = NotificationCenter.default
        
        //        添加下载完成后的通知
        notiCenter.addObserver(self, selector: #selector(completedDown(noti:)), name: NSNotification.Name(rawValue: SBDownloadCompletedNotificationName), object: nil)
        
        // 监听app 即将进入后台 即将返回前台的通知
        NotificationCenter.default.addObserver(self, selector: #selector(appWillTerminate(noti:)), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive(noti:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: self)
        
        //app 将要退出
        NotificationCenter.default.addObserver(self, selector: #selector(appWillTerminate(noti:)), name: NSNotification.Name.UIApplicationWillTerminate, object: self)
        
    }
    
    //    下载的主方法
    func download(urlString: String?, cacheString: String?, process: SBDownloadCenter.ProcessHandle?, completion: SBDownloadCenter.CompletionHandle?, failure: SBDownloadCenter.FailureHandle?) {
        
        let downCenter = SBDownloadCenter.center()
        sychronized(lock: self) {
            taskDict?[urlString!] = downCenter
        }
        downCenter.download(urlString: urlString, cacheString: cacheString, process: process, completion: completion, failure: failure)
    }
    
    //    取消下载任务
    func cancelDownloadTaskWithUrlString(urlString:String) {
        let downCenter = taskDict?[urlString]
        downCenter?.cancel()
        
        sychronized(lock: self) {
            taskDict?.removeValue(forKey: urlString)
        }
        
    }
    
    
    
    //全局的session
    lazy var downloadSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        
    }()
}


extension SBDownload {
    
    //    MARK: 下载及App前后台状态
    @objc fileprivate func completedDown(noti: Notification) {
        let dict: Dictionary = noti.userInfo!
        
        let urlString = dict["urlString"] as! String
        
        sychronized(lock: self) { 
            //        完成后，从下载字典中删除
            taskDict?.removeValue(forKey: urlString)
        }

    }
    
    ///即将进入后台
    @objc fileprivate func appWillResignActive(noti: Notification) {
        if (taskDict?.count)! > 0 {
            backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                
            })
        }
    }
    
    ///即将进入前台
    @objc fileprivate func appDidBecomeActive(noti: Notification) {
        if backgroundTask == UIBackgroundTaskInvalid {
            return
        }
        
        //        结束后台任务
        UIApplication.shared.endBackgroundTask(backgroundTask!)
        backgroundTask = UIBackgroundTaskInvalid
    }
    
    ///即将退出
    @objc fileprivate func appWillTerminate(noti: Notification) {
        cancelAllTasks()
    }
    
    
    
    fileprivate func cancelAllTasks() {
        for (k,_) in taskDict! {
            taskDict?.removeValue(forKey: k)
        }
        
    }
}

extension SBDownload {
    //仿写OC的@synchronized
    fileprivate func sychronized(lock:AnyObject?,closure:()->()) {
        
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
}


