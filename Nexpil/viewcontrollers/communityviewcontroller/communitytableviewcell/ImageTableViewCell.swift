//
//  ImageTableViewCell.swift
//  Nexpil
//
//  Created by Admin on 4/11/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import OnlyPictures
class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var mediaimage: UIImageView!
    @IBOutlet weak var playbtn: UIButton!
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
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }    
    override func prepareForReuse() {
        super.prepareForReuse()
        //here set all control values to nil like below
        
    }
}
