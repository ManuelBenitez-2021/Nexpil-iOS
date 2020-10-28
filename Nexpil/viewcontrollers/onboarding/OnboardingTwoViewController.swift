//
//  OnboardingTwoViewController.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/25/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class OnboardingTwoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backImage = UIImage(named: "Back")
        let logoImage = UIImage(named: "nexpil logo - alternate")
        self.navigationItem.titleView = UIImageView(image: logoImage)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(self.closeWindow))
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    @objc func closeWindow() {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillDisappear(animated)
    }
    @IBAction func gotoFirstMedicationAddViewController(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstMedicationAddViewController") as! FirstMedicationAddViewController
        //viewController.tabBar.roundCorners([.topLeft, .topRight], radius: 10)
        let navController = UINavigationController(rootViewController: viewController)        
        present(navController, animated: false, completion: nil)
    }
}
