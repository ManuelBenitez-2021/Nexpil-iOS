//
//  NewSecondViewController.swift
//  Nexpil
//
//  Created by Admin on 4/13/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import SkyFloatingLabelTextField

class NewSecondViewController: UIViewController {

    @IBOutlet weak var patientName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        patientName.titleFormatter = { $0 }
        txtView.viewShadow()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func gotoBack(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = 0
        appDelegate.pageViewController?.gotoPage()
    }
    
    @IBAction func gotoNext(_ sender: Any) {
        if patientName.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input patient full name", title: "")
            return
        }
        DataUtils.setPatientFullName(patientfullname: patientName.text!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = 2
        appDelegate.pageViewController?.gotoPage()
    }
    @IBAction func closeWindow(_ sender: Any) {
        /*
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.closePageViewController()
        */
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CloseAddMedicationViewController") as! CloseAddMedicationViewController
        present(viewController, animated: false, completion: nil)
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
