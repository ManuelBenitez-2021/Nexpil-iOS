//
//  ProfileAddConditionModalView.swift
//  Nexpil
//
//  Created by JinYingZhe on 1/23/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

protocol ProfileAddConditionModalViewDelegate {
    func popAddConditionViewDismissal()
    func popAddConditionViewAddBtnClick()
}

class ProfileAddConditionModalView: UIView {
    @IBOutlet weak var backUV: UIView!
    @IBOutlet weak var addUB: UIButton!
    @IBOutlet weak var wholeUV: UIView!
    @IBOutlet weak var conditionListSCV: UIScrollView!
    @IBOutlet weak var backUB: UIButton!
    @IBOutlet weak var titleUL: UILabel!
    @IBOutlet weak var searchUTF: UITextField!
    
    var delegate: ProfileAddConditionModalViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //  Initialation code
        backUV.setPopItemViewStyle(radius: 30.0, title: .large)
        self.backUB.setPopItemViewStyle(radius: 22.5)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(wholeTapped(tapGestureRecognizer:)))
        wholeUV.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func resetAddConditionList(datas dataList: [String]){
        //
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @objc func wholeTapped(tapGestureRecognizer gesture: UITapGestureRecognizer) {
        self.delegate?.popAddConditionViewDismissal()
    }
    
    @IBAction func onClickAddConditionUB(_ sender: Any) {
        self.delegate?.popAddConditionViewAddBtnClick()
    }
    
    @IBAction func onClickbackUB(_ sender: Any) {
        self.delegate?.popAddConditionViewAddBtnClick()
    }

}
