//
//  HistoryTableViewCell.swift
//  MusicOriginal
//
//  Created by Yuri Tsuchikawa on 2023/09/04.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var dateLable: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
