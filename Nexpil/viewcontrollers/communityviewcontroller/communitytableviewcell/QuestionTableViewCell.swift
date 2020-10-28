//
//  QuestionTableViewCell.swift
//  Nexpil
//
//  Created by Admin on 4/11/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var questiontitle: UILabel!
    @IBOutlet weak var questioncontent: UILabel!
    @IBOutlet weak var questionview: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        questionview.layer.cornerRadius = 10;
        questionview.layer.masksToBounds = true;
        
        questionview.layer.borderColor = UIColor.lightGray.cgColor
        questionview.layer.borderWidth = 0.5;
        questionview.layer.contentsScale = UIScreen.main.scale;
        questionview.layer.shadowColor = UIColor.black.cgColor;
        questionview.layer.shadowOffset = CGSize.zero;
        questionview.layer.shadowRadius = 5.0;
        questionview.layer.shadowOpacity = 0.3;
        questionview.layer.masksToBounds = false;
        questionview.clipsToBounds = false;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
