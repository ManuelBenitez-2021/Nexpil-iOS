//
//  Medication.swift
//  Nexpil
//
//  Created by Admin on 4/7/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct Medication {
    var id : Int
    var name : String
    var directions: String
    var dose : String
    var image : String
    var quantity : Int
    var price: String
    var lowestPrice : String
    var cheapestPrice : String
    var comparisonPrice : String
    var expiration : String
    var manifacture : String
    var substituted : String
    var filedDate : String
    var warnings : String
    var type : String
    
    init(json:[String : Any])
    {
        self.name = (json["name"] as! NSString) as String
        self.directions = (json["directions"] as! NSString) as String
        self.dose = (json["dose"] as! NSString) as String
        self.image = (json["image"] as! NSString) as String
        self.quantity = (json["quantity"] as! NSString).integerValue
        self.price = (json["price"] as! NSString) as String
        self.lowestPrice = (json["lowest_price"] as! NSString) as String
        self.cheapestPrice = (json["cheapest_price"] as! NSString) as String
        self.comparisonPrice = (json["comparison_price"] as! NSString) as String
        self.expiration = (json["expiration"] as! NSString) as String
        
        self.manifacture = (json["manufacture"] as! NSString) as String
        self.substituted = (json["substituted"] as! NSString) as String
        self.filedDate = (json["filed_date"] as! NSString) as String
        self.warnings = (json["warnings"] as! NSString) as String
        self.type = (json["type"] as! NSString) as String
        self.id = (json["medication_id"] as! NSString).integerValue
    }
    
}
