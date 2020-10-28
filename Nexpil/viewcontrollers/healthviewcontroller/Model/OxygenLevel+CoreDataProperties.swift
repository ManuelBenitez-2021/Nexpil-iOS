//
//  OxygenLevel+CoreDataProperties.swift
//  
//
//  Created by Loyal Lauzier on 2018/06/08.
//
//

import Foundation
import CoreData


extension OxygenLevel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OxygenLevel> {
        return NSFetchRequest<OxygenLevel>(entityName: "OxygenLevel")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var strDate: String?
    @NSManaged public var strWeek: String?
    @NSManaged public var strMonth: String?
    @NSManaged public var year: String?
    @NSManaged public var month: String?
    @NSManaged public var day: String?
    @NSManaged public var time: String?
    @NSManaged public var value: Int64
    @NSManaged public var timeIndex: String?
}
