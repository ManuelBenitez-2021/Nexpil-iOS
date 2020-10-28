//
//  Notification.swift
//  Nexpil
//
//  Created by Admin on 24/06/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct NotificationEntity {
    var userid: Int
    var firstname: String
    var lastname: String
    var notification: String
    var createat:String
    var userimage:String
    init(json:[String : Any])
    {
        self.userid = (json["userid"] as! NSString).integerValue
        self.firstname = (json["firstn"] as! NSString) as String
        self.notification = (json["notification"] as! NSString) as String
        self.createat = (json["createat"] as! NSString) as String
        self.firstname = (json["firstname"] as! NSString) as String
        self.lastname = (json["lastname"] as! NSString) as String
        self.userimage = (json["userimage"] as! NSString) as String        
    }
}
