//
//  SettingPasswordModalView.swift
//  Nexpil
//
//  Created by JinYingZhe on 1/30/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

protocol SettingPasswordModalViewDelegate {
    func popSettingPasswordModalViewDismissal()
    func popSettingPasswordSaveView()
}

class SettingPasswordModalView: UIView {
    @IBOutlet weak var backUV: UIView!
    @IBOutlet weak var backUB: UIButton!
    @IBOutlet weak var saveUB: UIButton!
    
    var delegate: SettingPasswordModalViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //  Initialation code
        backUV.setPopItemViewStyle(radius: 30.0, title: .large)
        backUB.setPopItemViewStyle(radius: 22.5)
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBAction func onClickBackUB(_ sender: Any) {
        self.delegate?.popSettingPasswordModalViewDismissal()
    }
    
    @IBAction func onClickSaveUB(_ sender: Any) {
        self.delegate?.popSettingPasswordSaveView()
    }

}
