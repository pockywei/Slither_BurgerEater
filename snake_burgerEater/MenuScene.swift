//
//  MenuScene.swift
//  Demo
//
//  Created by Chenhao Wei on 20/08/16.
//  Copyright (c) 2016 WEI. All rights reserved.
//

import UIKit
import SpriteKit

class MenuScene: SKScene {
	
	var soundToPlay: String?
	var share = SKLabelNode()
	
	override func didMoveToView(view: SKView) {
		
		
		self.backgroundColor = SKColor(red: 0, green:0, blue:0, alpha: 1)
		
		
		
		// Setup label
		let label = SKLabelNode(text: "Press anywhere to play again!")
		label.fontName = "AvenirNext-Bold"
		label.fontSize = 55
		label.fontColor = UIColor.whiteColor()
		label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
		
		
		share = SKLabelNode(text: "Share to Twitter")
		share.fontName = "AvenirNext-Bold"
		share.fontSize = 55
		share.fontColor = UIColor.whiteColor()
		share.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+200)
		
		
		
		// Play sound
		if let soundToPlay = soundToPlay {
			self.runAction(SKAction.playSoundFileNamed(soundToPlay, waitForCompletion: false))
		}
		
		self.addChild(label)
		self.addChild(share)
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
		for touch in touches{
			let position = touch.locationInNode(self)
			if(CGRectContainsPoint(share.frame, position) ){
				NSNotificationCenter.defaultCenter().postNotificationName("WhateverYouCalledTheAlertInTheOtherLineOfCode", object: nil)
				print("touchesEnded")
				
			}else{
				let mainScene = MainScene(fileNamed: "MainScene")
				let transition = SKTransition.fadeWithDuration(1)
				let skView = self.view as SKView!
				mainScene?.scaleMode = .AspectFill
				
				skView.presentScene(mainScene!, transition: transition)
			}
			
		}
		
	}
	
}
