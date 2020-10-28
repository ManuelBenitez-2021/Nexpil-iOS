//
//  PatientInfo.swift
//  Nexpil
//
//  Created by Admin on 4/6/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct PatientInfo {
    var active:Int
    var age:Int
    var applicationLocation:String
    var birthday:String
    var city:String
    var diagnosisDate:String
    var email:String
    var firstName:String
    var lastName:String
    var id:Int
    var language:String
    var location:String
    var phoneNumber:String
    var sex:String
    var state:String
    var street:String
    var userName:String
    var userType:String
    var zipCode:String
    var userCode:String
    var userImage:String
    var createdAt:String

    init(active:Int,age:Int,applicationLocation:String,birthday:String,city:String,diagnosisDate:String,email:String,firstName:String,lastName:String,id:Int,language:String,location:String,phoneNumber:String,sex:String,state:String,street:String,userName:String,userType:String,zipCode:String,userCode:String,userImage:String,createdAt:String)
    {
        self.active = active
        self.age = age
        self.applicationLocation = applicationLocation
        self.id = id
        self.birthday = birthday
        self.city = city
        self.diagnosisDate = diagnosisDate
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.language = language
        self.location = location
        self.phoneNumber = phoneNumber
        self.sex = sex
        self.state = state
        self.street = street
        self.userName = userName
        self.userType = userType
        self.zipCode = zipCode
        self.userImage = userImage
        self.userCode = userCode
        self.createdAt = createdAt
    }
    init(json:[String:Any])
    {
        self.active = (json["active"] as! NSString).integerValue
        self.age = (json["age"] as! NSString).integerValue
        self.applicationLocation = (json["application_location"] as! NSString) as String
        self.id = (json["id"] as! NSString).integerValue
        self.birthday = (json["birthday"] as! NSString) as String
        self.city = (json["city"] as! NSString) as String
        self.diagnosisDate = (json["diagnosis_date"] as! NSString) as String
        self.email = (json["email"] as! NSString) as String
        self.firstName = (json["first_name"] as! NSString) as String
        self.lastName = (json["last_name"] as! NSString) as String
        self.language = (json["language"] as! NSString) as String
        self.location = (json["location"] as! NSString) as String
        self.phoneNumber = (json["phone_number"] as! NSString) as String
        self.sex = (json["sex"] as! NSString) as String
        self.userName = (json["user_name"] as! NSString) as String
        self.userType = (json["usertype"] as! NSString) as String
        self.zipCode = (json["zipcode"] as! NSString) as String
        self.state = (json["state"] as! NSString) as String
        self.street = (json["street"] as! NSString) as String
        self.userCode = (json["usercode"] as! NSString) as String
        self.userImage = (json["userimage"] as! NSString) as String
        self.createdAt = (json["created_at"] as! NSString) as String
    }
    func saveUserInfo()
    {
        let defaults = UserDefaults.standard
        
        defaults.set(self.id, forKey: "id")
        defaults.set(self.active,forKey:"active")
        defaults.set(self.age,forKey:"age")
        defaults.set(self.applicationLocation,forKey:"application_location")
        defaults.set(self.birthday,forKey:"birthday")
        
        defaults.set(self.city,forKey:"city")
        defaults.set(self.diagnosisDate,forKey:"diagnosis_date")
        defaults.set(self.email,forKey:"email")
        defaults.set(self.firstName,forKey:"first_name")
        defaults.set(self.lastName,forKey:"last_name")
        defaults.set(self.language,forKey:"language")
        defaults.set(self.location,forKey:"location")
        defaults.set(self.phoneNumber,forKey:"phone_number")
        defaults.set(self.sex,forKey:"sex")
        defaults.set(self.userName,forKey:"user_name")
        defaults.set(self.userType,forKey:"usertype")
        defaults.set(self.zipCode,forKey:"zipcode")
        defaults.set(self.state,forKey:"state")
        defaults.set(self.street,forKey:"street")
        defaults.set(self.userImage,forKey:"userimage")
        defaults.set(self.userCode,forKey:"usercode")
        defaults.set(self.createdAt, forKey: "createdAt")
    }
    
}
