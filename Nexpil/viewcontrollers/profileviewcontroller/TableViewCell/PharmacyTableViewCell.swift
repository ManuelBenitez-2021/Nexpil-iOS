//
//  PharmacyTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/08/20.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class PharmacyTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.initMainView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initMainView() {
        self.backgroundColor = UIColor.clear
        
        bgView.layer.masksToBounds = false
        bgView.layer.cornerRadius = 10
        
        lblName.font = UIFont(name: "Montserrat-Medium", size: 20)!
        lblName.textColor = UIColor.init(hex: "333333")
        
        lblPhone.font = UIFont(name: "Montserrat", size: 15)!
        lblPhone.textColor = UIColor.init(hex: "333333")
    }
    
    func setInfo(dic: NSDictionary) {
        var strImage = ""
        var strName = ""
        var strPhone = ""
        
        if dic["image"] != nil {
            strImage = dic["image"] as! String
        }
        if dic["name"] != nil {
            strName = dic["name"] as! String
        }
        if dic["phone"] != nil {
            strPhone = dic["phone"] as! String
        }
        
        imgLogo.image = UIImage.init(named: strImage)
        lblName.text = strName
        lblPhone.text = strPhone

    }
}
