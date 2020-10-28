//
//  LoginViewController.swift
//  Nexpil
//
//  Created by Admin on 4/6/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import Alamofire
import SkyFloatingLabelTextField

class LoginViewController: UIViewController {

    @IBOutlet weak var emailview: UIView!
    @IBOutlet weak var passwordview: UIView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var loginBtn: GradientView!
    @IBOutlet weak var backBtn: GradientView!
    
    var passwordSecure = true
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailview.viewShadow()
        
        passwordview.viewShadow()
        
        self.hideKeyboardWhenTappedAround()
        
        /*
        password.placeholderFont = UIFont(name: "FontAwesome", size: 10)
        
        email.placeholderFont = UIFont(name: "FontAwesome", size: 10)
        
        password.titleFormatter = { $0 }
        email.titleFormatter = { $0 }
        */
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.gotoSignIn))
        loginBtn.addGestureRecognizer(gesture)
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(self.gotoBack))
        backBtn.addGestureRecognizer(gesture1)
        
    }

    @objc func gotoSignIn(sender : UITapGestureRecognizer) {
        if email.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input email", title: "")
            return
        }
        if DataUtils.isValidEmailAddress(emailAddressString: email.text!) == false
        {
            DataUtils.messageShow(view: self, message: "Please input valid email", title: "")
            return
        }
        if password.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input password", title: "")
            return
        }
        if DataUtils.isConnectedToNetwork() == false
        {
            DataUtils.messageShow(view: self, message: "Please check your internet connection.", title: "")
            return
        }
        loginUser()
    }
    
    @objc func gotoBack(sender : UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let preferenceHelper = PreferenceHelper()
        let emailtxt = preferenceHelper.getEmail() ?? ""
        if emailtxt != ""
        {
            email.text = emailtxt
            let defaults = UserDefaults.standard
            password.text = defaults.string(forKey: "password")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showPassword(_ sender: Any) {
        passwordSecure = !passwordSecure        
        password.isSecureTextEntry = passwordSecure
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func userSignin(_ sender: Any) {
        if email.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input email", title: "")
            return
        }
        if DataUtils.isValidEmailAddress(emailAddressString: email.text!) == false
        {
            DataUtils.messageShow(view: self, message: "Please input valid email", title: "")
            return
        }
        if password.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input password", title: "")
            return
        }
        if DataUtils.isConnectedToNetwork() == false
        {
            DataUtils.messageShow(view: self, message: "Please check your internet connection.", title: "")
            return
        }
        loginUser()
    }
    func loginUser()
    {
        let params = [
            "email" : email.text!,
            "password" : password.text!,
            "choice" : "1"
            
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
                        DataUtils.setSkipButton(time: true)
                        let defaults = UserDefaults.standard
                        defaults.set(self.password.text!, forKey: "password")
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
        //viewController.tabBar.roundCorners([.topLeft, .topRight], radius: 10)
        viewController.tabBar.layer.cornerRadius = 10
        viewController.tabBar.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner];
        viewController.tabBar.layer.borderWidth = 1
        //viewController.tabBar.layer.borderColor = UIColor.init(hex: "707070").cgColor
        viewController.tabBar.layer.borderColor = UIColor(red: (112/255.0), green: (112/255.0), blue: (112/255.0), alpha: 0.2).cgColor
        viewController.tabBar.clipsToBounds = true
        present(viewController, animated: false, completion: nil)
    }
    
    func setupTimeRange()
    {
        DataUtils.setTimeRange(index: 0, time: "1:00-11:59")
        DataUtils.setTimeRange(index: 1, time: "12:00-16:59")
        DataUtils.setTimeRange(index: 2, time: "17:00-19:59")
        DataUtils.setTimeRange(index: 3, time: "20:00-23:59")
    }
}

