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
	
	var CollectionArray:Array<Collection>?
	//Get a reference to the NSManagedObjectContext:
	let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
	
	
	let AppDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	
	

	func addentitys(s:String)->Collection{
		
		let person1: Collection = NSEntityDescription.insertNewObjectForEntityForName("Collection", inManagedObjectContext: moc!) as! Collection
		
		person1.name = s

		
		
		
		
		var error: NSError?
		do {
			try moc!.save()
		} catch let error1 as NSError {
			error = error1
			print("Could not save \(error), \(error?.userInfo)")
		}
		
		//print(person1.name, terminator: "")
		//collection.append(collection)
		
		return person1
	}
	
	func return_all_collection()->[Collection]{
		
				let request = NSFetchRequest(entityName: "Collection")
		
		
		var locations  = [Collection]() // Where Locations = your NSManaged Class
		
		do {
			locations = try moc!.executeFetchRequest(request) as! [Collection]
			// success ...
		} catch let error as NSError {
			// failure
			print("Fetch failed: \(error.localizedDescription)")
		}
		
		return locations
		
	}
	
	
	func return_all_clippings()->[Clipping]{
		
		let request = NSFetchRequest(entityName: "Clipping")
		
		
		var locations  = [Clipping]() // Where Locations = your NSManaged Class
		
		do {
			locations = try moc!.executeFetchRequest(request) as! [Clipping]
			// success ...
		} catch let error as NSError {
			// failure
			print("Fetch failed: \(error.localizedDescription)")
		}
		
		return locations
		
	}
	
	func addentity2(imgs:String,Des:String)->Clipping{
	
		
		let C1: Clipping = NSEntityDescription.insertNewObjectForEntityForName("Clipping", inManagedObjectContext: moc!) as! Clipping
		
		C1.img = imgs
		C1.notes = Des;
		C1.date_created = NSDate()
		
		var error: NSError?
		do {
			try moc!.save()
		} catch let error1 as NSError {
			error = error1
			print("Could not save \(error), \(error?.userInfo)")
		}
		
		//print(C1.notes, terminator: "")
		
		return C1
	}
	
	func add_Clip2Collection(clip:Clipping,coll:Collection){
		clip.owner=coll
		var error: NSError?
		do {
			try moc!.save()
		} catch let error1 as NSError {
			error = error1
			print("Could not save \(error), \(error?.userInfo)")
		}
		
	}
	
	func deleteCollection(coll:Collection){
		print("in delete coll")
		moc!.deleteObject(coll)
		var error: NSError?
		do {
			try moc!.save()
		} catch let error1 as NSError {
			error = error1
			print("Could not save \(error), \(error?.userInfo)")
		}
		
	}
	
	func deleteClip(clip:Clipping){
		print("in delete colippling")
		moc!.deleteObject(clip)
		var error: NSError?
		do {
			try moc!.save()
		} catch let error1 as NSError {
			error = error1
			print("Could not save \(error), \(error?.userInfo)")
		}
	}
	
	func Search(searchKEYWORD:String)->[Clipping]{
		
		let fetchRequest = NSFetchRequest(entityName: "Clipping")
		let predicate = NSPredicate(format: "notes contains[cd] %@", searchKEYWORD)
		fetchRequest.predicate = predicate
		var fetchedCones=[Clipping]()
		do {
			fetchedCones = try self.moc!.executeFetchRequest(fetchRequest) as! [Clipping]
			//print("Number of Cones without someone to eat them: " + String(fetchedCones.count))
			
		} catch {
			print("Error in the fetch")
			
		}
		
		
		return fetchedCones
	
	}
	
	func Search_in_coll(searchKEYWORD:String,coll:Collection)->[Clipping]{
		
		let fetchRequest = NSFetchRequest(entityName: "Clipping")
		
		var fetchedresult = [Clipping]()
		var fetchedCones = [Clipping]()
		let predicate = NSPredicate(format: "notes contains[cd] %@", searchKEYWORD)
		fetchRequest.predicate = predicate
		
		do {
			fetchedCones = try self.moc!.executeFetchRequest(fetchRequest) as! [Clipping]
			print("Number of Cones without someone to eat them: " + String(fetchedCones.count))
			
			
		} catch {
			print("Error in the fetch")
			
		}
		
		for var i=0;i<fetchedCones.count;i++
		{
			if fetchedCones[i].owner == coll
			{
				fetchedresult[i]=fetchedCones[i]
			}
			
		}
		
		return fetchedresult
		
	}

	func deleteCoreDataObjects_clippings(){
		let request = NSFetchRequest(entityName: "Clipping")
		request.returnsObjectsAsFaults = false
		
		var fetchedCones = [Clipping]()
		
		do {
			fetchedCones = try self.moc!.executeFetchRequest(request) as! [Clipping]
			//print("Number of Cones without someone to eat them: " + String(fetchedCones.count))
			
		} catch {
			print("Error in the fetch")
			
		}
		
		
		if fetchedCones.count > 0 {
			
			for result: AnyObject in fetchedCones{
				
				
				moc!.deleteObject(result as! NSManagedObject)
				print("NSManagedObject has been Deleted")
			}
			
			var error: NSError?
			do {
				try moc!.save()
			} catch let error1 as NSError {
				error = error1
				print("Could not save \(error), \(error?.userInfo)")
			}
		}
	}
	
	func deleteCoreDataObjects_collection(){
		let request = NSFetchRequest(entityName: "Collection")
		request.returnsObjectsAsFaults = false
		
		var fetchedCones = [Collection]()
		
		do {
			fetchedCones = try self.moc!.executeFetchRequest(request) as! [Collection]
			//print("Number of Cones without someone to eat them: " + String(fetchedCones.count))
			
		} catch {
			print("Error in the fetch")
			
		}
		
		
		if fetchedCones.count > 0 {
			
			for result: AnyObject in fetchedCones{
				
				
				moc!.deleteObject(result as! NSManagedObject)
				print("NSManagedObject has been Deleted")
			}
			
			var error: NSError?
			do {
				try moc!.save()
			} catch let error1 as NSError {
				error = error1
				print("Could not save \(error), \(error?.userInfo)")
			}
		}
	}
	
	init(){
		
	
	}
	// Do something with entities
	
	
	
}