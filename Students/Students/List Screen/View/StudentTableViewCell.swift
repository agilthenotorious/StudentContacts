//
//  StudentTableViewCell.swift
//  Students
//
//  Created by Agil Madinali on 9/19/20.
//

import UIKit

class StudentTableViewCell: UITableViewCell {

    @IBOutlet weak var studentImageView: UIImageView!
    @IBOutlet weak var studentNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        configureImage()
    }
    
    func configureImage() {
        studentImageView.layer.cornerRadius = self.studentImageView.bounds.width/2
    }
}
