//
//  LipidPanel+CoreDataProperties.swift
//  
//
//  Created by Loyal Lauzier on 2018/06/10.
//
//

import Foundation
import CoreData


extension LipidPanel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LipidPanel> {
        return NSFetchRequest<LipidPanel>(entityName: "LipidPanel")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var value: NSInteger
    @NSManaged public var day: String?
    @NSManaged public var month: String?
    @NSManaged public var year: String?
    @NSManaged public var strDate: String?
    @NSManaged public var strMonth: String?
    @NSManaged public var index: String?

}
