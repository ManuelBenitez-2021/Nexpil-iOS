//
//  Notification01TableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/08/22.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class Notification01TableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
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
        lblValue.font = UIFont(name: "Montserrat-Medium", size: 15)!
        lblValue.textColor = UIColor.init(hex: "222222")

    }
    
}
