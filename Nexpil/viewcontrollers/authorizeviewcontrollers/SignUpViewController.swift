//
//  SignUpViewController.swift
//  Nexpil
//
//  Created by Admin on 4/8/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import SkyFloatingLabelTextField

import Alamofire

class SignUpViewController: InformationCardEditViewController {

    @IBOutlet weak var firstnameView: UIView!
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastnameView: UIView!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var emailview: UIView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var passwordview: UIView!
    //@IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmpasswordview: UIView!
    @IBOutlet weak var confirmpassword: UITextField!
    var currentTextField = 0
    var passwordShow = true
    var confirmpasswordShow = true
    
    @IBOutlet weak var backBtn: GradientView!
    
    @IBOutlet weak var fullName: InformationCard!
    @IBOutlet weak var emailAddress: InformationCard!
    @IBOutlet weak var password: InformationCard!
    
    
    @IBOutlet weak var signupBtn: GradientView!
    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        
        let logoImage = UIImage(named: "nexpil logo - alternate")
        self.navigationItem.titleView = UIImageView(image: logoImage)
        self.navigationItem.rightBarButtonItem = nil
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fullName.value!.text = DataUtils.getPatientFullName()
        emailAddress.value!.text = DataUtils.getEmail()
        password.value!.text = DataUtils.getPassword()
        if fullName.value.text == ""
        {
            fullName.value.text = ""
            fullName.value.textColor = UIColor.init(hex: "333333", alpha: 0.5)
            fullName.identifier.isHidden = true
        }
        else {
            fullName.value.textColor = UIColor.init(hex: "333333")
            fullName.identifier.isHidden = false
        }
        if emailAddress.value.text == ""
        {
            emailAddress.value.text = ""
            emailAddress.value.textColor = UIColor.init(hex: "333333", alpha: 0.5)
            emailAddress.identifier.isHidden = true
        }
        else {
            emailAddress.value.textColor = UIColor.init(hex: "333333")
            emailAddress.identifier.isHidden = false
        }
        if password.value.text == ""
        {
            password.value.text = ""
            password.value.textColor = UIColor.init(hex: "333333", alpha: 0.5)
            password.identifier.isHidden = true
        }
        else {
            password.value.textColor = UIColor.init(hex: "333333")
            password.identifier.isHidden = false
        }
        
    }
    
    @IBAction func userSignup(_ sender: Any) {
        if DataUtils.getPatientFullName() == ""
        {
            DataUtils.messageShow(view: self, message: "Please input Full Name", title: "")
            return
        }
        if DataUtils.getEmail() == ""
        {
            DataUtils.messageShow(view: self, message: "Please input email address", title: "")
            return
        }
        if DataUtils.isValidEmailAddress(emailAddressString: DataUtils.getEmail()!) == false
        {
            DataUtils.messageShow(view: self, message: "Please input valid email", title: "")
            return
        }
        if DataUtils.getPassword() == ""
        {
            DataUtils.messageShow(view: self, message: "Please input password", title: "")
            return
        }
        gotoSignupAndMedication()
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
    func convertToDictionary(datas:[MyMedication]) -> [[String : Any]] {
        var dics = [[String : Any]]()
        for data in datas
        {
            let dic: [String: Any] = ["direction":data.directions, "dose":data.dose, "quantity":data.quantity, "prescribe":data.prescribe, "taketime":"", "patientname":data.patientname, "pharmacy":data.pharmacy,"medicationname":data.medicationname,"strength":data.strength,"filed_date":data.filedDate,"warnings":data.warnings,"frequency":data.frequency,"lefttablet":data.lefttablet,"prescription":data.prescription,"createat":data.createat]
            dics.append(dic)
        }
        return dics
    }
    
    func gotoSignupAndMedication()
    {
        
        do {
            let datas:[MyMedication] = DBManager.shared.getMedications()
            let dicArray = convertToDictionary(datas:datas)
            let jsonData = try JSONSerialization.data(withJSONObject: dicArray, options: .prettyPrinted)
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                let params = [
                    "datas" : JSONString,                    
                    "email" : emailAddress.value.text!,
                    "password" : password.value.text!,
                    "first_name" : fullName.value.text!,
                    "last_name" : "",
                    "usertype" : "patient",
                    "choice" : "4"
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
                                let _ = DBManager.shared.deleteMedicationDrug2()
                                let message = json["message"] as! String
                                let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
                                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                    //let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    DataUtils.setSkipButton(time: true)
                                    
                                    let defaults = UserDefaults.standard
                                    defaults.set(self.password.valueText, forKey: "password")
                                    let patientInfo = PatientInfo.init(json: json["userinfo"] as! [String:Any])
                                    patientInfo.saveUserInfo()
                                    self.gotoMainScreen()
                                }
                                alert.addAction(OKAction)
                                self.present(alert, animated: true, completion: nil)
                            }
                            else
                            {
                                let message = json["message"] as! String
                                DataUtils.messageShow(view: self, message: message, title: "")
                            }
                        }
                    })
            }
        }
        catch {
            
        }
        
    }
    
    func gotoSignup()
    {
        let params = [
            "email" : email.text!,
            "password" : password.valueText,
            "first_name" : fullName.valueText,
            "last_name" : "",
            "usertype" : DataUtils.getPatient()!,
            "choice" : "0"
            
            ] as [String : Any]
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        Alamofire.request(DataUtils.APIURL + DataUtils.AUTH_URL, method: .post, parameters: params)
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
                        let defaults = UserDefaults.standard
                        defaults.set(self.password.valueText, forKey: "password")
                        let patientInfo = PatientInfo.init(json: json["userinfo"] as! [String:Any])
                        patientInfo.saveUserInfo()
                        self.gotoMainScreen()
                    }
                    else
                    {
                        let message = json["message"] as! String
                        DataUtils.messageShow(view: self, message: message, title: "")
                    }
                }
            })
    }
    
    
    func gotoMainScreen()
    {
        setupTimeRange()
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainviewcontroller") as! UITabBarController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = viewController
        present(viewController, animated: false, completion: nil)
    }
    func setupTimeRange() {
        DataUtils.setTimeRange(index: 0, time: "1:00-11:59")
        DataUtils.setTimeRange(index: 1, time: "12:00-16:59")
        DataUtils.setTimeRange(index: 2, time: "17:00-19:59")
        DataUtils.setTimeRange(index: 3, time: "20:00-23:59")
    }
}
