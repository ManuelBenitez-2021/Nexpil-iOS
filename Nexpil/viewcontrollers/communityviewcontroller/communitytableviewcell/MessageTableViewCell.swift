//
//  MessageTableViewCell.swift
//  Nexpil
//
//  Created by Admin on 4/11/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var like: UIButton!
    @IBOutlet weak var likecounts: UILabel!
    @IBOutlet weak var comment: UIButton!
    @IBOutlet weak var commentcounts: UILabel!
    @IBOutlet weak var commentimages: UIImageView!
    @IBOutlet weak var commentphoto: UIImageView!
    @IBOutlet weak var messageview: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageview.viewShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
