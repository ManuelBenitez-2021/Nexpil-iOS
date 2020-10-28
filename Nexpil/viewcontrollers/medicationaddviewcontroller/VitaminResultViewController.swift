//
//  VitaminResultViewController.swift
//  Nexpil
//
//  Created by Admin on 5/7/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
class VitaminResultViewController: UIViewController {

    @IBOutlet weak var brandView: UIView!
    @IBOutlet weak var brandName: UITextField!
    @IBOutlet weak var frequencyView: UIView!
    @IBOutlet weak var frequency: UITextField!
    @IBOutlet weak var doseView: UIView!
    @IBOutlet weak var dose: UITextField!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var quantity: UITextField!
    
    
    @IBOutlet weak var backBtn: GradientView!
    @IBOutlet weak var nextBtn: GradientView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        brandView.viewShadow()
        frequencyView.viewShadow()
        doseView.viewShadow()
        quantityView.viewShadow()
        /*
        brandName.titleFormatter = { $0 }
        frequency.titleFormatter = { $0 }
        dose.titleFormatter = { $0 }
        quantity.titleFormatter = { $0 }
        */
        brandName.text = DataUtils.getMedicationName()
        frequency.text = "Once a day"
        dose.text = "1 Tablet"
        quantity.text = DataUtils.getStartTablet()
        
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.gotoNext1))
        nextBtn.addGestureRecognizer(gesture2)
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(self.gotoBack))
        backBtn.addGestureRecognizer(gesture1)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        brandName.text = DataUtils.getMedicationName()
        frequency.text = "Once a day"
        dose.text = "1"
        quantity.text = DataUtils.getStartTablet()
    }
    
    @objc func gotoBack(sender : UITapGestureRecognizer) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.vitaminPageViewController?.pageControl.currentPage = 2
        appDelegate.vitaminPageViewController?.gotoPage()
    }
    
    @objc func gotoNext1(sender : UITapGestureRecognizer) {
        var datas:[MyMedication] = []
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        let currentDate = formatter.string(from: currentDateTime)
        formatter.dateFormat = "HH:mm"
        let currentDate1 = formatter.string(from: currentDateTime)
        let hour = currentDate1.components(separatedBy: ":")[0]
        let min = currentDate1.components(separatedBy: ":")[1]
        var min1 = Int(min)!/5
        min1 = min1 * 5
        DataUtils.setMedicationFrequency(name: frequency.text!)
        DataUtils.setMedicationDose(name: dose.text!)
        let data = MyMedication.init(prescribe: DataUtils.getPrescribed()!, directions: "", dose: DataUtils.getMedicationDose()!, image: "", quantity: DataUtils.getStartTablet()!, type: "", taketime: "", medicationname: DataUtils.getMedicationName()!, filedDate: "", warning: "", frequency: DataUtils.getMedicationFrequency()!, strength: "", pharmacy: "", patientname: "", lefttablet: "", prescription: DataUtils.getPrescription(), createat: currentDate + " \(hour):\(min1)")
        datas.append(data)
        DBManager.shared.insetMedicationHistoryData1(datas: datas)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.vitaminPageViewController?.pageControl.currentPage = 4
        appDelegate.vitaminPageViewController?.gotoPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func gotoContinue(_ sender: Any) {
        //add medicine temp table insert or update
        var datas:[MyMedication] = []
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        let currentDate = formatter.string(from: currentDateTime)
        formatter.dateFormat = "HH:mm"
        let currentDate1 = formatter.string(from: currentDateTime)
        let hour = currentDate1.components(separatedBy: ":")[0]
        let min = currentDate1.components(separatedBy: ":")[1]
        var min1 = Int(min)!/5
        min1 = min1 * 5
        DataUtils.setMedicationFrequency(name: frequency.text!)
        DataUtils.setMedicationDose(name: dose.text!)
        let data = MyMedication.init(prescribe: DataUtils.getPrescribed()!, directions: "", dose: DataUtils.getMedicationDose()!, image: "", quantity: DataUtils.getStartTablet()!, type: "", taketime: "", medicationname: DataUtils.getMedicationName()!, filedDate: "", warning: "", frequency: DataUtils.getMedicationFrequency()!, strength: "", pharmacy: "", patientname: "", lefttablet: "", prescription: DataUtils.getPrescription(), createat: currentDate + " \(hour):\(min1)")
        datas.append(data)
        DBManager.shared.insetMedicationHistoryData1(datas: datas)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.vitaminPageViewController?.pageControl.currentPage = 4
        appDelegate.vitaminPageViewController?.gotoPage()
    }
    @IBAction func gotoBack(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.vitaminPageViewController?.pageControl.currentPage = 2
        appDelegate.vitaminPageViewController?.gotoPage()
    }
    
}
