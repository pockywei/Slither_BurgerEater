//
//  GameScene.swift
//  Demo
//
//  Created by Chenhao Wei on 20/08/16.
//  Copyright (c) 2016 WEI. All rights reserved.
//

import SpriteKit
import UIKit
import CoreData

class GameScene: SKScene, SKPhysicsContactDelegate , UINavigationControllerDelegate{
	
	// MARK: - Instance Variables
	//var Database_player = Player()// in the database
	
	

	
	//Set game paramter
	var playerSpeed: CGFloat = 150.0
	
	//这是AI的速度
	let AI_snakeSpeed: CGFloat = 35.0
	
	//这是我们的蛇
	var player: SKSpriteNode?
	
	//加速按钮
	var speed_up: SKSpriteNode?
	
	//这是AI snake 的数组
	var AI_snakes: [SKSpriteNode] = []
    
    //food array
    var foods: [SKSpriteNode] = []
	
	//最后触碰的点
	var lastTouch: CGPoint? = nil
    
	
	// MARK: - SKScene
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
	
	override func didMoveToView(view: SKView) {
		
		
		// Setup player
		//开启多点触控模式
		self.view?.multipleTouchEnabled = true
		
		//实例化player，从scene里面提取名字叫player的node
		player = self.childNodeWithName("player") as? SKSpriteNode
		
		//同理
		speed_up = self.childNodeWithName("speed_up") as? SKSpriteNode
		
        // Initialize 3 food in the scene
        addFood(3)
        
        //示例化AI_snake和food
        for child in self.children {
            if child.name == "AI_snake" {
                if let child = child as? SKSpriteNode {
                    AI_snakes.append(child)
                }
            
            }
            /*
            else if child.name == "food"{
                if let child = child as? SKSpriteNode{
                    foods.append(child)
                }
            }
            */
        }
        
        
        
        
        
		//*/
        
		//set player Skin and Model
		//设置用户的皮肤和操作模式
		setDefaultSkin(player!)
		setDefaultModel(player!)
		
		//到这里位置，我们的用户是一个sknode，我们的用户颜色有了。
		
		// Setup physics world's contact delegate
		physicsWorld.contactDelegate = self
		
		// Setup initial camera position
		updateCamera()
	}
    
    // Add food when food is eaten by user
    func addFood(n: Int){
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let width = screenSize.width
        let height = screenSize.height
        for var i = 1; i <= n; i++ {
            let food = SKSpriteNode(imageNamed:"food")
            food.color = UIColor(red:0.44, green:0.61, blue:0.41, alpha:1.0)
            
            var foodx = random(min:50, max: width-50)
            var foody = random(min:50, max: height-50)
            
            food.position = CGPoint(x: foodx, y: foody)
            
            food.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 40, height: 40))
            food.physicsBody?.dynamic = false
            food.physicsBody?.categoryBitMask = 3
            food.physicsBody?.contactTestBitMask = 1
            addChild(food)
        }
    }
    
    func addAI_snake(n: Int){
        // To be finished later
    }
	
	
	// MARK: Touch Handling
	
	//这是函数是你刚tap下去就会发生的事
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		handleTouches(touches)
		
		//这是当用户按到加速按钮时的时候，会加速的
		for touch: AnyObject in touches {
			let position = touch.locationInNode(self) // Get the x,y point of the touch
			if CGRectContainsPoint(speed_up!.frame, position) {
				//print(position)
				playerSpeed = 300.0
			}
		}
	}
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		handleTouches(touches)
	}
	
	
	//这个是你放手的时候，才会执行的
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		handleTouches(touches)
		playerSpeed = 150.0
	}
	
	
	//主要是更新最后的tap 点坐标，lastTouch是个全局变量
	private func handleTouches(touches: Set<UITouch>) {
		for touch in touches {
			let touchLocation = touch.locationInNode(self)
			lastTouch = touchLocation
		}
	}
	
	
	// MARK - Updates
	override func didSimulatePhysics() {
		if let _ = player {
			updatePlayer()
			updateAI_snakes()
		}
	}
	
	// Determines if the player's position should be updated
	private func shouldMove(currentPosition currentPosition: CGPoint, touchPosition: CGPoint) -> Bool {
		return abs(currentPosition.x - touchPosition.x) > player!.frame.width / 2 ||
			abs(currentPosition.y - touchPosition.y) > player!.frame.height/2
	}
	
	// Updates the player's position by moving towards the last touch made
	func updatePlayer() {
		if let touch = lastTouch {
			let currentPosition = player!.position
			
			
			if shouldMove(currentPosition: currentPosition, touchPosition: touch) {
				
				let angle = atan2(currentPosition.y - touch.y, currentPosition.x - touch.x) + CGFloat(M_PI)
				let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0)
				
				player!.runAction(rotateAction)
				
				let velocotyX = playerSpeed * cos(angle)
				let velocityY = playerSpeed * sin(angle)
				
				let newVelocity = CGVector(dx: velocotyX, dy: velocityY)
				player!.physicsBody!.velocity = newVelocity;
				updateCamera()
			} else {
				player!.physicsBody!.resting = true
			}
		}
	}
    
    
    
	func updateCamera() {
		if let camera = camera {
			camera.position = CGPoint(x: player!.position.x, y: player!.position.y)
		}
	}
	
	// Updates the position of all AI_snakes by moving towards the player
	func updateAI_snakes() {
		let targetPosition = player!.position
		
		for AI_snake in AI_snakes {
			let currentPosition = AI_snake.position
			
			let angle = atan2(currentPosition.y - targetPosition.y, currentPosition.x - targetPosition.x) + CGFloat(M_PI)
			let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0.0)
			AI_snake.runAction(rotateAction)
			
			let velocotyX = AI_snakeSpeed * cos(angle)
			let velocityY = AI_snakeSpeed * sin(angle)
			
			let newVelocity = CGVector(dx: velocotyX, dy: velocityY)
			AI_snake.physicsBody!.velocity = newVelocity;
		}
	}
    
    /*
    // Delete food from scene when snake hit food, and lengthen snake
    func updateFoods(){
        for food in foods{
     
        }
    }
	*/
	
	// MARK: - SKPhysicsContactDelegate
	// Collision detect, including user hit by AI_snake and user eat food.
	func didBeginContact(contact: SKPhysicsContact) {
        
		// 1. Create local variables for two physics bodies
		var firstBody: SKPhysicsBody
		var secondBody: SKPhysicsBody
        
		// 2. Make sure the user object is always stored in "firstBody"
        if contact.bodyA.categoryBitMask + contact.bodyB.categoryBitMask <= 4{
            if contact.bodyA.categoryBitMask == 1{
                firstBody = contact.bodyA
                secondBody = contact.bodyB
            } else{
                firstBody = contact.bodyB
                secondBody = contact.bodyA
            }
            
            
            // 3. Proceed based on which object the user hits
            if secondBody.categoryBitMask == 2{
                print("Snake just got hit by a AI_snake")
                //gameOver(false)
            } else{
                print("Snake just eat a food")
                self.player!.size = CGSize(width: player!.frame.size.width*1.002, height: player!.frame.size.height*1.002)
                secondBody.node!.removeFromParent()
                addFood(1)
            }
        }
		
        
        
        
	}
	

	//Set default skin
	func setDefaultSkin(player:SKSpriteNode){
		let userDefaults = NSUserDefaults.standardUserDefaults()
		
		if let count_skinAnyobj = userDefaults.valueForKey("skin") {
			//print(count_skinAnyobj)
			let count_skin = count_skinAnyobj as! Int
			switch count_skin {
			case 0:
				//Snake_with_Skin!.runAction(Actionred)
				player.color=UIColor.redColor()
				break
			case 1:
				//Snake_with_Skin!.runAction(Actionblue)
				player.color=UIColor.blueColor()
				break
			case 2:
				//Snake_with_Skin!.runAction(Actionwhite)
				player.color=UIColor.whiteColor()
				break
			default:
				//Snake_with_Skin!.runAction(Actionbrown)
				player.color=UIColor.brownColor()
				break
			}
		}
		else {
			player.color=UIColor.whiteColor()
			//print("No color")
		}

	}
	//Set default model
	func setDefaultModel(player:SKSpriteNode){
		let userDefaults = NSUserDefaults.standardUserDefaults()
		
		if let count_modelAnyobj = userDefaults.valueForKey("model") {
			//print(count_modelAnyobj)
			let count_model = count_modelAnyobj as! String
			switch count_model {
			case "Arrow_model":
				
				break
			case "Rocker_model":
				
				break
			
			default:
				
				break
			}
		}
		else {
			//set normal way
			//print("Normal_model")
		}

	}
	// MARK: Helper Functions
	// gameOver(false) means game is over, true means not over
	private func gameOver(didWin: Bool) {
		//print("- - - Game Ended - - -")
		let menuScene = MenuScene(size: self.size)
		//menuScene.soundToPlay = didWin ? "fear_win.mp3" : "fear_lose.mp3"
		let transition = SKTransition.fadeWithDuration(1)
		menuScene.scaleMode = SKSceneScaleMode.AspectFill
		self.scene!.view?.presentScene(menuScene, transition: transition)
	}
	
	
	
}
