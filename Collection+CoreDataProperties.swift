//
//  Collection+CoreDataProperties.swift
//  ass2
//
//  Created by WEI on 15/9/17.
//  Copyright © 2015年 WEI. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Collection {

    @NSManaged var name: String?
    @NSManaged var clipping: NSSet?

}
