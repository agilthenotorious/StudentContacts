//
//  DetailTableViewCell.swift
//  Students
//
//  Created by Agil Madinali on 9/21/20.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var detailKeyLabel: UILabel!
    @IBOutlet weak var detailValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
