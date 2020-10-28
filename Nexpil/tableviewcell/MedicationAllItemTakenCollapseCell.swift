//
//  MedicationAllItemTakenCollapseCell.swift
//  Nexpil
//
//  Created by Yun Lai on 2018/12/5.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class MedicationAllItemTakenCollapseCell: UITableViewCell {
    
    @IBOutlet weak var vwArrowRight: UIView!
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
