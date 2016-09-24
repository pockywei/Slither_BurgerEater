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
	
	
	
	var change_mode = SKShapeNode(circleOfRadius:50)
	
	
	var change_skin = SKShapeNode(circleOfRadius:50)
	
	override func didMoveToView(view: SKView) {
		
		
		
		
		
		inputText = UITextField(frame: CGRect(x:105,y:420,width:200,height:40))//如何居中
		self.view!.addSubview(inputText!)
		inputText!.backgroundColor = UIColor.whiteColor()
		inputText!.placeholder="Username"
		
		
		
		Play_ai = SKLabelNode(fontNamed: "Chalkduster")
		Play_ai.text = "Play with AI"
		Play_ai.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
		addChild(Play_ai)
		
		Multi_mode = SKLabelNode(fontNamed: "Chalkduster")
		Multi_mode.text = "Online Game"
		Multi_mode.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)+150)
		addChild(Multi_mode)
		
		
		
		change_mode.position = CGPoint(x: CGRectGetMinX(self.frame)+85, y: CGRectGetMinY(self.frame)+85)
		change_mode.fillColor = UIColor.whiteColor()
		addChild(change_mode)
		
		
		
		change_skin.position = CGPoint(x: CGRectGetMaxX(self.frame)-100, y: CGRectGetMinY(self.frame)+85)
		change_skin.fillColor = UIColor.whiteColor()
		addChild(change_skin)
		
		
		
		
		
	}
	
	
//	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)  {
//		/* Called when a touch begins */
//		
//		for touch: AnyObject in touches {
//			let position = touch.locationInNode(self) // Get the x,y point of the touch
//			if CGRectContainsPoint(aButton.frame, position) { // Detect if that point is inside our button
//				let gameScene = GameScene(size: self.frame.size) //Replace here with the target scene
//				self.view?.presentScene(gameScene, transition: SKTransition.doorsCloseHorizontalWithDuration(0.35)) // Performs the transition of scene if the button was touch
//			}
//		}
//	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		for touch: AnyObject in touches {
			let position = touch.locationInNode(self) // Get the x,y point of the touch
			if CGRectContainsPoint(Play_ai.frame, position) {
				let gameScene = GameScene(fileNamed: "GameScene")
				inputText?.hidden = true
				let transition = SKTransition.fadeWithDuration(1)
				let skView = self.view as SKView!
				gameScene?.scaleMode = .AspectFill
				dispatch_async(dispatch_get_main_queue(), { 
					skView.presentScene(gameScene!, transition: transition)
				})
				
			}else if CGRectContainsPoint(change_skin.frame, position) {
				let changeSkinScene = ChangeSkinScene(fileNamed: "ChangeSkinScene")
				inputText?.hidden = true
				let transition = SKTransition.fadeWithDuration(1)
				let skView = self.view as SKView!
				changeSkinScene?.scaleMode = .AspectFill
				dispatch_async(dispatch_get_main_queue(), {
					skView.presentScene(changeSkinScene!, transition: transition)
				})
			
			}else if CGRectContainsPoint(change_mode.frame, position) {
				let changeGameModelScene = ChangeGameModelScene(fileNamed: "ChangeGameModelScene")
				inputText?.hidden = true
				let transition = SKTransition.fadeWithDuration(1)
				let skView = self.view as SKView!
				changeGameModelScene?.scaleMode = .AspectFill
				dispatch_async(dispatch_get_main_queue(), {
					skView.presentScene(changeGameModelScene!, transition: transition)
				})
			}
		}
	}
	
	
	
}