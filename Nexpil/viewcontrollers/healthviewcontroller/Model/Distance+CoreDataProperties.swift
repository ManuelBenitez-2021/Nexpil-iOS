//
//  Distance+CoreDataProperties.swift
//  
//
//  Created by Loyal Lauzier on 2018/06/27.
//
//

import Foundation
import CoreData


extension Distance {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Distance> {
        return NSFetchRequest<Distance>(entityName: "Distance")
    }

    @NSManaged public var date: Date?
    @NSManaged public var strDate: String?
    @NSManaged public var value: Double

}
