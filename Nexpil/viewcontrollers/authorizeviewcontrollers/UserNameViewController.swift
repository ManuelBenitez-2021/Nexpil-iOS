//
//  UserNameViewController.swift
//  Nexpil
//
//  Created by Admin on 01/01/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class UserNameViewController: UIViewController {

    @IBOutlet weak var bottomButtonConstant: NSLayoutConstraint!
    @IBOutlet weak var firstName: InformationCardEditable!
    @IBOutlet weak var lastName: InformationCardEditable!
    let center = NotificationCenter.default
    var originalHeight: CGFloat?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backImage = UIImage(named: "Back")
        let logoImage = UIImage(named: "nexpil logo - alternate")
        self.navigationItem.titleView = UIImageView(image: logoImage)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(self.closeWindow))
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        originalHeight = bottomButtonConstant.constant
    }
    @objc func closeWindow() {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if DataUtils.getPatientFullName() != ""
        {
            firstName.textView.text = DataUtils.getPatientFullName()?.components(separatedBy: " ")[0]
            lastName.textView.text = DataUtils.getPatientFullName()?.components(separatedBy: " ")[1]
        }
        center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        firstName.textView.resignFirstResponder()
        lastName.textView.resignFirstResponder()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification)
    {
        let keyboardHeight = (notification.userInfo?["UIKeyboardBoundsUserInfoKey"] as! CGRect).height
        bottomButtonConstant.constant = self.originalHeight! + keyboardHeight
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        bottomButtonConstant?.constant = self.originalHeight!
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func gotoNext(_ sender: Any) {
        if firstName.textView.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input first name", title: "")
            return
        }
        if lastName.textView.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input last name", title: "")
            return
        }
        DataUtils.setPatientFullName(patientfullname: firstName.textView.text! + " " + lastName.textView.text!)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EmailViewController") as! EmailViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
