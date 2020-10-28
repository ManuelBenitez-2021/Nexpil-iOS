//
//  ProfileScheduleDetailModalView.swift
//  Nexpil
//
//  Created by JinYingZhe on 1/24/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

protocol ProfileScheduleDetailModalViewDelegate {
    func popScheduleDetailViewDismissal()
    func popScheduleDetailViewNextClick()
}

class ProfileScheduleDetailModalView: UIView {
    @IBOutlet weak var backUV: UIView!
    @IBOutlet weak var wholeUV: UIView!
    @IBOutlet weak var weatherUV: UIView!
    @IBOutlet weak var closeUB: UIButton!

    @IBOutlet weak var titleUL: UILabel!
    @IBOutlet weak var alarmUL: UILabel!
    @IBOutlet weak var timeUL: UILabel!
    @IBOutlet weak var nextUB: NPButton!
    
    @IBOutlet weak var hourUL: UILabel!
    @IBOutlet weak var minuteUL: UILabel!
    
    @IBOutlet weak var barUV: UIView!
    @IBOutlet weak var stateUIV: UIImageView!
    
    var delegate: ProfileScheduleDetailModalViewDelegate?
    var isEnded: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //  Initialation code
        backUV.setPopItemViewStyle(radius: 30.0, title: .large)
        closeUB.setPopItemViewStyle(radius: 22.5)
        
        weatherUV.setPopItemViewStyle(radius: 15.0)
        
        let height = hourUL.frame.height
        hourUL.layer.cornerRadius = height / 4
        minuteUL.layer.cornerRadius = height / 4
        
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
        self.delegate?.popScheduleDetailViewDismissal()
    }
    
    @objc func wholeTapped(tapGestureRecognizer gesture: UITapGestureRecognizer) {
        self.delegate?.popScheduleDetailViewDismissal()
    }
    
    @IBAction func onClickNextUB(_ sender: Any) {
        if !isEnded {
            alarmUL.text = "Ended Time"
            timeUL.text = "12:00"
            nextUB.titleLabel?.text = "Done"
            barUV.backgroundColor = UIColor.blue
            stateUIV.image = UIImage(named: "icon_complete")
            isEnded = true
        } else {
            self.delegate?.popScheduleDetailViewNextClick()
        }
    }
}
