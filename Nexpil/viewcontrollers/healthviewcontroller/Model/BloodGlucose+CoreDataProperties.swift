//
//  BloodGlucose+CoreDataProperties.swift
//  
//
//  Created by Loyal Lauzier on 2018/06/05.
//
//

import Foundation
import CoreData


extension BloodGlucose {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BloodGlucose> {
        return NSFetchRequest<BloodGlucose>(entityName: "BloodGlucose")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var whenIndex: String
    @NSManaged public var strDate: String
    @NSManaged public var strWeek: String
    @NSManaged public var strMonth: String
    @NSManaged public var year: String
    @NSManaged public var month: String
    @NSManaged public var day: String
    @NSManaged public var value: Int64

}
