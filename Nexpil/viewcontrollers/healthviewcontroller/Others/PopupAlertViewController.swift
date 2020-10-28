//
//  PopupAlertViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/31.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit

protocol PopupAlertViewControllerDelegate: class {
    func didTapButtonClosePopupAlertViewController()
}

class PopupAlertViewController: UIViewController {

    weak var delegate:PopupAlertViewControllerDelegate?
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtDescription: UITextView!
    
    var index = NSInteger()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initMainView()
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

    func initMainView() {
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true;
        txtDescription.isEditable = false
        
        let arrayDescriptions = [
                "PPG > 180 or FPG > 30\nAt risk of hyperglycemia, which may cause diabetes and its complication. Hyperglycemia can lead to heart diseases, foot problems, eye disease, and nerve damage. Please do not skip any scheduled doses for diabetes and do not eat large amount of food in one meal.\n\nFPG, PPG < 70\n At risk of hypoglycemia, which may cause sweat, headache, and dizziness. Please take 4 glucose tablets or one tube of glucose gel or drink 1/2 cup of fruit juice now. Do not skip any meals.",
                "BP > 140/90\nAt risk of hypertension. Even though you may not find any symptoms of hypertension, ignoring your blood pressure can lead to serious consequences. Please do not skip any scheduled doses for hypertension.\n\nBP < 90/60\nAt risk of hypotension, which may lead to dizziness, fainting, fatigue, and nausea. Please contact your provider immediately to discuss your current blood pressure treatment if your blood pressure is consistently lower than 90/60 mmHg.",
                "90% < Oxygen < 95%\nAt risk of hypoxemia, which may lead to damage to various organs, confusion, and rapid breathing. Please contact your provider and monitor your oxygen level carefully.\n\nOxygen < 90%\nSeek medical emergency immediately.",
                "A1c > 7\nA1c is measured every few months to monitor your blood glucose level. Your goal is to bring down your A1c level to below 7. Please keeping taking/ administering your medications as scheduled.",
                "LDL > 100\nAt risk of atherosclerosis, which leads to blood clotting, and heart disease. Please do not skip any scheduled doses for cholesterol control.",
                "INR > 7\n",
            ] as NSArray
        
        txtDescription.text = arrayDescriptions[index] as! String
        
        lblTitle.font = UIFont.init(name: "Montserrat", size: 30)
        txtDescription.font = UIFont.init(name: "Montserrat", size: 15)

        
    }
    
    @IBAction func tapBtnClose(_ sender: Any) {
        self.delegate?.didTapButtonClosePopupAlertViewController()
    }
    
}
