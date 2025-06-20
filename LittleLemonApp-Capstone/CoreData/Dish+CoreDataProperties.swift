//
//  Dish+CoreDataProperties.swift
//  LittleLemonApp-Capstone
//
//  Created by Syed Ali Masood Bukhari on 19/06/2025.
//
//

import Foundation
import CoreData


extension Dish {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dish> {
        return NSFetchRequest<Dish>(entityName: "Dish")
    }

    @NSManaged public var image: String?
    @NSManaged public var price: String?
    @NSManaged public var title: String?
    @NSManaged public var dishDescription: String?
    @NSManaged public var category: String?

}

extension Dish : Identifiable {

}
