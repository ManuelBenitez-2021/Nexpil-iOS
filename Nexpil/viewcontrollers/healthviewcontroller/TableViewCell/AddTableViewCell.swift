//
//  AddTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/31.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit

class AddTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true;
        
        lblTitle.font = UIFont.init(name: "Montserrat", size: 20)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setInfo(index: NSInteger) {
        let colorBule   = "397ee3"
        let colorPurple = "4939e3"
        let colorSky    = "39d3e3"

        var strTitle = ""
        var strColor = ""
        
        if index == 0 {
            strTitle = "Measurements"
            strColor = colorBule
            
        } else if index == 1 {
            strTitle = "Measurements"
            strColor = colorPurple

        } else if index == 2 {
            strTitle = "Measurements"
            strColor = colorSky

        } else if index == 3 {
            strTitle = "Mood"
            strColor = colorBule

//        } else if index == 4 {
//            strTitle = "Mood"
//            strColor = colorBule

        } else if index == 5 {
            strTitle = "Weight"
            strColor = colorPurple

        } else if index == 6 {
            strTitle = "Measurements"
            strColor = colorSky

        } else if index == 7 {
            strTitle = "Numbers"
            strColor = colorPurple

        } else if index == 8 {
            strTitle = "Numbers"
            strColor = colorBule

        }
        
        lblTitle.text = "Add " + strTitle
        bgView.backgroundColor = UIColor.init(hexString: strColor)
    }
    
}
