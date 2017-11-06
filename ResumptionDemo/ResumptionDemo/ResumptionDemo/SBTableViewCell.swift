//
//  SBTableViewCell.swift
//  ResumptionDemo
//
//  Created by Stan on 2017-08-20.
//  Copyright © 2017 stan. All rights reserved.
//

import UIKit

class SBTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var completeLabel: UILabel!
    
    var downloadBlock: ((_ sender: UIButton?) -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupCellModel(model: SBDownloadModel) -> () {
        nameLabel.text = model.name
        
//        判断文件夹中是否已经存在
        let fileExist = FileManager.default.fileExists(atPath: model.cacheString)
        
        if fileExist {
            print("文件已经存在")
//            设置按钮的Btn
            if progressView.progress == 1.0 {
                downloadBtn.setTitle("完成", for: .normal)
            } else {
                downloadBtn.setTitle("恢复", for: .normal)
            }
        } else {
            print("文件不存在")
            downloadBtn.setTitle("开始", for: .normal)
            progressView.progress = 0.0
        }
    }

    @IBAction func downBtnClick(_ sender: Any) {
        if downloadBlock != nil {
            downloadBlock!(sender as? UIButton)
        }
    }
}
