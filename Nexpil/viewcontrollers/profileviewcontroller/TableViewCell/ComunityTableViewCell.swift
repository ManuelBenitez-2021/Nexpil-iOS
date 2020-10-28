//
//  ComunityTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/08/20.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ComunityTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblName: UILabel!
    
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
        self.contentView.backgroundColor = UIColor.clear
        
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 10
        
        lblName.font = UIFont(name: "Montserrat-Medium", size: 20)!
        lblName.textColor = UIColor.init(hex: "333333")
        
    }
    
    func setInfo(dic: NSDictionary) {
        var strName = ""
        if dic["name"] != nil {
            strName = dic["name"] as! String
        }
        
        lblName.text = strName
    }
    
}
