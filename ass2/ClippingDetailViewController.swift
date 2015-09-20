//
//  ClippingDetailViewController.swift
//  ass2
//
//  Created by WEI on 15/9/19.
//  Copyright © 2015年 WEI. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary

class ClippingDetailViewController:UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
	var scrack = ScrapbookModel()
	var clip : Clipping?

	
	
	
	@IBOutlet weak var date: UILabel!
	@IBOutlet weak var clip_img: UIImageView!
	@IBOutlet weak var clip_text: UITextView!
	@IBAction func backicon(sender: AnyObject) {
		let isPresentingInAddMealMode = presentingViewController is UINavigationController
		
		if isPresentingInAddMealMode {
			dismissViewControllerAnimated(true, completion: nil)
		} else {
			navigationController!.popViewControllerAnimated(true)
		}

		
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		if let meal = clip {
			
			clip_img.image = UIImage(named: meal.img!)
			
			let url = NSURL(string: meal.img!)
			let assetsLibrary = ALAssetsLibrary()
			var loadError: NSError?
			assetsLibrary.assetForURL(url, resultBlock: { (asset) -> Void in
				self.clip_img.image = UIImage(CGImage: asset.defaultRepresentation().fullResolutionImage().takeUnretainedValue())
				}, failureBlock: { (error) -> Void in
					loadError = error;
			})
			
			
			clip_text.text = meal.notes
			
			
			let dateFormatter=NSDateFormatter()
			
			
			dateFormatter.dateFormat="MM/dd/yyyy"
			
			
			date.text = dateFormatter.stringFromDate((meal.date_created)!)
			
		}
		// Handle the text field’s user input through delegate callbacks.
		
	}
	

	
	
	

}