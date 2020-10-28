//
//  SummaryScreenViewController.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/5/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class SummaryScreenViewController: InformationCardEditViewController {
    
    var prescription: NPPrescription?
    
    @IBOutlet weak var fullNameCard: InformationCard!
    @IBOutlet weak var pharmacyCard: InformationCard!
    @IBOutlet weak var medicationCard: InformationCard!
    @IBOutlet weak var strengthCard: InformationCard!
    @IBOutlet weak var doctorCard: InformationCard!
    @IBOutlet weak var quantityCard: InformationCard!
    @IBOutlet weak var directionsCard: InformationCard!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let logoImage = UIImage(named: "Progress Bar4")
        self.navigationItem.titleView = UIImageView(image: logoImage)
        /*
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: navigationController, action: #selector(UINavigationController.popViewController(animated:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: closeImage, style: .plain, target: navigationController, action: #selector(UINavigationController.popViewController(animated:)))
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        */
        
        /*
        fullNameCard.valueText = prescription!.patientName ?? ""
        pharmacyCard.valueText = prescription!.pharmacy?.name ?? ""
        medicationCard.valueText = prescription!.drug.name
        strengthCard.valueText = prescription!.drug.dosage
        doctorCard.valueText = prescription!.doctorName ?? ""
        quantityCard.valueText = prescription!.drugQuantity != nil ? String(prescription!.drugQuantity!) : ""
        directionsCard.valueText = directions
        */
 
        /*
        let backImage = UIImage(named: "Back")
        let logoImage = UIImage(named: "nexpil logo - alternate")
        self.navigationItem.titleView = UIImageView(image: logoImage)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: navigationController, action: #selector(UINavigationController.popViewController(animated:)))
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.medicationCard.valueText = DataUtils.getMedicationName()!
        self.strengthCard.valueText = DataUtils.getMedicationStrength()!
        self.directionsCard.valueText = DataUtils.getMedicationFrequency()!
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillDisappear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? InformationCardEditViewController {
            vc.summaryPage = self
            super.prepare(for: segue, sender: sender)
        }
        else if let vc = segue.destination as? InformationCardEditDosageViewController {
            vc.summaryPage = self
            super.prepare(for: segue, sender: sender)
        }
    }
    
    @IBAction func gotoMedicationAddResult(_ sender: Any) {
        if self.medicationCard.valueText.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input medication name", title: "")
            return
        }
        if self.strengthCard.valueText.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input medication strength", title: "")
            return
        }
        if self.directionsCard.valueText.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input medication direction", title: "")
            return
        }
        var datas:[MyMedication] = []
        /*
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        let currentDate = formatter.string(from: currentDateTime)
        formatter.dateFormat = "HH:mm"
        let currentDate1 = formatter.string(from: currentDateTime)
        */
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        var currentDate1 = ""
        formatter.timeZone = TimeZone.current
        let locale = NSLocale.current
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = formatter.string(from: currentDateTime)
        let formatter1 : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
        if formatter1.contains("a") {
            
            //phone is set to 12 hours
            formatter.dateFormat = "h:mm a"
            let time1 = formatter.string(from: currentDateTime)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            let date = formatter.date(from: time1)
            formatter.dateFormat = "HH:mm"
            currentDate1 = formatter.string(from: date!)
        } else {
            //phone is set to 24 hours
            formatter.dateFormat = "HH:mm"
            currentDate1 = formatter.string(from: currentDateTime)
        }
 
        let hour = currentDate1.components(separatedBy: ":")[0]
        let min = currentDate1.components(separatedBy: ":")[1]
        var min1 = Int(min)!/5
        min1 = min1 * 5
        let data = MyMedication.init(prescribe: "", directions: directionsCard.valueText, dose: "", image: "", quantity: "", type: "", taketime: "", medicationname: medicationCard.valueText, filedDate: "", warning: "", frequency: "", strength: strengthCard.valueText, pharmacy: "", patientname: "", lefttablet: "", prescription: DataUtils.getPrescription(), createat: currentDate + " \(hour):\(min1)")
        datas.append(data)
        DBManager.shared.insetMedicationHistoryData1(datas: datas)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let medicationController = storyBoard.instantiateViewController(withIdentifier: "AddMedicationListViewController") as! AddMedicationListViewController
        self.navigationController?.pushViewController(medicationController, animated: true)
    }
}
