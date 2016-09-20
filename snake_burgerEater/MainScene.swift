//
//  MainScene.swift
//  snake_burgerEater
//
//  Created by WEI on 9/19/16.
//  Copyright © 2016 WEI. All rights reserved.
//

import Foundation
import SpriteKit

class MainScene:SKScene {
	
	var inputText:UITextField?
	var aButton = SKShapeNode(circleOfRadius:50) //改成方形
	
	
	override func didMoveToView(view: SKView) {
		
		
		inputText = UITextField(frame: CGRect(x:105,y:420,width:200,height:40))//如何居中
		self.view!.addSubview(inputText!)
		inputText!.backgroundColor = UIColor.whiteColor()
		inputText!.placeholder="Username"
		
		aButton.fillColor = SKColor.redColor()
		aButton.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
		sleep(1/2)
		
		self.addChild(aButton)
		
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
			if CGRectContainsPoint(aButton.frame, position) {
				let gameScene = GameScene(fileNamed: "GameScene")
				inputText?.hidden = true
				let transition = SKTransition.fadeWithDuration(1)
				let skView = self.view as SKView!
				gameScene?.scaleMode = .AspectFill
				skView.presentScene(gameScene!, transition: transition)
				
			}
		}
	}
	
	
	
}