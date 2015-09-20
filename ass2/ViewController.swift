//
//  ViewController.swift
//  ass2
//
//  Created by WEI on 15/9/13.
//  Copyright (c) 2015年 WEI. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
	
	override func viewDidLoad() {
		print("Task 2")
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		
		let collection_arr = ScrapbookModel()
		
		
		//Create two Collections (named “A” and “B”)
		
		//collection_arr.addentitys("All Clippings")
		//let As:Collection = collection_arr.addentitys("A")
		//var Bs:Collection = collection_arr.addentitys("B")
		
//		print("Task 3")
//
//		let Clips1:Clipping=collection_arr.addentity2("sam.png",Des: "1 foo")
//		let Clips2:Clipping=collection_arr.addentity2("sam.png",Des: "2 foo")
//		var Clips3:Clipping=collection_arr.addentity2("sam.png",Des: "3 bar")
//
//		
//		
//		//Create three Clippings (with note values: “1 foo”, “2 foo” and “3 bar” respectively, use images of
//		//	your choice)
//		
//		
//		//		collection_arr.addentitys(variableString)
//		//		collection_arr.addentitys(variableString)
//		//		collection_arr.addentitys(variableString)
//		print("Task 4 Print a list of all coll")
//
//		for var i=0;i<collection_arr.return_all_collection().count;i++
//		{
//			print(collection_arr.return_all_collection()[i].name)
//		}
//		
//		print("Task 5 all clippings")
//
//		
//		for var i=0;i<collection_arr.return_all_clippings().count;i++
//		{
//			print(collection_arr.return_all_clippings()[i].notes)
//			print(collection_arr.return_all_clippings()[i].date_created)
//		}
//		
//		//		6) Add Clipping 1 and Clipping 2 to Collection A.
//		print("6) Add Clipping 1 and Clipping 2 to Collection A.")
//
//		collection_arr.add_Clip2Collection(Clips1, coll: As)
//		collection_arr.add_Clip2Collection(Clips2, coll: As)
//		//		7) Print all of Clippings contained in Collection A (There should be 2 clippings printed)
//		
//		print("7) Print all of Clippings contained in Collection A (There should be 2 clippings printed)")
//		for var i=0;i<collection_arr.return_all_clippings().count;i++
//		{
//			if collection_arr.return_all_clippings()[i].owner?.name=="A"{
//			print(collection_arr.return_all_clippings()[i].notes)
//			print(collection_arr.return_all_clippings()[i].date_created)
//			}
//		}
		
		//		8) Delete Clipping 1
		print("8) Delete Clipping 1")

		//collection_arr.deleteClip(Clips1)
		//		9) Print all of Clippings contained in Collection A (Only Clipping 2 should be printed)
		
		print("9) Print all of Clippings contained in Collection A (Only Clipping 2 should be printed)")


//		for var i=0;i<collection_arr.return_all_clippings().count;i++
//		{
//			if collection_arr.return_all_clippings()[i].owner?.name=="A"{
//			print(collection_arr.return_all_clippings()[i].notes)
//			print(collection_arr.return_all_clippings()[i].date_created)
//			}
//		}
		//		10) Search for and print all clippings that contain the search term “bar”
		
		print("10) Search for and print all clippings that contain the search term 'bar'")
		
//		let clipsearchall:[Clipping]=collection_arr.Search("bar")
//		
//		for var i=0;i<clipsearchall.count;i++
//		{
//			print(clipsearchall[i].notes)
//		}
		//		11) Kill the application process and relaunch the application and determine if the search term “bar”
		//		shows the same results
		
//		for var i=0;i<collection_arr.return_all_clippings().count;i++
//		{
//			collection_arr.deleteClip(collection_arr.return_all_clippings()[i])
//		}
//		
//		for var i=0;i<collection_arr.return_all_collection().count;i++
//		{
//			collection_arr.deleteCollection(collection_arr.return_all_collection()[i])
//		}
		
		//collection_arr.deleteCoreDataObjects_clippings()
		//collection_arr.deleteCoreDataObjects_collection()

		let timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timeToMoveOn", userInfo: nil, repeats: false)
	
	}
	
	override func didReceiveMemoryWarning() {
				super.didReceiveMemoryWarning()
				// Dispose of any resources that can be recreated.
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		let mealDetailViewController = segue.destinationViewController as! UINavigationController
		let CollectionListController = mealDetailViewController.topViewController as! CollectionListViewController
		
		CollectionListController.loadCollection()
		
		// Get the cell that generated this segue.
		
		
		
		
	}
	
	func timeToMoveOn() {
		self.performSegueWithIdentifier("goToMainUI", sender: self)
	}
	
	
}

