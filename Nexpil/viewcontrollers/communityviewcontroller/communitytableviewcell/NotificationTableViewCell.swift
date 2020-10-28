//
//  NotificationTableViewCell.swift
//  Nexpil
//
//  Created by Admin on 4/12/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundview: UIView!
    @IBOutlet weak var userphoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundview.viewShadow()
        
        userphoto.layer.cornerRadius = userphoto.frame.size.width/2
        userphoto.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
