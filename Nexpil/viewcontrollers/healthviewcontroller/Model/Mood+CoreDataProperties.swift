//
//  Mood+CoreDataProperties.swift
//  
//
//  Created by Loyal Lauzier on 2018/06/04.
//
//

import Foundation
import CoreData


extension Mood {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mood> {
        return NSFetchRequest<Mood>(entityName: "Mood")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var feeling: Int64
    @NSManaged public var notes: String?
    @NSManaged public var strDate: String?

}
