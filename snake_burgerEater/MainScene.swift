//
//  MainScene.swift
//  snake_burgerEater
//
//  Created by WEI on 9/19/16.
//  Copyright © 2016 WEI. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
class MainScene:SKScene {
	
	var inputText:UITextField?
	
	
	var Play_ai: SKLabelNode!
	
	var Multi_mode: SKLabelNode!
	
	var kbframe : CGRect?
	
	var change_mode = SKSpriteNode()
	
	
	var change_skin = SKSpriteNode()
	
	override func didMove(to view: SKView) {
		
		
//		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainScene.dismissKeyboard))
//		view.addGestureRecognizer(tap)
	
	
		
		// in your viewDidLoad:
		
//		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification,object: nil)
//		
//		// later in your class:
//		
//		func keyboardWillShow(notification: NSNotification) {
//			kbframe = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
//			// do stuff with the frame...
//			
//		}
		
		
		
		
		change_skin = self.childNode(withName: "change_skin") as! SKSpriteNode
		change_mode = self.childNode(withName: "setting") as! SKSpriteNode
		
		
		
		
		inputText = UITextField(frame: CGRect(x:85,y:320,width:200,height:40))//如何居中
		self.view!.addSubview(inputText!)
		inputText!.backgroundColor = UIColor.white
		inputText!.placeholder="Username"
		
		
		
		Play_ai = SKLabelNode(fontNamed: "Chalkduster")
		Play_ai.text = "Play with AI"
		Play_ai.position = CGPoint(x: self.frame.midX, y: self.frame.midY-300)
		addChild(Play_ai)
		
		Multi_mode = SKLabelNode(fontNamed: "Chalkduster")
		Multi_mode.text = "Online Game"
		
		Multi_mode.position = CGPoint(x: self.frame.midX, y: self.frame.midY-450)
		addChild(Multi_mode)
	
		
		
		
	}
	
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)  {
		/* Called when a touch begins */
		 view!.endEditing(true)
//		for touch: AnyObject in touches {
//			let position = touch.locationInNode(self) // Get the x,y point of the touch
//			if CGRectContainsPoint(aButton.frame, position) { // Detect if that point is inside our button
//				let gameScene = GameScene(size: self.frame.size) //Replace here with the target scene
//				self.view?.presentScene(gameScene, transition: SKTransition.doorsCloseHorizontalWithDuration(0.35)) // Performs the transition of scene if the button was touch
//			}
//		}
	}



	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch: AnyObject in touches {
			let position = touch.location(in: self) // Get the x,y point of the touch
			if Play_ai.frame.contains(position) {
				let gameScene = GameScene(fileNamed: "GameScene")
				inputText?.isHidden = true
				let transition = SKTransition.fade(withDuration: 1)
				let skView = self.view as SKView!
				gameScene?.scaleMode = .aspectFill
				DispatchQueue.main.async(execute: { 
					skView?.presentScene(gameScene!, transition: transition)
				})
				
			}else if change_skin.frame.contains(position) {
				let changeSkinScene = ChangeSkinScene(fileNamed: "ChangeSkinScene")
				inputText?.isHidden = true
				let transition = SKTransition.fade(withDuration: 1)
				let skView = self.view as SKView!
				changeSkinScene?.scaleMode = .aspectFill
				DispatchQueue.main.async(execute: {
					skView?.presentScene(changeSkinScene!, transition: transition)
				})
			
			}else if change_mode.frame.contains(position) {
				let changeGameModelScene = ChangeGameModelScene(fileNamed: "ChangeGameModelScene")
				inputText?.isHidden = true
				let transition = SKTransition.fade(withDuration: 1)
				let skView = self.view as SKView!
				changeGameModelScene?.scaleMode = .aspectFill
				DispatchQueue.main.async(execute: {
					skView?.presentScene(changeGameModelScene!, transition: transition)
				})
			}
		}
	}
	
	func dismissKeyboard() {
		//Causes the view (or one of its embedded text fields) to resign the first responder status.
		view!.endEditing(true)
	}
	
	
	
}
