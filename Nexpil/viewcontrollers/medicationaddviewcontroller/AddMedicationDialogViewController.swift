//
//  AddMedicationDialogViewController.swift
//  Nexpil
//
//  Created by Admin on 5/7/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class AddMedicationDialogViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    var selectedIndex = -1
    var delegate:ShadowDelegate?
    let myItems = [
        VoteModel(title: "Vitamins", isSelected: false, isUserSelectEnable: true),
        VoteModel(title: "Prescription", isSelected: false, isUserSelectEnable: true),     
        ]
    
    
    @IBOutlet weak var vitaminButton: GradientView!
    @IBOutlet weak var prescriptionButton: GradientView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        
        
//        mainView.viewShadow()
        
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.vitaminSelect))
        vitaminButton.addGestureRecognizer(gesture2)
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(self.prescriptionSelect))
        prescriptionButton.addGestureRecognizer(gesture1)
//
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func vitaminSelect(sender : UITapGestureRecognizer) {
        didSelectRowAt(index: 0)
    }

    @objc func prescriptionSelect(sender : UITapGestureRecognizer) {
        didSelectRowAt(index: 1)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func didSelectRowAt(index:Int) {
        
        
        selectedIndex = index
        if selectedIndex == 1
        {
            //prescription
            DataUtils.setMPrescription(name: 0)
            
        }
        else {
            //Vitamin(counter-over)
            DataUtils.setMPrescription(name: 1)
            
        }
        self.dismiss(animated: false, completion: {
            self.delegate?.removeShadow()
        })
        
    }
    
}
