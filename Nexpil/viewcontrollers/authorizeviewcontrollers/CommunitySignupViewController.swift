//
//  CommunitySignupViewController.swift
//  Nexpil
//
//  Created by Admin on 6/15/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire

class CommunitySignupViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var firstnameView: UIView!
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastnameView: UIView!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var emailview: UIView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var passwordview: UIView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmpasswordview: UIView!
    @IBOutlet weak var confirmpassword: UITextField!
    
    @IBOutlet weak var backBtn: GradientView!
    
    @IBOutlet weak var signupBtn: GradientView!
    
    var currentTextField = 0
    var passwordShow = true
    var confirmpasswordShow = true
    
    var userImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        firstnameView.viewShadow()
        lastnameView.viewShadow()
        emailview.viewShadow()
        passwordview.viewShadow()
        confirmpasswordview.viewShadow()
        
        self.hideKeyboardWhenTappedAround()
        
        firstname.autocorrectionType = .no
        lastname.autocorrectionType = .no
        email.autocorrectionType = .no
        password.autocorrectionType = .no
        confirmpassword.autocorrectionType = .no
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.gotoSignUp))
        signupBtn.addGestureRecognizer(gesture)
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(self.gotoBack))
        backBtn.addGestureRecognizer(gesture1)
        
        firstname.delegate = self
        lastname.delegate = self
        email.delegate = self
        password.delegate = self
        confirmpassword.delegate = self
        
    }

    @objc func gotoBack(sender : UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /*
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        */
    }  
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstname
        {
            currentTextField = 1
            lastname.becomeFirstResponder()
        }
        else if textField == lastname
        {
            currentTextField = 2
            email.becomeFirstResponder()
        }
        else if textField == email
        {
            currentTextField = 3
            password.becomeFirstResponder()
            
        }
        else if textField == password
        {
            confirmpassword.becomeFirstResponder()
        }
        else
        {
            confirmpassword.resignFirstResponder()
        }
        return true
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                
                
                self.view.frame.origin.y -= 100
                
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 100
            }
        }
    }
    
    @IBAction func passwordShow(_ sender: Any) {
        passwordShow = !passwordShow
        password.isSecureTextEntry = passwordShow
    }
    @IBAction func confirmPasswordShow(_ sender: Any) {
        confirmpasswordShow = !confirmpasswordShow
        confirmpassword.isSecureTextEntry = confirmpasswordShow
    }

    @objc func gotoSignUp(sender : UITapGestureRecognizer) {
        if firstname.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input first name", title: "")
            return
        }
        if lastname.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input last name", title: "")
            return
        }
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
        if confirmpassword.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input confirm password", title: "")
            return
        }
        if password.text! != confirmpassword.text!
        {
            DataUtils.messageShow(view: self, message: "Please check confirm password", title: "")
            return
        }
        
        communityUserSignup()
    }
    
    func communityUserSignup() {
        let params = [
            "email" : email.text!,
            "password" : password.text!,
            "first_name" : firstname.text!,
            "last_name" : lastname.text!,
            "usertype" : DataUtils.getPatient()!,
            "choice" : "5"
            
            ] as [String : Any]
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        
        
        
        let headers: HTTPHeaders = [
            //"Authorization": "your_access_token",  in case you need authorization header
            "Content-type": "multipart/form-data"
        ]
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = UIImageJPEGRepresentation(self.userImage!, 1){
                
                multipartFormData.append(data, withName: "name", fileName: "profile.jpg", mimeType: "image/jpeg")
            }
            
        }, usingThreshold: UInt64.init(), to: DataUtils.APIURL + DataUtils.AUTH_URL, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                    if let err = response.error{
                        //onError?(err)
                        DataUtils.messageShow(view: self, message: err.localizedDescription, title: "")
                        return
                    }
                    //onCompletion
                    if let data = response.result.value {
                        let json : [String:Any] = data as! [String : Any]
                        //let statusMsg: String = json["status_msg"] as! String
                        //self.showResultMessage(statusMsg)
                        //self.showGraph(json)
                        let result = json["status"] as? String
                        if result == "true"
                        {
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
                    
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
            }
        }
    }
    
    
    
    func gotoMainScreen()
    {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainviewcontroller") as! UITabBarController
        present(viewController, animated: false, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }

}
