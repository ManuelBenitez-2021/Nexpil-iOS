//
//  ProfileAddCommunityModalView.swift
//  Nexpil
//
//  Created by JinYingZhe on 1/24/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

protocol ProfileAddCommunityModalViewDelegate {
    func popAddCommunityViewDismissal()
    func popAddCommunityViewTextClick()
    func popAddCommunityViewEmailClick()
}

class ProfileAddCommunityModalView: UIView {
    @IBOutlet weak var backUV: UIView!
    @IBOutlet weak var wholeUV: UIView!
    @IBOutlet weak var closeUB: UIButton!
    @IBOutlet weak var textNPB: NPButton!
    @IBOutlet weak var emailNPB: NPButton!
    
    @IBOutlet weak var messageUL: UILabel!
    
    var delegate: ProfileAddCommunityModalViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //  Initialation code
        backUV.setPopItemViewStyle(radius: 30.0, title: .large)
        closeUB.setPopItemViewStyle(radius: 22.5)
        
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
        self.delegate?.popAddCommunityViewDismissal()
    }
    
    @objc func wholeTapped(tapGestureRecognizer gesture: UITapGestureRecognizer) {
        self.delegate?.popAddCommunityViewDismissal()
    }
    
    @IBAction func onClickTextUB(_ sender: Any) {
        self.delegate?.popAddCommunityViewTextClick()
    }
    
    @IBAction func onClickEmailUB(_ sender: Any) {
        self.delegate?.popAddCommunityViewEmailClick()
    }
}
