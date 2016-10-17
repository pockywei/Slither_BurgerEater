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
class MainScene:SKScene,UITextFieldDelegate {
	
	
	let userDefaults = NSUserDefaults.standardUserDefaults()
	
    
    
	var inputText:UITextField?
    
    var MultiModeAlert: SKSpriteNode?
	
    var alert: UIAlertController?
    
	var Play_ai: SKLabelNode!
	
    var Play_ai_hard: SKLabelNode!
    
	var Multi_mode: SKLabelNode!
	
	var kbframe : CGRect?
	
	var change_mode = SKSpriteNode()
	
	
	var change_skin = SKSpriteNode()
	
	override func didMoveToView(view: SKView) {
		
		
		
		
        
        
        
		
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
		
		
		
		
		change_skin = self.childNodeWithName("change_skin") as! SKSpriteNode
		change_mode = self.childNodeWithName("setting") as! SKSpriteNode
		var background = self.childNodeWithName("background") as! SKSpriteNode
		
		
		
		inputText = UITextField(frame: CGRect(x:70,y:200,width:200,height:40))//如何居中
		
//		let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
//		dispatch_after(delayTime, dispatch_get_main_queue()) {
//		self.inputText!.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
//		}
		
		inputText!.delegate = self
		
		self.view!.addSubview(inputText!)
		inputText!.backgroundColor = UIColor.whiteColor()
		inputText!.placeholder="Username"
		
		
        Play_ai_hard = SKLabelNode(fontNamed: "Chalkduster")
        Play_ai_hard.text = "Survive 30 seconds to be a real man"
        //Play_ai.zRotation = CGFloat(-M_PI_2)
        Play_ai_hard.fontSize = 30
        Play_ai_hard.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)-100)
        Play_ai_hard.zPosition=3
        addChild(Play_ai_hard)
		
		
		Play_ai = SKLabelNode(fontNamed: "Chalkduster")
		Play_ai.text = "Play with AI"
        Play_ai.fontSize = 30
		//Play_ai.zRotation = CGFloat(-M_PI_2)
		Play_ai.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)-250)
		Play_ai.zPosition=3
		addChild(Play_ai)
		
		Multi_mode = SKLabelNode(fontNamed: "Chalkduster")
		Multi_mode.text = "Online Game"
        Multi_mode.fontSize = 30
		Multi_mode.zPosition=3
		//Multi_mode.zRotation = CGFloat(-M_PI_2)
		Multi_mode.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)-450)
		addChild(Multi_mode)
	
//		let blurEffect =  UIBlurEffect(style: UIBlurEffectStyle.Light)
//		let bluredEffectView = UIVisualEffectView(effect: blurEffect)
//		bluredEffectView.frame = CGRectMake(-13, 0, 460, 800)
//		self.view!.addSubview(bluredEffectView)
//		self.view!.sendSubviewToBack(bluredEffectView)
		

	}
	
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)  {
		/* Called when a touch begins */
		for touch: AnyObject in touches {
			let position = touch.locationInNode(self) // Get the x,y point of the touch
			if CGRectContainsPoint(Play_ai.frame, position) {
                mode = 0
                hardOrNot = 0
				Play_ai?.setScale(0.8)
				self.runAction(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
				let gameScene = GameScene(fileNamed: "GameScene")
				inputText?.hidden = true
				let transition = SKTransition.fadeWithDuration(1)
				let skView = self.view as SKView!
				gameScene?.scaleMode = .AspectFill
				dispatch_async(dispatch_get_main_queue(), {
					skView.presentScene(gameScene!, transition: transition)
				})
			view!.endEditing(true)
			}else if CGRectContainsPoint(change_skin.frame, position) {
				change_skin.setScale(0.8)
				self.runAction(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
				let changeSkinScene = ChangeSkinScene(fileNamed: "ChangeSkinScene")
				
				inputText?.hidden = true
				let transition = SKTransition.fadeWithDuration(1)
				let skView = self.view as SKView!
				changeSkinScene?.scaleMode = .AspectFill
				dispatch_async(dispatch_get_main_queue(), {
					skView.presentScene(changeSkinScene!, transition: transition)
				})
				view!.endEditing(true)
            }else if CGRectContainsPoint(Play_ai_hard.frame, position) {
                mode = 0
                hardOrNot = 1
                Play_ai_hard?.setScale(0.8)
                self.runAction(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                let gameScene = GameScene(fileNamed: "GameScene")
                inputText?.hidden = true
                let transition = SKTransition.fadeWithDuration(1)
                let skView = self.view as SKView!
                gameScene?.scaleMode = .AspectFill
                dispatch_async(dispatch_get_main_queue(), {
                    skView.presentScene(gameScene!, transition: transition)
                })
                view!.endEditing(true)
            }
            else if CGRectContainsPoint(change_mode.frame, position) {
				change_mode.setScale(0.8)
				self.runAction(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
				let changeGameModelScene = ChangeGameModelScene(fileNamed: "ChangeGameModelScene")
				inputText?.hidden = true
				let transition = SKTransition.fadeWithDuration(1)
				let skView = self.view as SKView!
				changeGameModelScene?.scaleMode = .AspectFill
				dispatch_async(dispatch_get_main_queue(), {
					skView.presentScene(changeGameModelScene!, transition: transition)
				})
				view!.endEditing(true)
            }else if CGRectContainsPoint(Multi_mode.frame, position) {
                mode = 1
                communicator = MultiNodeCommunication()
                Multi_mode?.setScale(0.8)
                self.runAction(SKAction.playSoundFileNamed("click.wav", waitForCompletion: false))
                
                let multi = MultiScene(size: self.size)
                                inputText?.hidden = true
                                let transition = SKTransition.fadeWithDuration(1)
                                let skView = self.view as SKView!
                                multi.scaleMode = .AspectFill
                                dispatch_async(dispatch_get_main_queue(), {
                                    skView.presentScene(multi, transition: transition)
                                })
                
                
                view!.endEditing(true)
                
                
            }
		}

		view!.endEditing(true)
//		for touch: AnyObject in touches {
//			let position = touch.locationInNode(self) // Get the x,y point of the touch
//			if CGRectContainsPoint(aButton.frame, position) { // Detect if that point is inside our button
//				let gameScene = GameScene(size: self.frame.size) //Replace here with the target scene
//				self.view?.presentScene(gameScene, transition: SKTransition.doorsCloseHorizontalWithDuration(0.35)) // Performs the transition of scene if the button was touch
//			}
//		}
	}



	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
	
	
	}
	
	func textFieldDidBeginEditing(textField: UITextField) {
		print("TextField did begin editing method called")
    }
    func textFieldDidEndEditing(textField: UITextField) {
        print(textField.text)
        userDefaults.setValue(textField.text, forKey: "username")
        self.userDefaults.synchronize() // don't forget this!!!!
        print("TextField did end editing method called")
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        print("TextField should begin editing method called")
        return true;
    }
    func textFieldShouldClear(textField: UITextField) -> Bool {
        print("TextField should clear method called")
        return true;
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print("TextField should snd editing method called")
        return true;
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
        return true;
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view!.endEditing(true)
    }
}
