//
//  MedicationAddItemTableViewCell.swift
//  Nexpil
//
//  Created by Admin on 18/12/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class MedicationAddItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemView: UIView!
    
    @IBOutlet weak var name: UIButton!
    @IBOutlet weak var checkimage: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
