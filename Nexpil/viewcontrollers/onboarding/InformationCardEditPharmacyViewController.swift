//
//  InformationCardEditPharmacyViewController.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/27/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class InformationCardEditPharmacyViewController: InformationCardEditViewController {

    @IBOutlet weak var pharmacyNameCard: InformationCardEditable!
    @IBOutlet weak var doneButton: NPButton!
    @IBOutlet weak var doneButtonBottomConstraint: NSLayoutConstraint!
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        DispatchQueue.main.async { [unowned self] in
            self.summaryPage?.prescription?.drug.name = self.pharmacyName
            self.summaryPage?.pharmacyCard.valueText = self.pharmacyName
            self.summaryPage?.pharmacyCard.view.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6.0)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    var pharmacyName: String {
        get {
            let pharmacyName = self.pharmacyNameCard.textView.text ?? ""
            return pharmacyName.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    
    override func viewDidLoad() {
        
        self.doneButtonConstraint = doneButtonBottomConstraint
        
        self.pharmacyNameCard.valueText = self.summaryPage?.prescription?.pharmacy?.name ?? ""
        super.viewDidLoad()
    }

}
