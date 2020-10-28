//
//  MoodTableViewCell.swift
//  Nexpil
//
//  Created by Admin on 07/07/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import OnlyPictures
class MoodTableViewCell: UITableViewCell {

    @IBOutlet weak var mediaimage: UIImageView!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var createTime: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var likebtn: UIButton!
    @IBOutlet weak var likecnt: UILabel!
    @IBOutlet weak var commentbtn: UIButton!
    @IBOutlet weak var commentcnt: UILabel!
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var onlypictures: OnlyHorizontalPictures!
    @IBOutlet weak var moodImage: UIImageView!
    @IBOutlet weak var moodText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
