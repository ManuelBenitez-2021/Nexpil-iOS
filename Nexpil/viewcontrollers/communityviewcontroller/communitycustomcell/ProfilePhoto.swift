//
//  ProfilePhoto.swift
//  Nexpil
//
//  Created by Admin on 4/9/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ProfilePhoto: UIView {

    var photoImage: UIImageView = UIImageView()
    var userName: UILabel = UILabel()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // #2
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    // #3
    public convenience init(image: UIImage, title: String) {
        self.init(frame: .zero)
        self.photoImage.image = image
        self.userName.text = title
        setupView()
    }
    
    private func setupView() {
        //translatesAutoresizingMaskIntoConstraints = false
        
        // Create, add and layout the children views ..
        
        userName.textColor = UIColor.init(hex: "333333")
        userName.font = UIFont(name: "Montserrat-Medium", size: 12)
        
        photoImage.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        userName.frame = CGRect(x: 0, y: 88, width: 80, height: 18)
        userName.textAlignment = .center
        addSubview(photoImage)
        addSubview(userName)
    }
    
}
