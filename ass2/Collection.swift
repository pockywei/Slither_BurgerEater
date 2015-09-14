//
//  Collection.swift
//  ass2
//
//  Created by WEI on 15/9/13.
//  Copyright (c) 2015年 WEI. All rights reserved.
//

import Foundation
import CoreData

class Collection: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var clipping: NSSet

}
