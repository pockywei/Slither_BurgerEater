//
//  ScrapbookModel.swift
//  ass2
//
//  Created by WEI on 15/9/13.
//  Copyright (c) 2015年 WEI. All rights reserved.
//

import UIKit
import CoreData
import Foundation
class ScrapbookModel{
	//Get a reference to the NSManagedObjectContext:
	let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

	func addentitys(){
		
		let person1: Collection = NSEntityDescription.insertNewObjectForEntityForName("Collection", inManagedObjectContext: managedObjectContext!) as! Collection
		
		person1.name = "Bruce"

		
		
		
		
		var error: NSError?
		if !managedObjectContext!.save(&error) {
			println("Could not save \(error), \(error?.userInfo)")
		}
		
		print(person1.name)
		//collection.append(collection)
	}
	
	init(){
		
	
	}
	// Do something with entities
	
}