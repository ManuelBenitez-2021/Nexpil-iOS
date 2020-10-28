//
//  CommunityUser.swift
//  Nexpil
//
//  Created by Admin on 6/16/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation


struct CommunityUser {
    var userid: Int
    var userimage: String
    var firstname: String
    var lastname: String
    init(json:[String : Any])
    {
        self.userid = (json["userid"] as! NSString).integerValue
        self.userimage = (json["userimage"] as! NSString) as String
        self.firstname = (json["firstname"] as! NSString) as String
        self.lastname = (json["lastname"] as! NSString) as String
    }
    init(userid:Int, firstname:String,lastname:String,userimage:String)
    {
        self.userid = userid
        self.firstname = firstname
        self.lastname = lastname
        self.userimage = userimage
    }
}
