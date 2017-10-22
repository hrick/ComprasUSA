//
//  ProductTableViewCell.swift
//  HenriqueUriel
//
//  Created by Admin on 22/10/17.
//  Copyright © 2017 FiapAluno. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var ivPicture: UIImageView!
    @IBOutlet weak var lbState: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
