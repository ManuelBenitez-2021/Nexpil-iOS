//
//  AppItemView.swift
//  Nexpil
//
//  Created by JinYingZhe on 1/24/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class AppItemView: UIView {
    @IBOutlet weak var wholeUV: UIView!
    @IBOutlet weak var nameUL: UILabel!
    @IBOutlet weak var avatarUIV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setDectorContent(withData data: NSDictionary) {
        let name = data.value(forKey: "name")
        let image = data.value(forKey: "image")
        
        nameUL.text = name as? String
        avatarUIV.image = UIImage(named: (image as? String)!)
        
        let radiu = avatarUIV.layer.frame.width / 2
        avatarUIV.layer.cornerRadius = radiu
        
        wholeUV.setPopItemViewStyle()
        wholeUV.layer.cornerRadius = 22.5
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
