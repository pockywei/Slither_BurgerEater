//
//  Clipping.swift
//  ass2
//
//  Created by WEI on 15/9/13.
//  Copyright (c) 2015年 WEI. All rights reserved.
//

import Foundation
import CoreData

class Clipping: NSManagedObject {

    @NSManaged var date_created: NSDate
    @NSManaged var img: String
    @NSManaged var notes: String
    @NSManaged var owner: Collection

}
