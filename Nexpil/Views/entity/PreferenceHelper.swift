//
//  PreferenceHelper.swift
//  Nexpil
//
//  Created by Admin on 4/6/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

class PreferenceHelper {
    let defaults = UserDefaults.standard
    func getEmail() -> String?
    {
        return defaults.string(forKey: "email")
    }
    func getActive() -> Int {
        return defaults.integer(forKey: "active")
    }
    func getAge() -> Int {
        return defaults.integer(forKey: "age")
    }
    func getApplicationLocation() -> String? {
        return defaults.string(forKey: "application_location")
    }
    func getBirthday() -> String? {
        return defaults.string(forKey: "birthday")
    }
    func getCity() -> String? {
        return defaults.string(forKey: "city")
    }
    func getFirstName() ->String? {
        return defaults.string(forKey: "first_name")
    }
    func getLastName() ->String? {
        return defaults.string(forKey: "last_name")
    }
    func getId() ->Int {
        return defaults.integer(forKey: "id")
    }
    func getLanguage() -> String? {
        return defaults.string(forKey: "language")
    }
    func getLocation() -> String? {
        return defaults.string(forKey: "location")
    }
    func getPhoneNumber() -> String? {
        return defaults.string(forKey: "phone_number")
    }
    func getSex() -> String? {
        return defaults.string(forKey: "sex")
    }
    func getState() -> String? {
        return defaults.string(forKey: "state")
    }
    func getStreet() -> String? {
        return defaults.string(forKey: "street")
    }
    func getUserName() -> String? {
        return defaults.string(forKey: "user_name")
    }
    func getUserType() -> String? {
        return defaults.string(forKey: "usertype")
    }
    func getZipcode() -> String? {
        return defaults.string(forKey: "zipcode")
    }
    func getDiagnosisDate() -> String? {
        return defaults.string(forKey: "diagnosis_date")
    }
    func setUserType(type: String) {
        defaults.set(type, forKey: "usertype")
    }
    func getUserImage() -> String? {
        return defaults.string(forKey: "userimage")
    }
    func getUserCode() -> String? {
        return defaults.string(forKey: "usercode")
    }
    func getCreatedAt() -> String? {
        return defaults.string(forKey: "createdAt")
    }
}
