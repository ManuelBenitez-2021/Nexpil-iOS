//
//  SixMedicationAddViewController.swift
//  Nexpil
//
//  Created by Admin on 4/8/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import DropDown

class SixMedicationAddViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var howmany: UITextField!
    @IBOutlet weak var closebtn: UIButton!
    @IBOutlet weak var txtView: UIView!
    @IBOutlet weak var txtView1: UIView!
    @IBOutlet weak var helpview: UIView!
    @IBOutlet weak var howmanybtn: UIButton!
    
    @IBOutlet weak var howmanylabel: UILabel!
    @IBOutlet weak var txtView3: UIView!
    @IBOutlet weak var waybtn: UIButton!
    let howmanyDropDown = DropDown()
    let wayDropDown = DropDown()
    let howoftenDropDown = DropDown()
    @IBOutlet weak var txtView4: UIView!
    @IBOutlet weak var howoften: UITextField!
    @IBOutlet weak var timeslabel: UILabel!
    
    @IBOutlet weak var txtView5: UIView!
    @IBOutlet weak var howoftenbtn: UIButton!
    @IBOutlet weak var howoftenlabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        self.hideKeyboardWhenTappedAround()
        
        howmanyDropDown.anchorView = howmanybtn
        howmanyDropDown.bottomOffset = CGPoint(x: 0, y: howmanybtn.bounds.height)
        howmanybtn.contentHorizontalAlignment = .left
        howmanybtn.imageView?.trailingAnchor.constraint(equalTo: howmanybtn.trailingAnchor, constant: -10.0).isActive = true
        howmanybtn.imageView?.centerYAnchor.constraint(equalTo: howmanybtn.centerYAnchor, constant: 0.0).isActive = true
        
        howmanybtn.translatesAutoresizingMaskIntoConstraints = false
        howmanybtn.imageView?.translatesAutoresizingMaskIntoConstraints = false
        
        
        howmanyDropDown.dataSource = [
            "tablet",
            "capsule",
            "patch",
            "puff",
            "application"
        ]
        
        howmanyDropDown.selectionAction = { [unowned self] (index, item) in
            //self.howmanybtn.setTitle(item, for: .normal)
            self.howmanylabel.text = item
            
        }
        
        wayDropDown.anchorView = waybtn
        wayDropDown.bottomOffset = CGPoint(x: 0, y: waybtn.bounds.height)
        waybtn.contentHorizontalAlignment = .left
        waybtn.imageView?.trailingAnchor.constraint(equalTo: waybtn.trailingAnchor, constant: -10.0).isActive = true
        waybtn.imageView?.centerYAnchor.constraint(equalTo: waybtn.centerYAnchor, constant: 0.0).isActive = true
        
        waybtn.translatesAutoresizingMaskIntoConstraints = false
        waybtn.imageView?.translatesAutoresizingMaskIntoConstraints = false
        wayDropDown.dataSource = [
            "mouth",
            "orally",
            "needle",
            
        ]
        wayDropDown.selectionAction = { [unowned self] (index, item) in
            self.waybtn.setTitle(item, for: .normal)
            
        }
        
        howoftenDropDown.anchorView = howoftenbtn
        howoftenDropDown.bottomOffset = CGPoint(x: 0, y: waybtn.bounds.height)
        howoftenbtn.contentHorizontalAlignment = .left
        howoftenbtn.imageView?.trailingAnchor.constraint(equalTo: howoftenbtn.trailingAnchor, constant: -10.0).isActive = true
        howoftenbtn.imageView?.centerYAnchor.constraint(equalTo: howoftenbtn.centerYAnchor, constant: 0.0).isActive = true
        
        howoftenbtn.translatesAutoresizingMaskIntoConstraints = false
        howoftenbtn.imageView?.translatesAutoresizingMaskIntoConstraints = false
        howoftenDropDown.dataSource = [
            "a day",
            "a week",
            "a month",
            "as needed",
            
        ]
        howoftenDropDown.selectionAction = { [unowned self] (index, item) in
            //self.howoftenbtn.setTitle(item, for: .normal)
            self.howoftenlabel.text = item
        }
        
        txtView.viewShadow()
        txtView1.viewShadow()
        txtView3.viewShadow()
        txtView4.viewShadow()
        txtView5.viewShadow()
        
        howoften.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.showImage))
        helpview.layer.cornerRadius = 10.0
        helpview.layer.masksToBounds = true
        helpview.addGestureRecognizer(gesture)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        //your code
        
        guard textField.text != nil else { return }
        if howoften.text!.characters.count > 1
        {
            let text = howoften.text!
            let index = text.index(text.startIndex, offsetBy: 1)
            //lblPatientPhone.text = patientData.patientPhone.substring(to: index)
            howoften.text! = text.substring(to: index)
        }
        if howoften.text! == "1" || howoften.text! == "0" || howoften.text! == ""
        {
            timeslabel.text = "time"
        }
        else
        {
            timeslabel.text = "times"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func howmanyDropDownShow(_ sender: Any) {
        howmanyDropDown.show()
    }
    
    @IBAction func wayDropDownShow(_ sender: Any) {
        wayDropDown.show()
    }
    @IBAction func closeWidnow(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CloseAddMedicationViewController") as! CloseAddMedicationViewController
        present(viewController, animated: false, completion: nil)
    }
    
    @IBAction func howOftenDropDownShow(_ sender: Any) {
        howoftenDropDown.show()
    }
    @objc func showImage(sender : UITapGestureRecognizer) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HelpImageViewController") as! HelpImageViewController
        viewController.imageName = "dosehelpimage.png"
        present(viewController, animated: false, completion: nil)
    }
    
    @IBAction func gotoBack(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = 5
        appDelegate.pageViewController?.gotoPage()
    }
    @IBAction func gotoNext(_ sender: Any) {
        
        if howmany.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input number", title: "")
            return
        }
        
        if howoften.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input number", title: "")
            return
        }
        
        DataUtils.setMedicationDose(name: howmany.text! + " " + howmanylabel.text!)
        let text = howoften.text! + " " + timeslabel.text! + " " + howoftenlabel.text!
        DataUtils.setMedicationFrequency(name: (text + "-" + (waybtn.titleLabel?.text!)!))
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = 7
        appDelegate.pageViewController?.gotoPage()
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
