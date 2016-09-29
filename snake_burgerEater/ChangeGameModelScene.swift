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
	
	let userDefaults = UserDefaults.standard
	var Snake_with_Skin: SKSpriteNode?
	var Back_button: SKSpriteNode?
	var Rocker_model: SKSpriteNode?
	var Arrow_model: SKSpriteNode?
	var Narmal_model: SKSpriteNode?

	//var Model: [String] = ["O","A","C"]
	
	
	override func didMove(to view: SKView) {
		
		
		
		Back_button = self.childNode(withName: "Back_button") as? SKSpriteNode
		
		Rocker_model = self.childNode(withName: "Rocker_model") as? SKSpriteNode
		
		Arrow_model = self.childNode(withName: "Arrow_model") as? SKSpriteNode
		
		Narmal_model = self.childNode(withName: "Narmal_model") as? SKSpriteNode
		
	}
	
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch: AnyObject in touches {
			let position = touch.location(in: self) // Get the x,y point of the touch
			if Back_button!.frame.contains(position) {
				let mainScene = MainScene(fileNamed: "MainScene")
				//inputText?.hidden = true
				let transition = SKTransition.fade(withDuration: 1)
				let skView = self.view as SKView!
				mainScene?.scaleMode = .aspectFill
				DispatchQueue.main.async(execute: {
					skView?.presentScene(mainScene!, transition: transition)
				})
			}else if Rocker_model!.frame.contains(position) {
				userDefaults.setValue("Rocker_model", forKey: "model")
				userDefaults.synchronize() // don't forget this!!!!

				
				
			}else if Arrow_model!.frame.contains(position) {
				userDefaults.setValue("Arrow_model", forKey: "model")
				userDefaults.synchronize() // don't forget this!!!!

				
			}else if Narmal_model!.frame.contains(position) {
				userDefaults.setValue("Narmal_model", forKey: "model")
				userDefaults.synchronize() // don't forget this!!!!

			
			}
			
		}
	}
	
}
