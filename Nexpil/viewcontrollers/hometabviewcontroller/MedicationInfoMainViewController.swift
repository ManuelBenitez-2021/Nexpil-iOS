//
//  MedicationInfoMainViewController.swift
//  Nexpil
//
//  Created by Yun Lai on 2018/12/5.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class MedicationInfoMainViewController: UIViewController {

    var myMedication:MedicationHistory?
    var mMedicInfo: [String : String] = [String : String]()
    var m_titleArray: [String] = []
    var m_drugLBInfoArray: [DrugInfoLabelCard] = []
    
    @IBOutlet weak var m_cnstTakenHeight: NSLayoutConstraint!
    @IBOutlet weak var m_lbTakenMedication: UILabel!
    @IBOutlet weak var m_lbTakenMedicationContent: UILabel!
    
    @IBOutlet weak var m_lbActive: UILabel!
    @IBOutlet weak var m_tvActive: UITextView!
    
    @IBOutlet weak var m_vstkDrugInfo: UIStackView!
    @IBOutlet weak var m_vwDrugInfo: UIView!
    
    @IBOutlet weak var m_drugLBInfo1: DrugInfoLabelCard!
    @IBOutlet weak var m_drugLBInfo2: DrugInfoLabelCard!
    @IBOutlet weak var m_drugLBInfo3: DrugInfoLabelCard!
    @IBOutlet weak var m_drugLBInfo4: DrugInfoLabelCard!
    @IBOutlet weak var m_drugLBInfo5: DrugInfoLabelCard!
    @IBOutlet weak var m_drugLBInfo6: DrugInfoLabelCard!
    @IBOutlet weak var m_drugLBInfo7: DrugInfoLabelCard!
    
    @IBOutlet weak var m_lbInfo1: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (myMedication?.eatenTime == "") {
            m_cnstTakenHeight.constant = 0
        } else {
            m_cnstTakenHeight.constant = 80
        }
        
        m_lbTakenMedication.text = myMedication?.medicationName
        m_lbTakenMedicationContent.text = myMedication?.eatText
        
        m_lbInfo1.text = String.init(format: "%@ - 5mg", myMedication?.medicationName as! String)
        
        initMedicInfo()
        switchDetailInfo(bDetail: false)
        
        
        
    }
    
    func switchDetailInfo(bDetail: Bool) {
        
        m_vstkDrugInfo.isHidden = bDetail
        m_vwDrugInfo.isHidden = !bDetail
    }
    
    func initMedicInfo() {
        
        m_drugLBInfoArray.append(m_drugLBInfo1)
        m_drugLBInfoArray.append(m_drugLBInfo2)
        m_drugLBInfoArray.append(m_drugLBInfo2)
        m_drugLBInfoArray.append(m_drugLBInfo4)
        m_drugLBInfoArray.append(m_drugLBInfo5)
        m_drugLBInfoArray.append(m_drugLBInfo6)
        m_drugLBInfoArray.append(m_drugLBInfo7)
        
        m_titleArray.append("Overview")
        m_titleArray.append("Dosage")
        m_titleArray.append("Side Effects")
        m_titleArray.append("Interactions")
        m_titleArray.append("Images")
        m_titleArray.append("Warnings")
        m_titleArray.append("Personal Info")
        m_titleArray.append("FAQ's")
        
        for strTitle in m_titleArray {
            mMedicInfo[strTitle] = ""
        }
        
        getMedicationInfo()
    }
    
    func getMedicationInfo()
    {
        let path = "https://api.fda.gov/drug/label.json?search=\(myMedication!.medicationName)"
        let url = URL(string: path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!) { [unowned self] (data, response, error) in
            
            guard error == nil else { return }
            guard data != nil else { return }
            
            
            let decoder = JSONDecoder()
            let results = try! decoder.decode(Results.self, from: data!)
            
            if let result = results.results {
                
                DispatchQueue.main.async {
                    //self.textView.text = result[0].indications_and_usage?.joined(separator: "\n")
                    var what = result[0].description?[0] ?? ""
                    if what == ""
                    {
                        what = result[0].purpose?[0] ?? ""
                    }
                    
                    self.mMedicInfo[self.m_titleArray[0] as! String] = what
                    self.mMedicInfo[self.m_titleArray[1] as! String] = result[0].dosage_and_administration?[0] ?? ""
                    self.mMedicInfo[self.m_titleArray[2] as! String] = result[0].indications_and_usage?[0] ?? ""
                 
                    self.m_lbActive.text = self.m_titleArray[0]
                    self.m_tvActive.text = what
                }
            }
            
        }
        task.resume()
    }
    
    func tapDrugInfo(sender: UITapGestureRecognizer) {
        
        var vwSender: DrugInfoCard = sender.view as! DrugInfoCard
    
        let strTitle = vwSender.card_title
        if mMedicInfo[strTitle as! String] == "" {
            return
        }
        let strPrevTitle = m_lbActive.text as! String
        m_lbActive.text = strTitle
        m_tvActive.text = mMedicInfo[strTitle as! String]
        
        for vwDrugLBInfo in m_drugLBInfoArray {
            if vwDrugLBInfo.card_title == strTitle {
                vwDrugLBInfo.card_title = strPrevTitle
            }
        }
        
        switchDetailInfo(bDetail: true)
        m_tvActive.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    func tapDrugLabelInfo(sender: UITapGestureRecognizer) {
        
        var vwSender: DrugInfoLabelCard = sender.view as! DrugInfoLabelCard
        let strTitle = vwSender.card_title
        if mMedicInfo[strTitle as! String] == "" {
            return
        }
        let strPrevTitle = m_lbActive.text as! String
        m_lbActive.text = strTitle
        m_tvActive.text = mMedicInfo[strTitle as! String]
        vwSender.card_title = strPrevTitle as! String
        
        m_tvActive.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    //Actions
    
    @IBAction func tapFABClose(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: false)
    }
    
    
    @IBAction func tapCardOverview(_ sender: UITapGestureRecognizer) {
        tapDrugInfo(sender: sender)
    }
    
    @IBAction func tapCardDosage(_ sender: UITapGestureRecognizer) {
        tapDrugInfo(sender: sender)
    }
    
    @IBAction func tapCardSideEffect(_ sender: UITapGestureRecognizer) {
        tapDrugInfo(sender: sender)
    }
    
    @IBAction func tapCardInteraction(_ sender: UITapGestureRecognizer) {
        tapDrugInfo(sender: sender)
    }
    
    @IBAction func tapCardImage(_ sender: UITapGestureRecognizer) {
        tapDrugInfo(sender: sender)
    }
    
    @IBAction func tapCardWarning(_ sender: UITapGestureRecognizer) {
        tapDrugInfo(sender: sender)
    }
    
    @IBAction func tapCardPersonalInfo(_ sender: UITapGestureRecognizer) {
        tapDrugInfo(sender: sender)
    }
    
    @IBAction func tapCardFAQ(_ sender: UITapGestureRecognizer) {
        tapDrugInfo(sender: sender)
    }
    
    
    @IBAction func tapLBCard1(_ sender: UITapGestureRecognizer) {
        tapDrugLabelInfo(sender: sender)
    }
    
    @IBAction func tapLBCard2(_ sender: UITapGestureRecognizer) {
        tapDrugLabelInfo(sender: sender)
    }
    
    @IBAction func tapLBCard3(_ sender: UITapGestureRecognizer) {
        tapDrugLabelInfo(sender: sender)
    }
    
    @IBAction func tapLBCard4(_ sender: UITapGestureRecognizer) {
        tapDrugLabelInfo(sender: sender)
    }
    
    @IBAction func tapLBCard5(_ sender: UITapGestureRecognizer) {
        tapDrugLabelInfo(sender: sender)
    }
    
    @IBAction func tapLBCard6(_ sender: UITapGestureRecognizer) {
        tapDrugLabelInfo(sender: sender)
    }
    
    @IBAction func tapLBCard7(_ sender: UITapGestureRecognizer) {
        tapDrugLabelInfo(sender: sender)
    }
    
    
    
    
}
