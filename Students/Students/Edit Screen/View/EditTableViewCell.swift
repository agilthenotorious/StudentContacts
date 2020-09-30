//
//  EditTableViewCell.swift
//  Students
//
//  Created by Agil Madinali on 9/21/20.
//

import UIKit

class EditTableViewCell: UITableViewCell {

    @IBOutlet weak var editKeyLabel: UILabel!
    @IBOutlet weak var editValueTextField: CustomTextField!
    
    weak var editDelegate: EditDelegate?
    
    @IBAction func modifiedText(_ textField: CustomTextField) {
        self.editDelegate?.modifiedTextField(textField)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
