//
//  ProfileConditionDetailModalView.swift
//  Nexpil
//
//  Created by JinYingZhe on 1/23/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

protocol ProfileConditionDetailModalViewDelegate {
    func popConditionDetailViewDismissal()
}

class ProfileConditionDetailModalView: UIView {
    @IBOutlet weak var backUV: UIView!
    @IBOutlet weak var wholeUV: UIView!
    @IBOutlet weak var closeUB: UIButton!
    
    @IBOutlet weak var aboutUB: UIButton!
    @IBOutlet weak var aboutUV: UIView!
    @IBOutlet weak var symptomsUB: UIButton!
    @IBOutlet weak var sympotomsUV: UIView!
    @IBOutlet weak var treatmentsUB: UIButton!
    @IBOutlet weak var treatmentsUV: UIView!
    
    @IBOutlet weak var firstUL: UILabel!
    @IBOutlet weak var secondUL: UILabel!
    @IBOutlet weak var thirdUL: UILabel!
    @IBOutlet weak var secondUV: UIView!
    
    @IBOutlet weak var titleUL: UILabel!
    
    var delegate: ProfileConditionDetailModalViewDelegate?
    let largeSpacing = 5
    let smallSpacing = 5

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //  Initialation code
        backUV.setPopItemViewStyle(radius: 30.0, title: .large)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(wholeTapped(tapGestureRecognizer:)))
        wholeUV.addGestureRecognizer(tapGestureRecognizer)
        
        self.closeUB.setPopItemViewStyle(radius: 22.5)
        
        firstUL.setParagraphSpacing(space: largeSpacing)
        secondUL.setParagraphSpacing(space: smallSpacing)
        thirdUL.setParagraphSpacing(space: largeSpacing)
        
        secondUV.setPopItemViewStyle()
    }
    
    @objc func wholeTapped(tapGestureRecognizer gesture: UITapGestureRecognizer) {
        self.delegate?.popConditionDetailViewDismissal()
    }
    
    @IBAction func onClickCloseUB(_ sender: Any) {
        self.delegate?.popConditionDetailViewDismissal()
    }
    
    @IBAction func onClickTabMenuBtn(_ sender: Any) {
        aboutUB.setTitleColor(UIColor(hex: "333333", alpha: 0.5), for: .normal)
        symptomsUB.setTitleColor(UIColor(hex: "333333", alpha: 0.5), for: .normal)
        treatmentsUB.setTitleColor(UIColor(hex: "333333", alpha: 0.5), for: .normal)
        aboutUV.backgroundColor = UIColor(hex: "333333", alpha: 0.5)
        sympotomsUV.backgroundColor = UIColor(hex: "333333", alpha: 0.5)
        treatmentsUV.backgroundColor = UIColor(hex: "333333", alpha: 0.5)
        switch (sender as AnyObject).tag {
        case 0:
            do {
                aboutUB.setTitleColor(UIColor.blue, for: .normal)
                aboutUV.backgroundColor = UIColor.blue
            }
            break
        case 1:
            do {
                symptomsUB.setTitleColor(UIColor.blue, for: .normal)
                sympotomsUV.backgroundColor = UIColor.blue
            }
            break
        case 2:
            do {
                treatmentsUB.setTitleColor(UIColor.blue, for: .normal)
                treatmentsUV.backgroundColor = UIColor.blue
            }
            break
        default:
            break
        }
    }
    
}
