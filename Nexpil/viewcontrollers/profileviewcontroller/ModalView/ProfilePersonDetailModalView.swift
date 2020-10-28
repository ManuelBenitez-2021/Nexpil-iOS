//
//  ProfilePersonDetailModalView.swift
//  Nexpil
//
//  Created by JinYingZhe on 1/25/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

protocol ProfilePersonDetailModalViewDelegate {
    func popPersonDetailViewDismissal()
}

class ProfilePersonDetailModalView: UIView {
    @IBOutlet weak var backUV: UIView!
    @IBOutlet weak var wholeUV: UIView!
    @IBOutlet weak var closeUB: UIButton!
    
    @IBOutlet weak var avatarUIV: UIImageView!
    @IBOutlet weak var avatarUV: UIView!
    @IBOutlet weak var nameUL: UILabel!
    @IBOutlet weak var birthUL: UILabel!
    @IBOutlet weak var maleUB: UIButton!
    @IBOutlet weak var femaleUB: UIButton!
    @IBOutlet weak var phoneUL: UILabel!
    @IBOutlet weak var addressUL: UILabel!
    
    @IBOutlet weak var spaceUV1: UIView!
    @IBOutlet weak var spaceUV2: UIView!
    @IBOutlet weak var spaceUV3: UIView!
    @IBOutlet weak var spaceUV4: UIView!
    
    var delegate: ProfilePersonDetailModalViewDelegate?
    var isMale: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //  Initialation code
        backUV.setPopItemViewStyle(title: PShadowType.large)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(wholeTapped(tapGestureRecognizer:)))
        wholeUV.addGestureRecognizer(tapGestureRecognizer)
        
//        avatarUIV.setPopItemViewStyle(title: PShadowType.small)
        avatarUIV.layer.cornerRadius = 50.0
        avatarUV.setPopItemViewStyle(title: PShadowType.small)
        avatarUV.layer.cornerRadius = 50.0
        
        closeUB.setPopItemViewStyle(title: PShadowType.small)
        closeUB.layer.cornerRadius = 22.5
        
        maleUB.setPopItemViewStyle(title: PShadowType.small)
        femaleUB.setPopItemViewStyle(title: PShadowType.small)
        
        spaceUV1.setGradientStyle(gradient: PColorScheme.blue.gradient)
        spaceUV2.setGradientStyle(gradient: PColorScheme.blue.gradient)
        spaceUV3.setGradientStyle(gradient: PColorScheme.blue.gradient)
        spaceUV4.setGradientStyle(gradient: PColorScheme.blue.gradient)
        
        let preference = PreferenceHelper()
        
        if preference.getUserImage()! == ""
        {
            let image = UIImage(named: "Intersection 1")
            avatarUIV.image = image
            avatarUIV.contentMode = .bottom
        }
        else
        {
            let url = URL(string: DataUtils.PROFILEURL + preference.getUserImage()!)
            avatarUIV.kf.setImage(with: url)
            
            let username = preference.getUserName()
            nameUL.text = username
            let birthday = preference.getBirthday()
            birthUL.text = birthday
            let gender = preference.getSex()
            if gender == "Male" {
                isMale = true
            } else {
                isMale = false
            }
        }
        
        self.selectedGender()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @objc func wholeTapped(tapGestureRecognizer gesture: UITapGestureRecognizer) {
        self.delegate?.popPersonDetailViewDismissal()
    }
    
    @IBAction func onClickCloseUB(_ sender: Any) {
        self.delegate?.popPersonDetailViewDismissal()
    }
    
    func selectedGender() {
        if isMale {
            femaleUB.backgroundColor = UIColor.white
            femaleUB.setTitleColor(UIColor(hex: "333333", alpha: 0.5), for: .normal)
            maleUB.backgroundColor = PColorScheme.blue.color
            maleUB.setTitleColor(.white, for: .normal)
        } else {
            maleUB.backgroundColor = UIColor.white
            maleUB.setTitleColor(UIColor(hex: "333333", alpha: 0.5), for: .normal)
            femaleUB.backgroundColor = PColorScheme.blue.color
            femaleUB.setTitleColor(.white, for: .normal)
        }
    }

    @IBAction func onClickMaleUB(_ sender: Any) {
        isMale = true
        self.selectedGender()
    }
    
    @IBAction func onClickFemaleUB(_ sender: Any) {
        isMale = false
        self.selectedGender()
    }
    
}
