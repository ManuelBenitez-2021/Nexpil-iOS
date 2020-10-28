//
//  TakePrescriptionViewController.swift
//  Nexpil
//
//  Created by Admin on 5/8/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
class TakePrescriptionViewController: UIViewController {

    @IBOutlet weak var tablesView: UIView!
    @IBOutlet weak var tablets: SkyFloatingLabelTextField!
    @IBOutlet weak var oftenView: UIView!
    @IBOutlet weak var often: SkyFloatingLabelTextField!
    @IBOutlet weak var helpview: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tablesView.viewShadow()
        oftenView.viewShadow()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        tablets.titleFormatter = { $0 }
        often.titleFormatter = { $0 }
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.showImage))
        helpview.layer.cornerRadius = 10.0
        helpview.layer.masksToBounds = true
        helpview.addGestureRecognizer(gesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func closeWidnow(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CloseAddMedicationViewController") as! CloseAddMedicationViewController
        present(viewController, animated: false, completion: nil)
    }
    @objc func showImage(sender : UITapGestureRecognizer) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HelpImageViewController") as! HelpImageViewController
        viewController.imageName = "dosehelpimage.png"
        present(viewController, animated: false, completion: nil)
    }
    
    @IBAction func gotoBack(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage - 1
        appDelegate.pageViewController?.gotoPage()
    }
    @IBAction func gotoNext(_ sender: Any) {
        
        if tablets.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input info", title: "")
            return
        }
        
        if often.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input info", title: "")
            return
        }
        //DataUtils.setStartTablet(name: tablets.text!)
        DataUtils.setMedicationDose(name: tablets.text!)
        DataUtils.setMedicationFrequency(name: often.text!)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage + 1
        appDelegate.pageViewController?.gotoPage()
    }
    
}
