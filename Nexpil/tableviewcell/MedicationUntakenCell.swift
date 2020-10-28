//
//  MedicationHistoryPrescriptionTableViewCell.swift
//  Nexpil
//
//  Created by Admin on 4/25/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class MedicationUntakenCell: UITableViewCell {

    @IBOutlet weak var checkbtn: UIButton!
    @IBOutlet weak var medicationname: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var backgroundview: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
