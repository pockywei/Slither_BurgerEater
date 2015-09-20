//
//  ClippingListViewController.swift
//  ass2
//
//  Created by WEI on 15/9/18.
//  Copyright © 2015年 WEI. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary

class ClippingListViewController: UITableViewController ,UISearchBarDelegate{
	
	
	
	var clipping = [Clipping]()
	
	@IBOutlet weak var searchbar: UISearchBar!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//self.clipping=scrpbk.return_all_clippings()
		searchbar.delegate = self
		//navigationItem.leftBarButtonItem=editButtonItem()
		self.tableView.reloadData()
		
	}
	
	@IBAction func back(sender: AnyObject) {
		let isPresentingInAddMealMode = presentingViewController is UINavigationController
		
		if isPresentingInAddMealMode {
			dismissViewControllerAnimated(true, completion: nil)
		} else {
			navigationController!.popViewControllerAnimated(true)
		}
		
	}
	
	// MARK: Properties
	var scrpbk = ScrapbookModel()
	
	
	
	func loadColippings(collselect:String){
		
		if collselect == "All Clippings"
		{
			clipping=scrpbk.return_all_clippings()
		}else{
			for var i=0;i<scrpbk.return_all_clippings().count;i++
			{
				if(scrpbk.return_all_clippings()[i].owner?.name==collselect)
				{
					clipping.append(scrpbk.return_all_clippings()[i])
					print(collselect)
					//print(clipping[j].owner?.name)
					//print(scrpbk.return_all_clippings()[i].owner)
					
				}
			}
			
		}
		
		
		
		
	}
	var searchActive : Bool = false
	var filtered = [Clipping]()
	
	func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
		searchActive = true;
	}
	
	func searchBarTextDidEndEditing(searchBar: UISearchBar) {
		searchActive = false;
	}
	
	func searchBarCancelButtonClicked(searchBar: UISearchBar) {
		searchActive = false;
	}
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		searchActive = false;
	}
	
	func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
		
		
		filtered = scrpbk.Search(searchText)
		if(filtered.count == 0){
			searchActive = false;
		} else {
			searchActive = true;
		}
		self.tableView.reloadData()
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if(searchActive) {
			return filtered.count
		}
		
		return clipping.count
		
	}
	
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		// Table view cells are reused and should be dequeued using a cell identifier.
		var j=0
		let cellIdentifier = "cell_of_clips"
		let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
		//print(indexPath.row)
		// Fetches the appropriate meal for the data source layout.
		
		//
		//print(j)
		print(indexPath.length)
		print(clipping.count)
		
		for (var i=0;i<clipping.count;i++)
		{
			print(clipping[i].notes)
		}
		if clipping.count != 0
		{
			
			if(searchActive){
				let meal = filtered[indexPath.row]
				cell.textLabel!.text = meal.notes
				//cell.imageView?.image=UIImage(named: meal.img!)
				
				let url = NSURL(string: meal.img!)
				let assetsLibrary = ALAssetsLibrary()
				var loadError: NSError?
				assetsLibrary.assetForURL(url, resultBlock: { (asset) -> Void in
					cell.imageView!.image = UIImage(CGImage: asset.defaultRepresentation().fullResolutionImage().takeUnretainedValue())
					}, failureBlock: { (error) -> Void in
						loadError = error;
				})
				
			} else {
				
				//print(clipping[j].owner?.name)
				let meal = clipping[indexPath.row]
				cell.textLabel!.text = meal.notes
				//cell.imageView?.image=UIImage(named: meal.img!)
				
				let url = NSURL(string: meal.img!)
				
				
				let assetsLibrary = ALAssetsLibrary()
				var loadError: NSError?
				assetsLibrary.assetForURL(url, resultBlock: { (asset) -> Void in
					if let cells = cell.imageView{
					cells.image = UIImage(CGImage: asset.defaultRepresentation().fullResolutionImage().takeUnretainedValue())
					}
					}, failureBlock: { (error) -> Void in
						loadError = error;
				})
			}
		}
		
		//print("dd")
		
		
		
		
		
		return cell
	}
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		
			return true
		
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle==UITableViewCellEditingStyle.Delete{
			if(searchActive){
			scrpbk.deleteClip(filtered[indexPath.row])
				filtered.removeAtIndex(indexPath.row)
			}
			else{
			scrpbk.deleteClip(clipping[indexPath.row])
				clipping.removeAtIndex(indexPath.row)
			}
			
			//tableView.reloadData()
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
		}
	}
	
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
			if segue.identifier == "show_clipdetail" {
				let view = segue.destinationViewController as! UINavigationController
				let mealDetailViewController = view.topViewController as! ClippingDetailViewController
				
				// Get the cell that generated this segue.
				if let selectedMealCell = sender as? UITableViewCell {
					let indexPath = tableView.indexPathForCell(selectedMealCell)!
					if(searchActive){
					let selectedMeal = filtered[indexPath.row]
						mealDetailViewController.clip = selectedMeal
						mealDetailViewController
					}
					else{
						let selectedMeal = clipping[indexPath.row]
						mealDetailViewController.clip = selectedMeal
					}
					
					
					
				}
			}
		else if segue.identifier == "AddItem" {
			print("Adding new meal.")
		}
	}
	
	@IBAction func unwindToMealList(sender: UIStoryboardSegue) {
		if let sourceViewController = sender.sourceViewController as? createClipping, clip_temp = sourceViewController.clip {
			let newIndexPath = NSIndexPath(forRow: clipping.count, inSection: 0)
			clipping.append(clip_temp)
			tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
		}
	}
	
	
	
}