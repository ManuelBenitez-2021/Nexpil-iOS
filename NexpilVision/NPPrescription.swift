//
//  NPPrescription.swift
//  NexpilVision
//
//  Created by Cagri Sahan on 6/19/18.
//  Copyright © 2018 Cagri Sahan. All rights reserved.
//

import Foundation

public class NPPrescription {
    
    var patientName: String?
    var pharmacy: NPPharmacy?
    var fillDate: Date?
    var prescriptionNumber: String?
    var doctorName: String?
    var dose: String?
    var frequency: String?
    var drug: NPDrug
    var drugQuantity: Int?
    
    public init(patientName: String?, pharmacy: NPPharmacy?, fillDate: Date?, prescriptionNumber: String?, doctorName: String?, dose: String?, frequency: String?, drug: NPDrug, drugQuantity: Int?) {
        self.patientName = patientName
        self.pharmacy = pharmacy
        self.fillDate = fillDate
        self.prescriptionNumber = prescriptionNumber
        self.doctorName = doctorName
        self.dose = dose
        self.frequency = frequency
        self.drug = drug
        self.drugQuantity = drugQuantity
    }
}

extension NPPrescription: CustomStringConvertible {
    public var description: String {
        return "Pharmacy: \(pharmacy)\nPrescription Number: \(prescriptionNumber)\nDoctor Name: \(doctorName)\nDrug: \(drug)\nDrug Quantity: \(drugQuantity)\nFill Date: \(fillDate)\nDose: \(dose)\nFrequency: \(frequency)\nPatient Name: \(patientName)"
    }
}
