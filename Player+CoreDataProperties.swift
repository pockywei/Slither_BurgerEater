//
//  Player+CoreDataProperties.swift
//  snake_burgerEater
//
//  Created by WEI on 9/19/16.
//  Copyright © 2016 WEI. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Player {

    @NSManaged var userName: String?
    @NSManaged var score: NSNumber?
    @NSManaged var skin: String?

}
