//
//  MedicationHistoryCellTableViewCell.swift
//  Nexpil
//
//  Created by Admin on 4/7/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class MedicationItemCell: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var checkbtn: UIButton!  
    
    @IBOutlet weak var backgroundheight: NSLayoutConstraint!
    @IBOutlet weak var backgroundview: UIView!
    @IBOutlet weak var lasttakenView: UIView!
    @IBOutlet weak var lasttakenTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code       
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
