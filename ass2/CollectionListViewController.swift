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
	var clipping = [Clipping]()
	
	
	func loadCollection() {
		
		coll = scrpbk.return_all_collection()
		
		
		
		
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return coll.count
	}


	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		// Table view cells are reused and should be dequeued using a cell identifier.
		let cellIdentifier = "Cell_coll"
		let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) 
		
		// Fetches the appropriate meal for the data source layout.
		let meal = coll[indexPath.row]
		
		
		print("dd")
		cell.textLabel!.text = meal.name
		
		
		
		
		return cell
	}

	
	
	
	

}