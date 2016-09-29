//
//  MenuScene.swift
//  Demo
//
//  Created by Chenhao Wei on 20/08/16.
//  Copyright (c) 2016 WEI. All rights reserved.
//

import UIKit
import SpriteKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class ChangeSkinScene: SKScene {
	
	
	let userDefaults = UserDefaults.standard

	
	
	var count : Int?
	var soundToPlay: String?
	var Snake_with_Skin: SKSpriteNode?
	var Back_button: SKSpriteNode?
	//var skin: [String] = ["red","blue","green","America","Australia"]
	var left_button: SKSpriteNode?
	var right_button: SKSpriteNode?
	
	let Actionwhite = SKAction.colorize(with: SKColor.gray, colorBlendFactor: 1.0, duration: 0.5)
	let Actionbrown = SKAction.colorize(with: SKColor.brown, colorBlendFactor: 1.0, duration: 0.5)
	let Actionblue = SKAction.colorize(with: SKColor.blue, colorBlendFactor: 1.0, duration: 0.5)
	let Actionred = SKAction.colorize(with: SKColor.red, colorBlendFactor: 1.0, duration: 0.5)
	
	override func didMove(to view: SKView) {
		
		Snake_with_Skin = self.childNode(withName: "Snake_with_Skin") as? SKSpriteNode
		
		Back_button = self.childNode(withName: "Back_button") as? SKSpriteNode
		left_button = self.childNode(withName: "left_button") as? SKSpriteNode
		
		right_button = self.childNode(withName: "right_button") as? SKSpriteNode
		
		if let count_skinAnyobj = userDefaults.value(forKey: "skin") {
			let count_skin = count_skinAnyobj as! Int
			switch count_skin {
			case 0:
				Snake_with_Skin!.run(Actionred)
				count=count_skin
				break
			case 1:
				Snake_with_Skin!.run(Actionblue)
				count=count_skin
				break
			case 2:
				Snake_with_Skin!.run(Actionwhite)
				count=count_skin
				break
			default:
				Snake_with_Skin!.run(Actionbrown)
				count=count_skin
				break
			}
		}
		else {
			count=0
			Snake_with_Skin!.run(Actionwhite)
		}
		
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
			}else if left_button!.frame.contains(position) {
				
				
				count=(count!-1)
				
				if(count<0)
				{
				count=3
				}
				
				print(count)
				switch count! {
				case 0:
					Snake_with_Skin!.run(Actionred)
					userDefaults.setValue(count, forKey: "skin")
					userDefaults.synchronize() // don't forget this!!!!
					break
				case 1:
					Snake_with_Skin!.run(Actionblue)
					userDefaults.setValue(count, forKey: "skin")
					userDefaults.synchronize() // don't forget this!!!!
					break
				case 2:
					Snake_with_Skin!.run(Actionwhite)
					userDefaults.setValue(count, forKey: "skin")
					userDefaults.synchronize() // don't forget this!!!!
					break
				default:
					Snake_with_Skin!.run(Actionbrown)
					userDefaults.setValue(count, forKey: "skin")
					userDefaults.synchronize() // don't forget this!!!!
					break
				}
				
				
			}else if right_button!.frame.contains(position) {
				
				
				
				
				count=(count!+1)%4
				
				print(count)
				switch count! {
				case 0:
					Snake_with_Skin!.run(Actionred)
					
					userDefaults.setValue(count, forKey: "skin")
					userDefaults.synchronize() // don't forget this!!!!
				case 1:
					Snake_with_Skin!.run(Actionblue)
					userDefaults.setValue(count, forKey: "skin")
					userDefaults.synchronize() // don't forget this!!!!
				case 2:
					Snake_with_Skin!.run(Actionwhite)
					userDefaults.setValue(count, forKey: "skin")
					userDefaults.synchronize() // don't forget this!!!!
				default:
					Snake_with_Skin!.run(Actionbrown)
					userDefaults.setValue(count, forKey: "skin")
					userDefaults.synchronize() // don't forget this!!!!
				}
				
			
			}
		}
	}
	
}
