//
//  MedicationHistory.swift
//  Nexpil
//
//  Created by Admin on 4/7/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct MedicationHistory {
    var id : Int
    var medicationId : Int
    var date: String
    var takeTime: String
    var eatenTime: String
    var eatText: String
    var medicationName: String
    var dayTime: String
    var prescription: Int
    init(id: Int,medicationId: Int,date: String,takeTime: String,eatenTime:String,eatText:String,medicationName:String,dayTime: String,prescription:Int)
    {
        self.id = id;
        self.medicationId = medicationId
        self.date = date
        self.takeTime = takeTime
        self.eatenTime = eatenTime
        self.eatText = eatText
        self.medicationName = medicationName
        self.dayTime = dayTime
        self.prescription = prescription
    }
}
