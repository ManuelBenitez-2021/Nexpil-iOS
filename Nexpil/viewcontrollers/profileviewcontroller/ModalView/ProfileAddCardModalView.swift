//
//  ProfileAddCardModalView.swift
//  Nexpil
//
//  Created by JinYingZhe on 1/25/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

protocol ProfileAddCardModalViewDelegate {
    func popAddCardViewDismissal()
    func popAddCardViewVerifyBtnClick()
}

class ProfileAddCardModalView: UIView {
    @IBOutlet weak var backUV: UIView!
    @IBOutlet weak var verifyUB: UIButton!
    @IBOutlet weak var closeUB: UIButton!
    
    var delegate: ProfileAddCardModalViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //  Initialation code
        backUV.setPopItemViewStyle(title: PShadowType.large)
        
        closeUB.setPopItemViewStyle(title: PShadowType.small)
        closeUB.layer.cornerRadius = 22.5
        
        verifyUB.setGradientStyle(gradient: PColorScheme.blue.gradient)
        verifyUB.setPopItemViewStyle(title: PShadowType.small)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBAction func onClickCloseUB(_ sender: Any) {
        self.delegate?.popAddCardViewDismissal()
    }
    
    @IBAction func onClickVerifyUB(_ sender: Any) {
        self.delegate?.popAddCardViewVerifyBtnClick()
    }

}
