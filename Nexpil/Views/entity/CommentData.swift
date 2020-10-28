//
//  CommentData.swift
//  Nexpil
//
//  Created by Admin on 02/07/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct CommentData {
    
    var firstname:String
    var lastname:String
    var comment:String
    var userimage:String
    
    init(json:[String : Any])
    {
        
        self.firstname = (json["firstname"] as! NSString) as String
        self.lastname = (json["lastname"] as! NSString) as String
        self.userimage = (json["userimage"] as! NSString) as String
        self.comment = (json["content"] as! NSString) as String
        
    }
        
}
