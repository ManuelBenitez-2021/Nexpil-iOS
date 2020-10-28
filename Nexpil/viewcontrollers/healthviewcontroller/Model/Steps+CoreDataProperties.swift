//
//  Steps+CoreDataProperties.swift
//  
//
//  Created by Loyal Lauzier on 2018/06/11.
//
//

import Foundation
import CoreData


extension Steps {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Steps> {
        return NSFetchRequest<Steps>(entityName: "Steps")
    }

    @NSManaged public var date: Date?
    @NSManaged public var day: String?
    @NSManaged public var month: String?
    @NSManaged public var week: String?
    @NSManaged public var year: String?
    @NSManaged public var strDate: String?
    @NSManaged public var strWeek: String?
    @NSManaged public var strMonth: String?
    @NSManaged public var value: Double

}
