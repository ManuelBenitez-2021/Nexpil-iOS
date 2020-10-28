//
//  PatientMedication.swift
//  Nexpil
//
//  Created by Admin on 4/7/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct PatientMedication {
    
    var medication : Medication
    
    init(json:[String:Any])
    {
        medication = Medication.init(json: json)
    }
}
