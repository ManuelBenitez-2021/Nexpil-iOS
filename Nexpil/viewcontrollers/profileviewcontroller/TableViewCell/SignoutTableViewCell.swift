//
//  SignoutTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/08/22.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class SignoutTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
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
        bgView.backgroundColor = UIColor.init(hex: "4660e4")
        
        lblTitle.font = UIFont(name: "Montserrat-Medium", size: 20)!
        lblTitle.textColor = UIColor.init(hex: "ffffff")
    }
}
