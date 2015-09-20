//
//  CollectionListViewController.swift
//  ass2
//
//  Created by WEI on 15/9/18.
//  Copyright © 2015年 WEI. All rights reserved.
//

import Foundation
import UIKit

class CollectionListViewController:UITableViewController{
	var scrpbk = ScrapbookModel()
	var coll = [Collection]()
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		self.coll = scrpbk.return_all_collection()
		  navigationItem.leftBarButtonItem=editButtonItem()
		
	}
	@IBAction func add(sender: AnyObject) {
		
		
		
		var tField: UITextField!
		
		func configurationTextField(textField: UITextField!)
		{
			print("generating the TextField")
			textField.placeholder = "Enter an item"
			tField = textField
		}
		
		
		func handleCancel(alertView: UIAlertAction!)
		{
			print("Cancelled !!")
		}
		
		var alert = UIAlertController(title: "Enter Input", message: "", preferredStyle: UIAlertControllerStyle.Alert)
		
		alert.addTextFieldWithConfigurationHandler(configurationTextField)
		alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:handleCancel))
		alert.addAction(UIAlertAction(title: "Create", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
			print("Done !!")
			print("Item : \(tField.text)")
			
			if(tField.text != "All Clippings")
			{
			self.coll.append(self.scrpbk.addentitys(tField.text!))
			}
			
			self.tableView.reloadData()
			
			
		}))
		self.presentViewController(alert, animated: true, completion: {
			print("completion block")
		})
		
		
		
		
		
	}
	
	func handleCancel(alertView: UIAlertAction!)
	{
		print("User click Cancel button")
		//println(self.textField.text)
	}
	
	
	
	
	
	var clipping = [Clipping]()
	
	
	func loadCollection() {
		
		
		
		
		
		
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return coll.count
	}


	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		// Table view cells are reused and should be dequeued using a cell identifier.
		let cellIdentifier = "Cell_coll"
		let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) 
		//print(indexPath.length)
		// Fetches the appropriate meal for the data source layout.
		let meal = coll[indexPath.row]
		
		
		//print("dd")
		cell.textLabel!.text = meal.name
		
		
		
		
		return cell
	}

	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		if(indexPath.row != 0){
			return true
		}
		else
		{
			return false
		}
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle==UITableViewCellEditingStyle.Delete{
			scrpbk.deleteCollection(coll[indexPath.row])
			coll.removeAtIndex(indexPath.row)
			//tableView.reloadData()
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
		}
	}

	
	

	
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "coll2clip" {
			let mealDetailViewController = segue.destinationViewController as! UINavigationController
			let CollectionListController = mealDetailViewController.topViewController as! ClippingListViewController
			
			//let mealDetailViewController = segue.destinationViewController as! ClippingListViewController
			var collselect=""
			if let selectedMealCell = sender as? UITableViewCell {
				let indexPath = tableView.indexPathForCell(selectedMealCell)!
				collselect=selectedMealCell.textLabel!.text!
				print(selectedMealCell.textLabel!.text!)
				print("%%%%%%%%%%%%%%%%%%%%")
				let selectedMeal = coll[indexPath.row]
				CollectionListController.coll = selectedMeal
				
			}
			
			
			
			
			CollectionListController.loadColippings(collselect)
			// Get the cell that generated this segue.
			
			// Get the cell that generated this segue.
//			if let selectedMealCell = sender as? MealTableViewCell {
//				let indexPath = tableView.indexPathForCell(selectedMealCell)!
//				let selectedMeal = meals[indexPath.row]
//				mealDetailViewController.meal = selectedMeal
//			}
		}
		else if segue.identifier == "AddItem" {
			print("Adding new meal.")
		}
	}

	
	
	
	

}