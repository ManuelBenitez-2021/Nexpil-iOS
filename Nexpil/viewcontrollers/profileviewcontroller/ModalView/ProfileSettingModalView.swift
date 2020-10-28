//
//  ProfileSettingModalView.swift
//  Nexpil
//
//  Created by JinYingZhe on 1/25/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

protocol ProfileSettingModalViewDelegate {
    func popSettingViewDismissal()
    func popSettingViewSignBtnClick()
    func popSettingViewBtnsClick(name: String)
}

class ProfileSettingModalView: UIView {
    @IBOutlet weak var backUV: UIView!
    @IBOutlet weak var closeUB: UIButton!
    @IBOutlet weak var emailUB: UIButton!
    @IBOutlet weak var passwordUB: UIButton!
    
    @IBOutlet weak var textOnUB: UIButton!
    @IBOutlet weak var emailOnUB: UIButton!
    @IBOutlet weak var snoozeUB: UIButton!
    @IBOutlet weak var noticationUB: NPButton!
    
    @IBOutlet weak var helpUB: UIButton!
    @IBOutlet weak var inviteUB: UIButton!
    @IBOutlet weak var rateUB: UIButton!
    @IBOutlet weak var feedbackUB: UIButton!
    
    @IBOutlet weak var termUB: UIButton!
    @IBOutlet weak var privacyUB: UIButton!
    @IBOutlet weak var disclaimerUB: UIButton!
    
    @IBOutlet weak var signOutUB: NPButton!
    
    var delegate: ProfileSettingModalViewDelegate?
    var isText: Bool = true
    var isEmail: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //  Initialation code
        backUV.setPopItemViewStyle(radius: 30.0, title: .large)
        self.closeUB.setPopItemViewStyle(radius: 22.5)
        
        emailUB.setPopItemViewStyle()
        passwordUB.setPopItemViewStyle()
        
        emailOnUB.setPopItemViewStyle()
        snoozeUB.setPopItemViewStyle()
        
        helpUB.setPopItemViewStyle()
        inviteUB.setPopItemViewStyle()
        rateUB.setPopItemViewStyle()
        feedbackUB.setPopItemViewStyle()
        
        termUB.setPopItemViewStyle()
        privacyUB.setPopItemViewStyle()
        disclaimerUB.setPopItemViewStyle()
        
        textOnUB.setPopItemViewStyle()
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBAction func onClickCloseUB(_ sender: Any) {
        self.delegate?.popSettingViewDismissal()
    }
    
    @IBAction func onClickVerifyUB(_ sender: Any) {
        self.delegate?.popSettingViewSignBtnClick()
    }

    @IBAction func onClickTextFlagUB(_ sender: Any) {
        if isText {
            textOnUB.titleLabel?.text = "   Text    Off"
            textOnUB.backgroundColor = UIColor.white
            textOnUB.setTitleColor(UIColor(hex: "333333", alpha: 0.2), for: .normal)
        } else {
            textOnUB.titleLabel?.text = "   Text    On"
            textOnUB.backgroundColor = PColorScheme.blue.color
            textOnUB.setTitleColor(.white, for: .normal)
        }
        isText = !isText
    }
    
    @IBAction func onClickEmailFlagUB(_ sender: Any) {
        if isEmail {
            emailOnUB.titleLabel?.text = "   Email    Off"
            emailOnUB.backgroundColor = UIColor.white
            emailOnUB.setTitleColor(UIColor(hex: "333333", alpha: 0.2), for: .normal)
        } else {
            emailOnUB.titleLabel?.text = "   Email    On"
            emailOnUB.backgroundColor = PColorScheme.blue.color
            emailOnUB.setTitleColor(.white, for: .normal)
        }
        isEmail = !isEmail
    }
    
    @IBAction func onClickSettingUBs(_ sender: Any) {
        let btn = sender as! UIButton
        let title: String = (btn.titleLabel?.text)!
        self.delegate?.popSettingViewBtnsClick(name: title)
    }
}
