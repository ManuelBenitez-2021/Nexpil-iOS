//
//  LoginScreenViewController.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/23/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire

class LoginScreenViewController: UIViewController {

    @IBOutlet weak var addressField: InformationCardEditable!
    @IBOutlet weak var passwordField: InformationCardEditable1!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backImage = UIImage(named: "Back")
        let logoImage = UIImage(named: "nexpil logo - alternate")
        self.navigationItem.titleView = UIImageView(image: logoImage)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(self.closeWindow))
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    @objc func closeWindow()
    {
        dismiss(animated: false, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        if DataUtils.getEmail()?.isEmpty == false
        {
            addressField.textView.text = DataUtils.getEmail()
        }
        if DataUtils.getPassword()?.isEmpty == false
        {
            passwordField.textView.text = DataUtils.getPassword()
        }
    }
    
    @IBAction func userSignin(_ sender: Any) {
  
        if addressField.textView.text!.isEmpty {
            DataUtils.messageShow(view: self, message: "Please input email", title: "")
            return
        }

        if DataUtils.isValidEmailAddress(emailAddressString: addressField.textView.text!) == false {
            DataUtils.messageShow(view: self, message: "Please input valid email", title: "")
            return
        }

        if passwordField.textView.text!.isEmpty {
            DataUtils.messageShow(view: self, message: "Please input password", title: "")
            return
        }

        if DataUtils.isConnectedToNetwork() == false {
            DataUtils.messageShow(view: self, message: "Please check your internet connection.", title: "")
            return
        }
        loginUser()
    }
    func loginUser()
    {
        let params = [
            "email" : addressField.textView.text!,
            "password" : passwordField.textView.text!,
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
                    if result == "true" {
                        DataUtils.setSkipButton(time: true)
                        let defaults = UserDefaults.standard
                        defaults.set(self.passwordField.textView.text!, forKey: "password")
                        let patientInfo = PatientInfo.init(json: json["userinfo"] as! [String:Any])
                        patientInfo.saveUserInfo()
                        self.gotoMainScreen()
                        
                    } else {
                        let message = json["message"] as! String
                        DataUtils.messageShow(view: self, message: message, title: "")
                    }
                }
            })
    }
    
    func gotoMainScreen() {
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
    
    func setupTimeRange() {
        DataUtils.setTimeRange(index: 0, time: "1:00-11:59")
        DataUtils.setTimeRange(index: 1, time: "12:00-16:59")
        DataUtils.setTimeRange(index: 2, time: "17:00-19:59")
        DataUtils.setTimeRange(index: 3, time: "20:00-23:59")
    }
}
