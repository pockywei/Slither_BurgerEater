//
//  MenuScene.swift
//  Demo
//
//  Created by Chenhao Wei on 20/08/16.
//  Copyright (c) 2016 WEI. All rights reserved.
//

import UIKit
import SpriteKit

class ChangeGameModelScene: SKScene {
	
	let userDefaults = NSUserDefaults.standardUserDefaults()
	var Snake_with_Skin: SKSpriteNode?
	var Back_button: SKSpriteNode?
	var Rocker_model: SKSpriteNode?
	var Arrow_model: SKSpriteNode?
	var Narmal_model: SKSpriteNode?

	//var Model: [String] = ["O","A","C"]
	
	
	override func didMoveToView(view: SKView) {
		
		
		
		Back_button = self.childNodeWithName("Back_button") as? SKSpriteNode
		
		Rocker_model = self.childNodeWithName("Rocker_model") as? SKSpriteNode
		
		Arrow_model = self.childNodeWithName("Arrow_model") as? SKSpriteNode
		
		Narmal_model = self.childNodeWithName("Narmal_model") as? SKSpriteNode
		
	}
	
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		for touch: AnyObject in touches {
			let position = touch.locationInNode(self) // Get the x,y point of the touch
			if CGRectContainsPoint(Back_button!.frame, position) {
				let mainScene = MainScene(fileNamed: "MainScene")
				//inputText?.hidden = true
				let transition = SKTransition.fadeWithDuration(1)
				let skView = self.view as SKView!
				mainScene?.scaleMode = .AspectFill
				dispatch_async(dispatch_get_main_queue(), {
					skView.presentScene(mainScene!, transition: transition)
				})
			}else if CGRectContainsPoint(Rocker_model!.frame, position) {
				userDefaults.setValue("Rocker_model", forKey: "model")
				userDefaults.synchronize() // don't forget this!!!!

				
				
			}else if CGRectContainsPoint(Arrow_model!.frame, position) {
				userDefaults.setValue("Arrow_model", forKey: "model")
				userDefaults.synchronize() // don't forget this!!!!

				
			}else if CGRectContainsPoint(Narmal_model!.frame, position) {
				userDefaults.setValue("Narmal_model", forKey: "model")
				userDefaults.synchronize() // don't forget this!!!!

			
			}
			
		}
	}
	
}
