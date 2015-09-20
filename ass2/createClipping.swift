//
//  createClipping.swift
//  ass2
//
//  Created by WEI on 15/9/19.
//  Copyright © 2015年 WEI. All rights reserved.
//

import Foundation
import UIKit
class createClipping:UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
	
	@IBOutlet weak var notes: UITextField!
	@IBOutlet weak var save: UIBarButtonItem!
	
	@IBOutlet weak var imgview: UIImageView!
	
	var clip : Clipping?
	@IBAction func Back(sender: AnyObject) {
		let isPresentingInAddMealMode = presentingViewController is UINavigationController
		
		
		if isPresentingInAddMealMode {
			dismissViewControllerAnimated(true, completion: nil)
		} else {
			navigationController!.popViewControllerAnimated(true)
		}
	}
	
	@IBAction func save_press(sender: AnyObject) {
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.imgview.userInteractionEnabled = true
		var tapGesture = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
		imgview.addGestureRecognizer(tapGesture)
		save.enabled = false
		notes.delegate = self
		
		
		
	}
	func handleTap(sender : UIImageView) {
		
		print("Tap Gesture recognized")
		let imagePickerController = UIImagePickerController()
		
		// Only allow photos to be picked, not taken.
		imagePickerController.sourceType = .PhotoLibrary
		
		// Make sure ViewController is notified when the user picks an image.
		imagePickerController.delegate = self
		
		presentViewController(imagePickerController, animated: true, completion: nil)
 }
	
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		// Hide the keyboard.
		textField.resignFirstResponder()
		return true
		
		
	}
	
	func textFieldDidEndEditing(textField: UITextField) {
		checkValidMealName()
		//navigationItem.title = textField.text
	}
	
	
	func textFieldDidBeginEditing(textField: UITextField) {
		// Disable the Save button while editing.
		save.enabled = true
	}
	
	func checkValidMealName() {
		// Disable the Save button if the text field is empty.
		let text = notes.text ?? ""
		save.enabled = !text.isEmpty
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		// Dismiss the picker if the user canceled.
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		// The info dictionary contains multiple representations of the image, and this uses the original.
		let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
		
		// Set photoImageView to display the selected image.
		imgview.image = selectedImage
		
		// Dismiss the picker.
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if save === sender {
			let note = notes.text ?? ""
			let photo = imgview.image
			let date = NSDate()
			// Set the meal to be passed to MealListTableViewController after the unwind segue.
			clip?.notes=note
			//clip?.img = imgview.image
			clip?.date_created = date
		}
	}
	
	
	
	
}
