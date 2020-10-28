//
//  ScheduleTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/08/20.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
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
        
        lblTitle.font = UIFont(name: "Montserrat-Medium", size: 20)!
        lblTitle.textColor = UIColor.init(hex: "333333")
        
        lblTime.font = UIFont(name: "Montserrat", size: 15)!
        lblTime.textColor = UIColor.init(hex: "333333")
    }
    
    func setInfo(dic: NSDictionary) {
        var strTitle = ""
        var strTimeStart = ""
        var strTimeEnd = ""
        
        if dic["title"] != nil {
            strTitle = dic["title"] as! String
        }
        if dic["timeStart"] != nil {
            strTimeStart = dic["timeStart"] as! String
        }
        if dic["timeEnd"] != nil {
            strTimeEnd = dic["timeEnd"] as! String
        }
        
        lblTitle.text = strTitle
        lblTime.text = String(format: "%@ - %@", strTimeStart, strTimeEnd)
        
    }
}
