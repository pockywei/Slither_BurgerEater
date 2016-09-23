//
//  MenuScene.swift
//  Demo
//
//  Created by Chenhao Wei on 20/08/16.
//  Copyright (c) 2016 WEI. All rights reserved.
//

import UIKit
import SpriteKit

class ChangeSkinScene: SKScene {
	
	var soundToPlay: String?
	var Snake_with_Skin: SKSpriteNode?
	var Back_button: SKSpriteNode?
	
	
	override func didMoveToView(view: SKView) {
		
		Snake_with_Skin = self.childNodeWithName("Snake_with_Skin") as? SKSpriteNode
		
		Back_button = self.childNodeWithName("Back_button") as? SKSpriteNode
		
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
			}
		}
	}
	
}
