//
//  Clipping+CoreDataProperties.swift
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

extension Clipping {

    @NSManaged var date_created: NSDate?
    @NSManaged var img: String?
    @NSManaged var notes: String?
    @NSManaged var owner: Collection?

}
