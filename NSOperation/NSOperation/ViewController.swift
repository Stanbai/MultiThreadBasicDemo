//
//  ViewController.swift
//  NSOperation
//
//  Created by Stan on 2017-07-05.
//  Copyright © 2017 stan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicOperation()
        CreatBasicBlockOperation()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //    最基本的使用Operation
    private func basicOperation() {
        //        第一步：创建Operation
        let op = Operation.init()
        //        第二步：把要执行的代码放入operation中
        op.completionBlock = {
            
            print(#function,#line,Thread.current)
        }
        //        第三步：创建OperationQueue
        let opQueue = OperationQueue.init()
        //        第四步：把Operation加入到线程中
        opQueue.addOperation(op)
    }
    
    
    
    
    //创建一个简单的BlockOperation
    private func CreatBasicBlockOperation() {
        //使用BlockOperation创建operation
        let operation = BlockOperation.init {
            //打印，看看在哪个线程中
            
            print(#function,#line,Thread.current)
        }
        
        //直接运行operation，看看运行在哪个线程中
        operation.start()
    }
    
}
