//
//  DrugInfo.swift
//  Nexpil
//
//  Created by Admin on 4/27/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct DrugInfo: Codable {
    let indications_and_usage: [String]?
    let dosage_and_administration: [String]?
    let description: [String]?
    let purpose: [String]?
}
