//
//  ItemType.swift
//  Nexpil
//
//  Created by Admin on 4/7/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct ItemType {
    var celltype:CellType
    var medicationtimeIndex:Int
    var patientMedicationIndex:Int
    var labelName:String
    init(celltype:CellType,medicationtimeIndex:Int,patientMedicationIndex:Int,labelName:String)
    {
        self.celltype = celltype
        self.medicationtimeIndex = medicationtimeIndex
        self.patientMedicationIndex = patientMedicationIndex
        self.labelName = labelName
    }
}
