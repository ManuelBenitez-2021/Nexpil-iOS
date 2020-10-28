//
//  SelectMedicationViewController1.swift
//  Nexpil
//
//  Created by Admin on 5/7/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import AVFoundation

class SelectMedicationViewController1: UIViewController {

    
    @IBOutlet weak var backBtn: UIView!
    @IBOutlet weak var nextBtn: GradientView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.gotoNext1))
        nextBtn.addGestureRecognizer(gesture)
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(self.gotoBack))
        backBtn.addGestureRecognizer(gesture1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    //access allowed
                } else {
                    //access denied
                }
            })
        }
    }
    
    @objc func gotoBack(sender : UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func gotoNext1(sender : UITapGestureRecognizer) {
        if DataUtils.getPatient()! == "patient"
        {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectMedicationViewController") as! SelectMedicationViewController
            present(viewController, animated: false, completion: nil)
        }
        else {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommunityAddViewController") as! CommunityAddViewController
            present(viewController, animated: false, completion: nil)
        }
    }
    
    @IBAction func gotoAllow(_ sender: Any) {
        if DataUtils.getPatient()! == "patient"
        {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectMedicationViewController") as! SelectMedicationViewController
            present(viewController, animated: false, completion: nil)
        }
        else {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommunityAddViewController") as! CommunityAddViewController
            present(viewController, animated: false, completion: nil)
        }
    }
    
    @IBAction func gotoBack(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
