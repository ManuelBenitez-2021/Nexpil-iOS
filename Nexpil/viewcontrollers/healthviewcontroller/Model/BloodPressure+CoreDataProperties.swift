//
//  BloodPressure+CoreDataProperties.swift
//  
//
//  Created by Loyal Lauzier on 2018/06/10.
//
//

import Foundation
import CoreData


extension BloodPressure {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BloodPressure> {
        return NSFetchRequest<BloodPressure>(entityName: "BloodPressure")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var value1: Int64
    @NSManaged public var value2: Int64
    @NSManaged public var time: String?
    @NSManaged public var day: String?
    @NSManaged public var month: String?
    @NSManaged public var year: String?
    @NSManaged public var strDate: String?
    @NSManaged public var strWeek: String?
    @NSManaged public var strMonth: String?
    @NSManaged public var timeIndex: String?

}
