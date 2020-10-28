//
//  OnboardingOneViewController.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/24/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class OnboardingOneViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backImage = UIImage(named: "Back")
        let logoImage = UIImage(named: "nexpil logo - alternate")
        self.navigationItem.titleView = UIImageView(image: logoImage)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(self.closeWindow))
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
    }
    @IBAction func gotoCameraAccessAllow(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardingMyHealthScanLabelViewController") as! OnboardingMyHealthScanLabelViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func closeWindow()
    {
        dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillDisappear(animated)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
