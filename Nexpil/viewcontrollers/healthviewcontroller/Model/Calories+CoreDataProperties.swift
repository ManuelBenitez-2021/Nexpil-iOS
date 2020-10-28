//
//  Calories+CoreDataProperties.swift
//  
//
//  Created by Loyal Lauzier on 2018/06/27.
//
//

import Foundation
import CoreData


extension Calories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Calories> {
        return NSFetchRequest<Calories>(entityName: "Calories")
    }

    @NSManaged public var date: Date?
    @NSManaged public var strDate: String?
    @NSManaged public var value: Double

}
