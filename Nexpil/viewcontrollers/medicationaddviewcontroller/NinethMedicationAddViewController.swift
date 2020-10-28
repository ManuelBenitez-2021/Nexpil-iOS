//
//  NinethMedicationAddViewController.swift
//  Nexpil
//
//  Created by Admin on 4/8/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import SkyFloatingLabelTextField

class NinethMedicationAddViewController: UIViewController {

    @IBOutlet weak var prescribedby: SkyFloatingLabelTextField!
    @IBOutlet weak var txtView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        
        txtView.viewShadow()
        
        prescribedby.titleFormatter = {$0}
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.showImage))
        helpview.layer.cornerRadius = 10.0
        helpview.layer.masksToBounds = true
        helpview.addGestureRecognizer(gesture)
    }

    @IBOutlet weak var helpview: UIView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeWindow(_ sender: Any) {
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
   
    @objc func showImage(sender : UITapGestureRecognizer) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HelpImageViewController") as! HelpImageViewController
        viewController.imageName = "prescribebyhelpimage.png"
        present(viewController, animated: false, completion: nil)
    }
    
    @IBAction func gotoBack(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = 7
        appDelegate.pageViewController?.gotoPage()
    }
    @IBAction func gotoNext(_ sender: Any) {
        
        if prescribedby.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input name", title: "")
            return
        }
        DataUtils.setPrescribed(name: prescribedby.text!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = 9
        appDelegate.pageViewController?.gotoPage()
    }
    
}
