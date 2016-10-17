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
	
	
	let userDefaults = NSUserDefaults.standardUserDefaults()

	
	
	var count : Int?
	var soundToPlay: String?
	var Snake_with_Skin: SKSpriteNode?
	var Back_button: SKSpriteNode?
	//var skin: [String] = ["red","blue","green","America","Australia"]
	var left_button: SKSpriteNode?
	var right_button: SKSpriteNode?
	
	let Actionwhite = SKAction.colorizeWithColor(SKColor.grayColor(), colorBlendFactor: 1.0, duration: 0.5)
	let Actionbrown = SKAction.colorizeWithColor(SKColor.brownColor(), colorBlendFactor: 1.0, duration: 0.5)
	let Actionblue = SKAction.colorizeWithColor(SKColor.blueColor(), colorBlendFactor: 1.0, duration: 0.5)
	let Actionred = SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 1.0, duration: 0.5)
	
	let ActionPink = SKAction.colorizeWithColor(UIColor(red:0.97, green:0.68, blue:0.68, alpha:1.0), colorBlendFactor: 1.0, duration: 0.5)
	
	
	override func didMoveToView(view: SKView) {
		
		Snake_with_Skin = self.childNodeWithName("Snake_with_Skin") as? SKSpriteNode
		
		Back_button = self.childNodeWithName("Back_button") as? SKSpriteNode
		left_button = self.childNodeWithName("left_button") as? SKSpriteNode
		
		right_button = self.childNodeWithName("right_button") as? SKSpriteNode
		
		if let count_skinAnyobj = userDefaults.valueForKey("skin") {
			let count_skin = count_skinAnyobj as! Int
			switch count_skin {
			case 0:
				Snake_with_Skin!.runAction(Actionred)
				count=count_skin
				break
			case 1:
				Snake_with_Skin!.runAction(Actionblue)
				count=count_skin
				break
			case 2:
				Snake_with_Skin!.runAction(Actionwhite)
				count=count_skin
				break
			case 3:
				Snake_with_Skin!.runAction(Actionbrown)
				count=count_skin
				break
			default:
				Snake_with_Skin!.runAction(ActionPink)
				count=count_skin
				
			}
		}
		else {
			count=0
			Snake_with_Skin!.runAction(Actionwhite)
		}
		
	}
	
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		for touch: AnyObject in touches {
			let position = touch.locationInNode(self) // Get the x,y point of the touch
			if CGRectContainsPoint(Back_button!.frame, position) {
				self.runAction(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
				let mainScene = MainScene(fileNamed: "MainScene")
				//inputText?.hidden = true
				let transition = SKTransition.fadeWithDuration(1)
				let skView = self.view as SKView!
				mainScene?.scaleMode = .AspectFill
				dispatch_async(dispatch_get_main_queue(), {
					skView.presentScene(mainScene!, transition: transition)
				})
			}else if CGRectContainsPoint(left_button!.frame, position) {
				self.runAction(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
				
				count=(count!-1)
				
				if(count<0)
				{
						print(Player_unlock_skin)
						print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&")
						if Player_unlock_skin == 1
						{
							print("****************************")
							count = 4
						}
						else
						{
							print("))))))))))))))))))))))))")
							count=3
						}
					
				
					
				}
				
				print(count)
				switch count! {
				case 0:
					Snake_with_Skin!.runAction(Actionred)
					userDefaults.setValue(count, forKey: "skin")
					userDefaults.synchronize() // don't forget this!!!!
					break
				case 1:
					Snake_with_Skin!.runAction(Actionblue)
					userDefaults.setValue(count, forKey: "skin")
					userDefaults.synchronize() // don't forget this!!!!
					break
				case 2:
					Snake_with_Skin!.runAction(Actionwhite)
					userDefaults.setValue(count, forKey: "skin")
					userDefaults.synchronize() // don't forget this!!!!
					break
				case 3:
					Snake_with_Skin!.runAction(Actionbrown)
					userDefaults.setValue(count, forKey: "skin")
					userDefaults.synchronize() // don't forget this!!!!
					break
				default:
					Snake_with_Skin!.runAction(ActionPink)
					userDefaults.setValue(count, forKey: "skin")
					userDefaults.synchronize() // don't forget this!!!!
					break
				}
				
				
			}else if CGRectContainsPoint(right_button!.frame, position) {
				self.runAction(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
				
				
				if Player_unlock_skin == 1
				{
					print("****************************")
					count=(count!+1)%5
				}
				else
				{
					print("))))))))))))))))))))))))")
					count=(count!+1)%4
				}

				
				
				
				print(count)
				switch count! {
				case 0:
                    colorCode = 0
					Snake_with_Skin!.runAction(Actionred)
					
					userDefaults.setValue(count, forKey: "skin")
					userDefaults.synchronize() // don't forget this!!!!
                    break
				case 1:
                    colorCode = 1
					Snake_with_Skin!.runAction(Actionblue)
					userDefaults.setValue(count, forKey: "skin")
					userDefaults.synchronize() // don't forget this!!!!
                    break
                case 2:
                    colorCode = 2
					Snake_with_Skin!.runAction(Actionwhite)
					userDefaults.setValue(count, forKey: "skin")
					userDefaults.synchronize() // don't forget this!!!!
                    break
                case 3:
                    colorCode = 3
					Snake_with_Skin!.runAction(Actionbrown)
					userDefaults.setValue(count, forKey: "skin")
					userDefaults.synchronize() // don't forget this!!!!
					break
				default:
                    colorCode = 4
					Snake_with_Skin!.runAction(ActionPink)
					userDefaults.setValue(count, forKey: "skin")
					userDefaults.synchronize() // don't forget this!!!!
					break
				}
				
			
			}
		}
	}
	
}
