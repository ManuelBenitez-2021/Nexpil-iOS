//
//  AddVitaminPopupView.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/08/26.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

protocol AddVitaminPopupViewDelegate: class {
    func didTapButtonAddVitaminPopupView(index: NSInteger)
    func didTapButtonAddVitaminPopupViewClose()
}

class AddVitaminPopupView: UIView {

    weak var delegate:AddVitaminPopupViewDelegate?
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName1: UILabel!
    @IBOutlet weak var lblName2: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgView1: UIView!
    @IBOutlet weak var bgView2: UIView!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
    }

    func intMainView() {
        lblTitle.font = UIFont(name: "Montserrat-Medium", size: 16)!
        lblTitle.textColor = UIColor.init(hex: "333333")
        
        lblName1.font = UIFont(name: "Montserrat-Medium", size: 16)!
        lblName1.textColor = UIColor.init(hex: "333333")
        lblName2.font = UIFont(name: "Montserrat-Medium", size: 16)!
        lblName2.textColor = UIColor.init(hex: "333333")
        
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 10
        bgView1.layer.masksToBounds = true
        bgView1.layer.cornerRadius = 10
        bgView2.layer.masksToBounds = true
        bgView2.layer.cornerRadius = 10
        
    }
    
    @IBAction func taBtnVitamin(_ sender: Any) {
        self.delegate?.didTapButtonAddVitaminPopupView(index: 0)
    }
    
    @IBAction func tapBtnPrescription(_ sender: Any) {
        self.delegate?.didTapButtonAddVitaminPopupView(index: 1)
    }
    
    @IBAction func tapBtnClose(_ sender: Any) {
        self.delegate?.didTapButtonAddVitaminPopupViewClose()
        self.removeFromSuperview()
    }
}
