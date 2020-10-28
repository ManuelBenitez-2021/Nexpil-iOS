//
//  InformationCardEditDoctorViewController.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/27/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class InformationCardEditDoctorViewController: InformationCardEditViewController {

    @IBOutlet weak var doctorNameCard: InformationCardEditable!
    @IBOutlet weak var doneButton: NPButton!
    @IBOutlet weak var doneButtonBottomConstraint: NSLayoutConstraint!
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        DispatchQueue.main.async { [unowned self] in
            self.summaryPage?.prescription?.doctorName = self.doctorName
            self.summaryPage?.doctorCard.valueText = self.doctorName
            self.summaryPage?.doctorCard.view.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6.0)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    var doctorName: String {
        get {
            let doctorName = self.doctorNameCard.textView.text ?? ""
            return doctorName.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    
    override func viewDidLoad() {
        
        self.doneButtonConstraint = doneButtonBottomConstraint
        
        self.doctorNameCard.valueText = self.summaryPage?.prescription?.doctorName ?? ""
        super.viewDidLoad()
    }

    
}
