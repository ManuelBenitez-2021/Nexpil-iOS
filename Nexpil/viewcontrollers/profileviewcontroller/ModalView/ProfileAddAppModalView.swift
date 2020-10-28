//
//  ProfileAddAppModalView.swift
//  Nexpil
//
//  Created by JinYingZhe on 1/24/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

protocol ProfileAddAppModalViewDelegate {
    func popAddAppViewDismissal()
    func popAddAppViewAddClick()
}

class ProfileAddAppModalView: UIView {
    @IBOutlet weak var backUV: UIView!
    @IBOutlet weak var wholeUV: UIView!
    @IBOutlet weak var closeUB: UIButton!
    @IBOutlet weak var addUB: NPButton!
    
    @IBOutlet weak var item1UV: UIView!
    @IBOutlet weak var item2UV: UIView!
    @IBOutlet weak var item3UV: UIView!
    
    var delegate: ProfileAddAppModalViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //  Initialation code
        backUV.setPopItemViewStyle(radius: 30.0, title: .large)
        closeUB.setPopItemViewStyle(radius: 22.5)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(wholeTapped(tapGestureRecognizer:)))
        wholeUV.addGestureRecognizer(tapGestureRecognizer)
    
        item1UV.setPopItemViewStyle()
        item2UV.setPopItemViewStyle()
        item3UV.setPopItemViewStyle()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func onClickCloseUB(_ sender: Any) {
        self.delegate?.popAddAppViewDismissal()
    }
    
    @objc func wholeTapped(tapGestureRecognizer gesture: UITapGestureRecognizer) {
        self.delegate?.popAddAppViewDismissal()
    }
    
    @IBAction func onClickAddUB(_ sender: Any) {
        self.delegate?.popAddAppViewAddClick()
    }
}
