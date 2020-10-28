//
//  TitleTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/08/21.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

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
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        bgView.backgroundColor = UIColor.clear
        
        lblTitle.font = UIFont(name: "Montserrat-Medium", size: 30)!
        lblTitle.textColor = UIColor.init(hex: "333333")
    }
    
    func setTitle(str: String) {
        lblTitle.text = str
        
    }
    
}
