//
//  InformationCardEditViewController.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/27/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class InformationCardEditViewController: UIViewController,ShadowDelegate1 {
    
    var doneButtonConstraint: NSLayoutConstraint?
    
    
    let center = NotificationCenter.default
    var keyboardHeight: CGFloat?
    var originalHeight: CGFloat?
    var summaryPage: SummaryScreenViewController?
    
    var visualEffectView:VisualEffectView?
    var medicationName:String?
    var strength:String?
    var direction:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backImage = UIImage(named: "Back")
        let closeImage = UIImage(named:"Closebutton")?.withRenderingMode(.alwaysOriginal)
        let logoImage = UIImage(named: "nexpil logo - alternate")
        self.navigationItem.titleView = UIImageView(image: logoImage)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: navigationController, action: #selector(UINavigationController.popViewController(animated:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: closeImage, style: .done, target: self, action: #selector(self.showCloseAddMedicationCardViewController))
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        originalHeight = doneButtonConstraint?.constant
        visualEffectView = self.view.backgroundBlur(view: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification)
    {
        keyboardHeight = (notification.userInfo?["UIKeyboardBoundsUserInfoKey"] as! CGRect).height
        doneButtonConstraint?.constant = self.originalHeight! + self.keyboardHeight!
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        doneButtonConstraint?.constant = self.originalHeight!
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    @objc func showCloseAddMedicationCardViewController()
    {
        self.view.addSubview(visualEffectView!)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CloseAddMedicationViewController") as! CloseAddMedicationViewController
        //viewController.tabBar.roundCorners([.topLeft, .topRight], radius: 10)
        viewController.delegate = self
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: false, completion: nil)
    }
    func removeShadow(root: Bool) {
        visualEffectView?.removeFromSuperview()
        if root == true
        {
            navigationController?.popToRootViewController(animated: false)
        }
    }
}
