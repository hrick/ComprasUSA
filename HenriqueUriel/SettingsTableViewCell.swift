//
//  SettingsTableViewCell.swift
//  HenriqueUriel
//
//  Created by Admin on 22/10/17.
//  Copyright © 2017 FiapAluno. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var lbNameState: UILabel!
    @IBOutlet weak var lbTax: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
