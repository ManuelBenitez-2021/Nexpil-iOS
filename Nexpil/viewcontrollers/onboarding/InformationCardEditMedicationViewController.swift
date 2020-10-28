//
//  InformationCardEditMedicationViewController.swift
//  Nexpil
//
//  Created by Cagri Sahan on 9/27/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class InformationCardEditMedicationViewController: InformationCardEditViewController {
    
    @IBOutlet weak var medicationNameCard: InformationCardButton!
    @IBOutlet weak var doneButton: NPButton!
    @IBOutlet weak var doneButtonBottomConstraint: NSLayoutConstraint!
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        DispatchQueue.main.async { [unowned self] in
            /*
            self.summaryPage?.prescription?.drug.name = self.medicationName
            self.summaryPage?.medicationCard.valueText = self.medicationName
            self.summaryPage?.medicationCard.view.addShadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.16, x: 0, y: 3, blur: 6.0)
            */
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let medicationController = storyBoard.instantiateViewController(withIdentifier: "InformationCardMedicationSelectViewController") as! InformationCardMedicationSelectViewController
            self.navigationController?.pushViewController(medicationController, animated: true)
        }
    }
    /*
    var medicationName: String {
        get {
            let medicationName = self.medicationNameCard.textView.text ?? ""
            return medicationName.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    */
    
    override func viewDidLoad() {
        self.medicationNameCard.valueText = self.summaryPage?.prescription?.drug.name ?? ""
        super.viewDidLoad()
        self.doneButtonConstraint = doneButtonBottomConstraint
        let logoImage = UIImage(named: "Progress Bar1")
        self.navigationItem.titleView = UIImageView(image: logoImage)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.searchDrug))
        
        medicationNameCard.addGestureRecognizer(gesture)
        
    }
    
    @objc func searchDrug(sender : UITapGestureRecognizer) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let medicationController = storyBoard.instantiateViewController(withIdentifier: "InformationCardMedicationSelectViewController") as! InformationCardMedicationSelectViewController
        self.navigationController?.pushViewController(medicationController, animated: true)
    }
    
}

