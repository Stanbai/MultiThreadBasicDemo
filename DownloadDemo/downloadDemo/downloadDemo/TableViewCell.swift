//
//  TableViewCell.swift
//  downloadDemo
//
//  Created by Stan on 2017-08-24.
//  Copyright © 2017 stan. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate {
    func cell(cell: TableViewCell, didClickBtn: UIButton) -> Void
}
class TableViewCell: UITableViewCell {
    


    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bytesLable: UILabel!
    @IBOutlet weak var speedLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


