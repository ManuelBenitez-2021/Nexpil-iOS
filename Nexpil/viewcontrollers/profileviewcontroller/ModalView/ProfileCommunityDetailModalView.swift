//
//  ProfileCommunityDetailModalView.swift
//  Nexpil
//
//  Created by JinYingZhe on 1/24/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

protocol ProfileCommunityDetailModalViewDelegate {
    func popCommunityDetailViewDismissal()
}

class ProfileCommunityDetailModalView: UIView {
    @IBOutlet weak var backUV: UIView!
    @IBOutlet weak var wholeUV: UIView!
    @IBOutlet weak var closeUB: UIButton!
    
    @IBOutlet weak var titleUL: UILabel!
    @IBOutlet weak var avatarUIV: UIImageView!
    @IBOutlet weak var avatarUV: UIView!
    @IBOutlet weak var medicationUB: NPButton!
    @IBOutlet weak var specialUB: NPButton!
    @IBOutlet weak var adherenceUB: UIButton!
    @IBOutlet weak var healthUB: UIButton!
    @IBOutlet weak var specUV: UIView!
    @IBOutlet weak var topBottomLC: NSLayoutConstraint!
    
    var delegate: ProfileCommunityDetailModalViewDelegate?
    
    var isShown: Bool = true
    let gradiantLayer1: CAGradientLayer = CAGradientLayer()
    var gradiantLayer2: CAGradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //  Initialation code
        backUV.setPopItemViewStyle(radius: 30.0, title: .large)
        closeUB.setPopItemViewStyle(radius: 22.5)
        avatarUIV.layer.cornerRadius = 50.0
        avatarUV.setPopItemViewStyle(radius: 50.0)
        
        adherenceUB.setPopItemViewStyle()
        healthUB.setPopItemViewStyle()

        specialUB.setPopItemViewStyle()
        specialUB.titleLabel?.numberOfLines = 3
        specialUB.titleLabel?.textAlignment = .center
        medicationUB.setPopItemViewStyle()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(wholeTapped(tapGestureRecognizer:)))
        wholeUV.addGestureRecognizer(tapGestureRecognizer)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBAction func onClickMedicationUB(_ sender: Any) {
        if isShown {
            isShown = false
            specialUB.isHidden = true
            adherenceUB.isHidden = true
            specUV.isHidden = true
            topBottomLC.constant = 15.0
        } else {
            isShown = true
            specialUB.isHidden = false
            adherenceUB.isHidden = false
            specUV.isHidden = false
            topBottomLC.constant = 207.0
        }
    }
    
    @IBAction func onClickCloseUB(_ sender: Any) {
        self.delegate?.popCommunityDetailViewDismissal()
    }
    
    @objc func wholeTapped(tapGestureRecognizer gesture: UITapGestureRecognizer) {
        self.delegate?.popCommunityDetailViewDismissal()
    }
}
