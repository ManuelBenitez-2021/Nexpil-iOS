//
//  MedicationRemoveViewController.swift
//  Nexpil
//
//  Created by Admin on 18/12/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class MedicationRemoveViewController: UIViewController {

    @IBOutlet weak var medicationName: UILabel!
    var cellTypes:[ItemType]?
    var datas:[MyMedication] = []
    var delegate:ShadowDelegate2?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        var str = ""
        for item in cellTypes!
        {
            if item.patientMedicationIndex == 1
            {
                str = str + datas[item.medicationtimeIndex].medicationname + "\n"
            }
        }
        medicationName.text = str
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func clickCancel(_ sender: Any) {
        dismiss(animated: false, completion: nil)
        self.delegate?.removeShadow1(root: false)
    }
    
    @IBAction func gotoRemove(_ sender: Any) {
        for data in cellTypes!
        {
            if data.patientMedicationIndex == 1
            {
                let _ = DBManager.shared.deleteMedicationDrug1(name: datas[data.medicationtimeIndex].medicationname)
            }
        }
        dismiss(animated: false, completion: nil)
        self.delegate?.removeShadow1(root: true)
    }
}
