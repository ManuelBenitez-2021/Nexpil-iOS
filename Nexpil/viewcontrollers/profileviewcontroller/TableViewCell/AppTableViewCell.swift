//
//  AppTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/08/20.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class AppTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.intiMainView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func intiMainView() {
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 10
        
        lblName.font = UIFont(name: "Montserrat-Medium", size: 20)!
        lblName.textColor = UIColor.init(hex: "333333")
    }
    
    func setInfo(dic: NSDictionary) {
        var strName = ""
        var strImage = ""
        
        if dic["name"] != nil {
            strName = dic["name"] as! String
        }
        if dic["image"] != nil {
            strImage = dic["image"] as! String
        }
        
        lblName.text = strName
        imgLogo.image = UIImage.init(named: strImage)
        
    }
    
}
