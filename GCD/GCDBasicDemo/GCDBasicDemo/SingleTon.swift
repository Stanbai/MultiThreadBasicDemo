//
//  SingleTon.swift
//  GCDBasicDemo
//
//  Created by Stan on 2017-07-31.
//  Copyright © 2017 stan. All rights reserved.
//

import UIKit

//使SingleTon变成太监类，不能够被继承
final class SingleTon: NSObject {
    static let shared = SingleTon()
    
//    私有化初始方法，防止被外界调用
    private override init() {}
}
