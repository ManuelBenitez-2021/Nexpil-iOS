//
//  InformationCardEditNameViewController
//  Nexpil
//
//  Created by Cagri Sahan on 9/26/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class InformationCardEditNameViewController: InformationCardEditViewController {
    
    @IBOutlet weak var firstNameCard: InformationCardEditable!
    @IBOutlet weak var lastNameCard: InformationCardEditable!
    @IBOutlet weak var doneButton: NPButton!
    @IBOutlet weak var doneButtonBottomConstraint: NSLayoutConstraint!
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        DispatchQueue.main.async { [unowned self] in
            self.summaryPage?.prescription?.patientName = self.name
            self.summaryPage?.fullNameCard.valueText = self.name
            self.summaryPage?.fullNameCard.view.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6.0)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    var name: String {
        get {
            let firstName = firstNameCard.textView.text ?? ""
            let lastName = lastNameCard.textView.text ?? ""
            let rawName = firstName + " " + lastName
            return rawName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    
    override func viewDidLoad() {
        
        self.doneButtonConstraint = doneButtonBottomConstraint
        
        if let names = self.summaryPage?.prescription?.patientName?.split(separator: " ") {
            if names.count > 0 {
                self.firstNameCard.valueText = String(names[0])
                if names.count > 1 {
                    self.lastNameCard.valueText = String(names[1])
                }
            }
        }
        super.viewDidLoad()
    }
}

