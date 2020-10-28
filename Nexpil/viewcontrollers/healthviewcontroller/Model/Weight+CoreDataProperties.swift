//
//  Weight+CoreDataProperties.swift
//  
//
//  Created by Loyal Lauzier on 2018/06/11.
//
//

import Foundation
import CoreData


extension Weight {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weight> {
        return NSFetchRequest<Weight>(entityName: "Weight")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var day: String?
    @NSManaged public var month: String?
    @NSManaged public var year: String?
    @NSManaged public var strDate: String?
    @NSManaged public var strMonth: String?
    @NSManaged public var strWeek: String?
    @NSManaged public var value: Double

}
