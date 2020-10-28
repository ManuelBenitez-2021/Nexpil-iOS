//
//  StepsHour+CoreDataProperties.swift
//  
//
//  Created by Loyal Lauzier on 2018/06/26.
//
//

import Foundation
import CoreData


extension StepsHour {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StepsHour> {
        return NSFetchRequest<StepsHour>(entityName: "StepsHour")
    }

    @NSManaged public var date: Date?
    @NSManaged public var value: Int64
    @NSManaged public var strHour: String?
    @NSManaged public var strDate: String?
    @NSManaged public var hour: String?

}
