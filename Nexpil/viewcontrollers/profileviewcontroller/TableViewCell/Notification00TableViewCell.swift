//
//  Notification00TableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/08/22.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class Notification00TableViewCell: UITableViewCell {

    @IBOutlet weak var bgView0: UIView!
    @IBOutlet weak var bgView1: UIView!
    @IBOutlet weak var lblTitle0: UILabel!
    @IBOutlet weak var lblTitle1: UILabel!
    @IBOutlet weak var lblStatus0: UILabel!
    @IBOutlet weak var lblStatus1: UILabel!
    
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
        
        bgView0.layer.masksToBounds = true
        bgView0.layer.cornerRadius = 10
        
        bgView1.layer.masksToBounds = true
        bgView1.layer.cornerRadius = 10

        lblTitle0.font = UIFont(name: "Montserrat", size: 20)!
        lblTitle1.font = UIFont(name: "Montserrat", size: 20)!
        lblStatus0.font = UIFont(name: "Montserrat", size: 15)!
        lblStatus1.font = UIFont(name: "Montserrat", size: 15)!
        
        self.setStatus(flag: true)
    }
    
    func setStatus(flag: Bool) {
        if flag == true {
            lblTitle0.textColor = UIColor.init(hex: "ffffff")
            lblTitle1.textColor = UIColor.init(hex: "333333")
            lblStatus0.textColor = UIColor.init(hex: "ffffff")
            lblStatus1.textColor = UIColor.init(hex: "333333")
            bgView0.backgroundColor = UIColor.init(hex: "4660e4")
            bgView1.backgroundColor = UIColor.init(hex: "ffffff")
            
            lblStatus0.text = "On"
            lblStatus1.text = "Off"
            
        } else {
            lblTitle0.textColor = UIColor.init(hex: "333333")
            lblTitle1.textColor = UIColor.init(hex: "ffffff")
            lblStatus0.textColor = UIColor.init(hex: "333333")
            lblStatus1.textColor = UIColor.init(hex: "ffffff")
            bgView0.backgroundColor = UIColor.init(hex: "ffffff")
            bgView1.backgroundColor = UIColor.init(hex: "4660e4")
            
            lblStatus0.text = "Off"
            lblStatus1.text = "On"
        }
    }

    @IBAction func tapButton0(_ sender: Any) {
        self.setStatus(flag: true)
    }
    
    @IBAction func tapButton1(_ sender: Any) {
        self.setStatus(flag: false)
    }
    
}
