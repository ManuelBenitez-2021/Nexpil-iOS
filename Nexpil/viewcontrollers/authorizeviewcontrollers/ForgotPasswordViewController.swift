//
//  ForgotPasswordViewController.swift
//  Nexpil
//
//  Created by Admin on 21/12/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    var bottomHeight:CGFloat?
    let center = NotificationCenter.default
    var keyboardHeight: CGFloat?
    @IBOutlet weak var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        errorLabel.isHidden = true
        bottomHeight = bottomConstant.constant
    }
    
    override func viewDidAppear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enable = false
        //mainView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        IQKeyboardManager.sharedManager().enable = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func gotoBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func gotoSetLink(_ sender: Any) {
        
    }
    @objc func keyboardWillShow(_ notification: Notification)
    {
        
        keyboardHeight = (notification.userInfo?["UIKeyboardBoundsUserInfoKey"] as! CGRect).height
        bottomConstant.constant = 20 + self.keyboardHeight!
        //mainView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = false
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        bottomConstant.constant = self.bottomHeight!
        //mainView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}
