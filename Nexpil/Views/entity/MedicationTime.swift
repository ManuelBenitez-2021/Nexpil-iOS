//
//  MedicationTime.swift
//  Nexpil
//
//  Created by Admin on 4/7/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct MedicationTime {
    var time: String
    var count: Int
    var medicationName : String
    init(time:String,count:Int,medicationName :String)
    {
        self.time = time
        self.count = count
        self.medicationName = medicationName
    }
}
