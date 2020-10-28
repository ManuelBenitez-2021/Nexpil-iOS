//
//  CategoryTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/28.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var lbUnit: UILabel!
    @IBOutlet weak var ivIcon: UIImageView!
    
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
        bgView.viewShadow_Category()
        
        lbTitle.font = UIFont.init(name: "Montserrat", size: 20)
        lbValue.font = UIFont.init(name: "Montserrat", size: 24)
        lbUnit.font = UIFont.init(name: "Montserrat", size: 12)
        
    }
    
    func setInfo(array: NSMutableArray, index: NSInteger)  {
        if array.count > 0 {
            let dic = array[index] as! NSDictionary
            var strTitle: String = ""
            var strValue: String = ""
            var strImage: String = ""
            var strUnit: String = ""
            var strIcon: String = ""
            var strUnitColor: String = ""
            
            if dic["title"] != nil {
                strTitle = dic["title"] as! String
            }
            if dic["image"] != nil {
                strImage = dic["image"] as! String
            }
            if dic["value"] != nil {
                strValue = dic["value"] as! String
            }
            if dic["unit"] != nil {
                strUnit = dic["unit"] as! String
            }
            if dic["icon"] != nil {
                strIcon = dic["icon"] as! String
            }
            if dic["unit_color"] != nil {
                strUnitColor = dic["unit_color"] as! String
            }
            
            
            lbTitle.text = strTitle
            lbValue.text = strValue
            imgBg.image = UIImage.init(named: strImage)
            lbUnit.text = strUnit
            ivIcon.image = UIImage.init(named: strIcon)
            
            if (strUnitColor != "") {
                lbValue.textColor = UIColor.init(hex: strUnitColor)
                lbUnit.textColor = UIColor.init(hex: strUnitColor)
            }
            
        }
        
    }
    
}
