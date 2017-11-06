//
//  DownloadRecipt.swift
//  downloadDemo
//
//  Created by Stan on 2017-08-24.
//  Copyright © 2017 stan. All rights reserved.
//

import Foundation
enum DownloadState {
    case none
    case willResume
    case downing
    case suspend
    case completed
    case failed
}

enum DownloadPrioritization {
    case fifo
    case lifo
}

typealias DownloadProgressClosure = (_ receivedSize: Int, _ expectedSize: Int, _ speed: Int, _ targetURL: URL) -> ()

typealias DownloadCompletedClosure = (_ receipt: DownloadRecipt, _ error: Error, _ finished: Bool) -> ()

class DownloadRecipt: NSObject {
    
   private(set) var state: DownloadState?
   private(set) var url: String?
   private(set) var filePath: String?
   private(set) var fileName: String?
   private(set) var trueName: String?
   private(set) var speed: String?
   private(set) var totalBytesWritter: Int?
   private(set) var totalExpectedToWirte: Int?
   private(set) var progress: Progress?
   private(set) var error: Error?
   private(set) var downloaderProgressBlock: DownloadProgressClosure?
   private(set) var downloaderCompletedBlock: DownloadCompletedClosure?
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
