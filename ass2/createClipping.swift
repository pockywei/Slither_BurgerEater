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
	var scrk = ScrapbookModel()
	var coll : Collection?
	@IBOutlet weak var notes: UITextField!
	@IBOutlet weak var save: UIBarButtonItem!
	
	@IBOutlet weak var imgview: UIImageView!
	var imageurl : NSURL?
	
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
		if let note = notes.text{
			
			 scrk.addentity2(imageurl!.absoluteString, Des: note)
		}
		
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
		imageurl = info[UIImagePickerControllerReferenceURL] as? NSURL
		let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
		
		// Set photoImageView to display the selected image.
		imgview.image = selectedImage
		
		// Dismiss the picker.
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if save === sender {
			if let notes = notes.text {
				if let image = imageurl {
					clip = scrk.addentity2(image.absoluteString, Des: notes)
					scrk.add_Clip2Collection(clip!,coll: coll!)
				}
			}
		}
	}
	
	
	
	
}
