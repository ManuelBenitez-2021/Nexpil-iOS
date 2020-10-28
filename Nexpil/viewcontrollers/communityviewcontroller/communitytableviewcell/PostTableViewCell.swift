//
//  PostTableViewCell.swift
//  Nexpil
//
//  Created by Admin on 4/11/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var userphoto: UIImageView!
    @IBOutlet weak var videobtn: UIButton!
    @IBOutlet weak var moodbtn: UIButton!
    @IBOutlet weak var photobtn: UIButton!
    @IBOutlet weak var userbackground: GradientView!
    @IBOutlet weak var userLabelView: GradientView!
    @IBOutlet weak var whatsonyourmind: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        /*
        userbackground.layer.cornerRadius = 10;
        userbackground.layer.masksToBounds = true        
        userbackground.clipsToBounds = true
        */
        /*
        userbackground.layer.borderColor = UIColor.white.cgColor
        userbackground.layer.borderWidth = 0.5;
        userbackground.layer.contentsScale = UIScreen.main.scale;
        userbackground.layer.shadowColor = UIColor(white: 0, alpha: 0.16).cgColor
        userbackground.layer.shadowOffset = CGSize(width: 3, height: 3)
        userbackground.layer.shadowRadius = 5.0;
        userbackground.layer.shadowOpacity = 1;
        userbackground.layer.masksToBounds = true
        userbackground.clipsToBounds = true
        */
        userLabelView.clipsToBounds = true
        userLabelView.layer.cornerRadius = 10
        userLabelView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
