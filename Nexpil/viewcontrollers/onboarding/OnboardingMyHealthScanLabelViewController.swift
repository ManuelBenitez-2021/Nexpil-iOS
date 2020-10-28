//
//  OnboardingMyHealthScanLabelViewController.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/25/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import AVFoundation

class OnboardingMyHealthScanLabelViewController: UIViewController {
    
    @IBAction func allowButtonTapped(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardingTwoViewController") as! OnboardingTwoViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
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
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        print(authStatus.rawValue)
        switch authStatus {
        case .authorized:
            super.prepare(for: segue, sender: sender)
        case .denied:
            DispatchQueue.main.async {
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, completionHandler: nil)
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        super.prepare(for: segue, sender: sender)
                    }
                }
            }
        default:
            DispatchQueue.main.async {
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, completionHandler: nil)
            }
        }
    }
}
