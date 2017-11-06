//
//  SBDownloadCenter.swift
//  ResumptionDemo
//
//  Created by Stan on 2017-08-20.
//  Copyright © 2017 stan. All rights reserved.
//

import UIKit

class SBDownloadCenter: NSObject {
    /// 下载过程中回调的代码块，会多次调用
    typealias ProcessHandle = (_ progressValue:Float, _ size:String?) -> Void
    /// 下载完成的回调
    typealias CompletionHandle = () -> Void
    /// 下载失败的回调
    typealias FailureHandle = (_ error:Error) -> Void
    
    
    var cachePath: String?
    var urlPath: String?
    var process: ProcessHandle?
    var completion: CompletionHandle?
    var failure: FailureHandle?
    
    
    var connection:NSURLConnection?

    
    private var timer: Timer?
    
    var growthSize: NSInteger?
    var lastSize: NSInteger?
    
    
    
    //MARK:便捷方法
    class func center() -> SBDownloadCenter {
        
        let center = SBDownloadCenter();
        return center;
    }
    
    override init() {
        super.init()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(getGrowthSize), userInfo: nil, repeats: true)
    }
//    MARK: 计算网速
    func getGrowthSize() {
        do {
            let dict: Dictionary = try FileManager.default.attributesOfItem(atPath: cachePath!)
            
            let size = dict[.size] as! NSInteger
            
            growthSize = size - lastSize!
            lastSize = size
        } catch  {
            print(error)
            fatalError()
        }
    }
    func cancel() {
        connection?.cancel()
        connection = nil
    }
    
    func download(urlString: String?, cacheString: String?, process: ProcessHandle?, completion: CompletionHandle?, failure: FailureHandle?) {
        
        guard let urlPath = urlString, let cachePath = cacheString else { return }
        
        self.urlPath = urlPath
        self.cachePath = cachePath
        self.process = process
        self.completion = completion
        self.failure = failure
        
        
        //        判断文件夹中是否已经存在
        let fileExist = FileManager.default.fileExists(atPath: cachePath)
        
        guard let url = URL(string: urlPath) else { return }
        let request = NSMutableURLRequest(url: url)
        
        
        if fileExist {
            do {
                let attr = try FileManager.default.attributesOfItem(atPath: cachePath)
                let size = attr[FileAttributeKey.size] as! NSInteger
                let rangString = String(format: "bytes=%ld-", size)
                
                //                给当前request加Range头部，下次请求带上头部，可以从rangString继续下载
                request.setValue(rangString, forHTTPHeaderField: "Range")
                
                
                
            } catch  {
                print("error:\(error)")
                fatalError()
            }

        }
        
        connection = NSURLConnection(request: request as URLRequest, delegate: self)
    }
}
