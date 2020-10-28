//
//  EmailViewController.swift
//  Nexpil
//
//  Created by Admin on 01/01/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class EmailViewController: UIViewController {

    @IBOutlet weak var emailAddress: InformationCardEditable!
    @IBOutlet weak var bottomButtonConstant: NSLayoutConstraint!
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if DataUtils.getEmail() != ""
        {
            emailAddress.textView.text = DataUtils.getEmail()
        }
        center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        emailAddress.textView.resignFirstResponder()
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
        if emailAddress.textView.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input email address", title: "")
            return
        }
        if DataUtils.isValidEmailAddress(emailAddressString: emailAddress.textView.text!) == false
        {
            DataUtils.messageShow(view: self, message: "Please input valid email address", title: "")
            return
        }
        DataUtils.setEmail(email: emailAddress.textView.text!)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
