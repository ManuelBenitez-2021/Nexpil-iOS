//
//  ProfilePharmacyDetailModalView.swift
//  Nexpil
//
//  Created by JinYingZhe on 1/24/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

protocol ProfilePharmacyDetailModalViewDelegate {
    func popPharmacyDetailViewDismissal()
}

class ProfilePharmacyDetailModalView: UIView {
    @IBOutlet weak var backUV: UIView!
    @IBOutlet weak var wholeUV: UIView!
    @IBOutlet weak var closeUB: UIButton!
    @IBOutlet weak var weekUV: UIView!
    @IBOutlet weak var weekUSV: UIStackView!
    
    @IBOutlet weak var sundayUV: UIView!
    @IBOutlet weak var saturdayUV: UIView!
    
    var delegate: ProfilePharmacyDetailModalViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //  Initialation code
        backUV.setPopItemViewStyle(radius: 30.0, title: .large)
        closeUB.setPopItemViewStyle(radius: 22.5)
        
        sundayUV.layer.cornerRadius = 20.0
        saturdayUV.layer.cornerRadius = 20.0
        weekUSV.layer.cornerRadius = 20.0
        weekUV.setPopItemViewStyle()
        
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
    
    @IBAction func onClickCloseUB(_ sender: Any) {
        self.delegate?.popPharmacyDetailViewDismissal()
    }
    
    @objc func wholeTapped(tapGestureRecognizer gesture: UITapGestureRecognizer) {
        self.delegate?.popPharmacyDetailViewDismissal()
    }

}
