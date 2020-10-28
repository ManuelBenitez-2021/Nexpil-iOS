//
//  MedicationResultViewController.swift
//  Nexpil
//
//  Created by Admin on 4/17/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire

class MedicationResultViewController: UIViewController {

    
    
    //@IBOutlet weak var fullnameView: UIView!
    //@IBOutlet weak var pharmacyView: UIView!
    @IBOutlet weak var medicationView: UIView!
    @IBOutlet weak var strengthView: UIView!
    //@IBOutlet weak var doctorView: UIView!
    //@IBOutlet weak var quantityView: UIView!
    //@IBOutlet weak var doseView: UIView!
    @IBOutlet weak var frequencyView: UIView!
    
    //@IBOutlet weak var fullname: UITextField!
    //@IBOutlet weak var pharmacy: UITextField!
    @IBOutlet weak var medication: UITextField!
    @IBOutlet weak var strength: UITextField!
    //@IBOutlet weak var doctor: UITextField!
    //@IBOutlet weak var quantity: UITextField!
    //@IBOutlet weak var dose: UITextField!
    @IBOutlet weak var frequency: UITextField!
    @IBOutlet weak var nextbtn: UIButton!
    
    
    @IBOutlet weak var backBtn: GradientView!
    @IBOutlet weak var nextBtn: GradientView!
    @IBOutlet weak var nextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //fullnameView.viewShadow()
        //pharmacyView.viewShadow()
        medicationView.viewShadow()
        strengthView.viewShadow()
        //doctorView.viewShadow()
        //quantityView.viewShadow()
        //doseView.viewShadow()
        frequencyView.viewShadow()
        /*
        pharmacy.titleFormatter = { $0 }
        fullname.titleFormatter = { $0}
        medication.titleFormatter = { $0}
        strength.titleFormatter = { $0}
        doctor.titleFormatter = { $0}
        quantity.titleFormatter = { $0}
        dose.titleFormatter = { $0}
        frequency.titleFormatter = { $0}
        */
        self.hideKeyboardWhenTappedAround()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.gotoNext1))
        nextBtn.addGestureRecognizer(gesture)
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(self.gotoBack))
        backBtn.addGestureRecognizer(gesture1)
        
    }
    
    @objc func gotoBack(sender : UITapGestureRecognizer) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage - 1
        appDelegate.pageViewController?.gotoPage()
    }
    
    @objc func gotoNext1(sender : UITapGestureRecognizer) {
        /*
        if fullname.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input full name", title: "")
            return
        }
        if pharmacy.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input pharmacy", title: "")
            return
        }
        */
        if medication.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input medication", title: "")
            return
        }
        if strength.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input strength", title: "")
            return
        }
        /*
        if doctor.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input doctor", title: "")
            return
        }
 
        if quantity.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input quantity", title: "")
            return
        }
        if dose.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input dose", title: "")
            return
        }
        */
        if frequency.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input frequency", title: "")
            return
        }
        //if DataUtils.getSkipButton() == false
        //{
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
            let data = MyMedication.init(prescribe: "", directions: frequency.text!, dose: "", image: "", quantity: DataUtils.getStartTablet()!, type: "", taketime: "", medicationname: medication.text!, filedDate: DataUtils.getMedicationDate()!, warning: "", frequency: "", strength: strength.text!, pharmacy: "", patientname: "", lefttablet: DataUtils.getLeftTablet()!, prescription: DataUtils.getPrescription(), createat: currentDate + " \(hour):\(min1)")
            datas.append(data)
            DBManager.shared.insetMedicationHistoryData1(datas: datas)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage + 1
            appDelegate.pageViewController?.gotoPage()
        //}
        //else
        //{
        //    saveMedication()
        //}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /*
        fullname.text = DataUtils.getPatientFullName()
        if DataUtils.getPatientFullName() == ""
        {
            //let preference = PreferenceHelper()
            //fullname.text =  preference.getFirstName()! + " " + preference.getLastName()!
        }
        */
        //pharmacy.text = DataUtils.getPharmacyName()
        medication.text = DataUtils.getMedicationName()
        strength.text = DataUtils.getMedicationStrength()
        //doctor.text = DataUtils.getPrescribed()
        //quantity.text = DataUtils.getStartTablet()
        //dose.text = DataUtils.getMedicationDose()
        frequency.text = DataUtils.getMedicationFrequency()
        
        
        
        
        if DataUtils.getSkipButton()
        {
            //nextbtn.setTitle("Save", for:.normal)
            nextLabel.text = "Save"
            //fullname.text = PreferenceHelper().getFirstName()! + " " + PreferenceHelper().getLastName()!
        }
        
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                
                
                self.view.frame.origin.y -= 50
                
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 50
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    func saveMedication()
    {
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
        
        let number = NumberFormatter()
        number.numberStyle = .decimal
        number.maximumIntegerDigits = 2
        number.minimumIntegerDigits = 2
        
        let min2 = number.string(from:NSNumber.init(value: min1)) ?? "00"
        
        let params = [
            "direction" : frequency.text!,
            "dose" : "",
            "quantity" : DataUtils.getStartTablet()!,
            "prescribe" : DataUtils.getPrescribed()!,
            "userid" : PreferenceHelper().getId(),
            "taketime" : DataUtils.getMedicationWhen()!,
            "patientname" : "",
            "pharmacy" : "",
            "medicationname" : medication.text!,
            "strength" : strength.text!,
            "filed_date" : DataUtils.getMedicationDate()!,
            "warnings" : "",
            "frequency" : "",
            "lefttablet" : DataUtils.getLeftTablet()!,
            "prescription" : DataUtils.getPrescription(),
            "createat" : currentDate + " \(hour):\(min2)",
            "choice" : "0"
            ] as [String : Any]
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        Alamofire.request(DataUtils.APIURL + DataUtils.MYDRUG_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                
                debugPrint(response);
                
                if let data = response.result.value {
                    print("JSON: \(data)")
                    let json : [String:Any] = data as! [String : Any]
                    //let statusMsg: String = json["status_msg"] as! String
                    //self.showResultMessage(statusMsg)
                    //self.showGraph(json)
                    let result = json["status"] as? String
                    if result == "true"
                    {
                        /*
                        let message = json["message"] as! String
                        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            
                            appDelegate.pageViewController?.closePageViewController()
                        }
                        alert.addAction(OKAction)
                        self.present(alert, animated: true, completion: nil)
                        */
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.pageViewController?.closePageViewController()
                    }
                    else
                    {
                        let message = json["message"] as! String
                        DataUtils.messageShow(view: self, message: message, title: "")
                    }
                }
            })
    }
    
    @IBAction func gotoBack(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage - 1
        appDelegate.pageViewController?.gotoPage()
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
}
