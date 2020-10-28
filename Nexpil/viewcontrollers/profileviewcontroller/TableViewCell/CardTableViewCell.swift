//
//  CardTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/08/20.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var lblTitleMemberName: UILabel!
    @IBOutlet weak var lblTitleMemberId: UILabel!
    @IBOutlet weak var lblTitleGroupName: UILabel!
    @IBOutlet weak var lblTitleBin: UILabel!
    @IBOutlet weak var lblTitleBenifitPlan: UILabel!
    @IBOutlet weak var lblTitleEffectiveDate: UILabel!
    @IBOutlet weak var lblTitlePlan: UILabel!
    @IBOutlet weak var lblTitleOfficeVisit: UILabel!
    @IBOutlet weak var lblTitleSpecialistCopay: UILabel!
    @IBOutlet weak var lblTitleEmergency: UILabel!
    @IBOutlet weak var lblTitleDeductible: UILabel!
    
    @IBOutlet weak var lblValueMemberName: UILabel!
    @IBOutlet weak var lblValueMemberId: UILabel!
    @IBOutlet weak var lblValueGroupName: UILabel!
    @IBOutlet weak var lblValueBin: UILabel!
    @IBOutlet weak var lblValueBenifitPlan: UILabel!
    @IBOutlet weak var lblValueEffectiveDate: UILabel!
    @IBOutlet weak var lblValuePlan: UILabel!
    @IBOutlet weak var lblValueOfficeVisit: UILabel!
    @IBOutlet weak var lblValueSpecialistCopay: UILabel!
    @IBOutlet weak var lblValueEmergency: UILabel!
    @IBOutlet weak var lblValueDeductible: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.initMainView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initMainView() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        bgView.backgroundColor = UIColor.white
        
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 10
        
        lblTitleMemberName.font             = UIFont(name: "Montserrat", size: 12)!
        lblTitleMemberId.font               = UIFont(name: "Montserrat", size: 12)!
        lblTitleGroupName.font              = UIFont(name: "Montserrat", size: 12)!
        lblTitleBin.font                    = UIFont(name: "Montserrat", size: 12)!
        lblTitleBenifitPlan.font            = UIFont(name: "Montserrat", size: 12)!
        lblTitleEffectiveDate.font          = UIFont(name: "Montserrat", size: 12)!
        lblTitlePlan.font                   = UIFont(name: "Montserrat", size: 12)!
        lblTitleOfficeVisit.font            = UIFont(name: "Montserrat", size: 12)!
        lblTitleSpecialistCopay.font        = UIFont(name: "Montserrat", size: 12)!
        lblTitleEmergency.font              = UIFont(name: "Montserrat", size: 12)!
        lblTitleDeductible.font             = UIFont(name: "Montserrat", size: 12)!
        
        lblValueMemberName.font             = UIFont(name: "Montserrat", size: 17)!
        lblValueMemberId.font               = UIFont(name: "Montserrat", size: 17)!
        lblValueGroupName.font              = UIFont(name: "Montserrat", size: 17)!
        lblValueBin.font                    = UIFont(name: "Montserrat", size: 17)!
        lblValueBenifitPlan.font            = UIFont(name: "Montserrat", size: 17)!
        lblValueEffectiveDate.font          = UIFont(name: "Montserrat", size: 17)!
        lblValuePlan.font                   = UIFont(name: "Montserrat", size: 17)!
        lblValueOfficeVisit.font            = UIFont(name: "Montserrat", size: 17)!
        lblValueSpecialistCopay.font        = UIFont(name: "Montserrat", size: 17)!
        lblValueEmergency.font              = UIFont(name: "Montserrat", size: 17)!
        lblValueDeductible.font             = UIFont(name: "Montserrat", size: 17)!
        
        lblTitleMemberName.textColor        = UIColor.init(hex: "9A9A9A")
        lblTitleMemberId.textColor          = UIColor.init(hex: "9A9A9A")
        lblTitleGroupName.textColor         = UIColor.init(hex: "9A9A9A")
        lblTitleBin.textColor               = UIColor.init(hex: "9A9A9A")
        lblTitleBenifitPlan.textColor       = UIColor.init(hex: "9A9A9A")
        lblTitleEffectiveDate.textColor     = UIColor.init(hex: "9A9A9A")
        lblTitlePlan.textColor              = UIColor.init(hex: "9A9A9A")
        lblTitleOfficeVisit.textColor       = UIColor.init(hex: "9A9A9A")
        lblTitleSpecialistCopay.textColor   = UIColor.init(hex: "9A9A9A")
        lblTitleEmergency.textColor         = UIColor.init(hex: "9A9A9A")
        lblTitleDeductible.textColor        = UIColor.init(hex: "9A9A9A")
        
        lblValueMemberName.textColor        = UIColor.init(hex: "333333")
        lblValueMemberId.textColor          = UIColor.init(hex: "333333")
        lblValueGroupName.textColor         = UIColor.init(hex: "333333")
        lblValueBin.textColor               = UIColor.init(hex: "333333")
        lblValueBenifitPlan.textColor       = UIColor.init(hex: "333333")
        lblValueEffectiveDate.textColor     = UIColor.init(hex: "333333")
        lblValuePlan.textColor              = UIColor.init(hex: "333333")
        lblValueOfficeVisit.textColor       = UIColor.init(hex: "333333")
        lblValueSpecialistCopay.textColor   = UIColor.init(hex: "333333")
        lblValueEmergency.textColor         = UIColor.init(hex: "333333")
        lblValueDeductible.textColor        = UIColor.init(hex: "333333")
    }
    
    func setInfo(dic: NSDictionary) {
        var strMemberName = ""
        var strMemberId = ""
        var strBin = ""
        var strBenifitPlan = ""
        var strEffectiveDate = ""
        var strPlan = ""
        var strOfficeVisit = ""
        var strSpecialistcopay = ""
        var strEmergency = ""
        var strDeductible = ""
        
        if dic["memberName"] != nil {
            strMemberName = dic["memberName"] as! String
        }
        if dic["memberId"] != nil {
            strMemberId = dic["memberId"] as! String
        }
        if dic["bin"] != nil {
            strBin = dic["bin"] as! String
        }
        if dic["benifitPlan"] != nil {
            strBenifitPlan = dic["benifitPlan"] as! String
        }
        if dic["effectiveDate"] != nil {
            strEffectiveDate = dic["effectiveDate"] as! String
        }
        if dic["plan"] != nil {
            strPlan = dic["plan"] as! String
        }
        if dic["officeVisit"] != nil {
            strOfficeVisit = dic["officeVisit"] as! String
        }
        if dic["specialistCopay"] != nil {
            strSpecialistcopay = dic["specialistCopay"] as! String
        }
        if dic["emergency"] != nil {
            strEmergency = dic["emergency"] as! String
        }
        if dic["deductible"] != nil{
            strDeductible = dic["deductible"] as! String
        }
        
        lblValueMemberName.text = strMemberName
        lblValueMemberId.text = strMemberId
        lblValueBin.text = strBin
        lblValueBenifitPlan.text = strBenifitPlan
        lblValueEffectiveDate.text = strEffectiveDate
        lblValuePlan.text = strPlan
        lblValueOfficeVisit.text = strOfficeVisit
        lblValueSpecialistCopay.text = strSpecialistcopay
        lblValueEmergency.text = strEmergency
        lblValueDeductible.text = strDeductible
        
    }
    
}
