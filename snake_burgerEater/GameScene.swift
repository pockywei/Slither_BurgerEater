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
	
	

    var otherPlayers: [String:Player] = [:]
    
	//Set game paramter
	var playerSpeed: CGFloat = 150.0
	
	//这是AI的速度
	let AI_snakeSpeed: CGFloat = 75.0
	
	//这是我们的蛇
	var player: SKSpriteNode?
	
	//加速按钮
	var speed_up: SKSpriteNode?
	
	//这是AI snake 的数组
	var AI_snakes: [SKSpriteNode] = []
	
	//最后触碰的点
	var lastTouch: CGPoint? = nil
	
	
	// MARK: - SKScene
	
	override func didMoveToView(view: SKView) {
		
		
		// Setup player
		//开启多点触控模式
		self.view?.multipleTouchEnabled = true
		
		//实例化player，从scene里面提取名字叫player的node
		player = self.childNodeWithName("player") as? SKSpriteNode
		
		//同理
		speed_up = self.childNodeWithName("speed_up") as? SKSpriteNode
		
		
		//set player Skin and Model
		
		//设置用户的皮肤和操作模式
		setDefaultSkin(player!)
		setDefaultModel(player!)
		
		//到这里位置，我们的用户是一个sknode，我们的用户颜色有了。
		
		
		// Setup AI_snakes
		for child in self.children {
			if child.name == "AI_snake" {
				if let child = child as? SKSpriteNode {
					AI_snakes.append(child)
				}
			}
		}
		
		
		// Setup physics world's contact delegate
		physicsWorld.contactDelegate = self
		
		// Setup initial camera position
		updateCamera()
	}
	
	
	// MARK: Touch Handling
	
	//这是函数是你刚tap下去就会发生的事
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		handleTouches(touches)
		
		//这是当用户按到加速按钮时的时候，会加速的
		for touch: AnyObject in touches {
			let position = touch.locationInNode(self) // Get the x,y point of the touch
			if CGRectContainsPoint(speed_up!.frame, position) {
				print(position)
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
	
    func updateOthrsPlayers(playerId:String){
        
        if let otherPlayer = otherPlayers[playerId]{
            if let touch = otherPlayer.lastTouch {
                let currentPosition = otherPlayer.player?.position
            
                if shouldMove(currentPosition: currentPosition!, touchPosition: touch) {
                
                    let angle = atan2(currentPosition!.y - touch.y, currentPosition!.x - touch.x) + CGFloat(M_PI)
                    let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0)
                
                    player!.runAction(rotateAction)
                
                    let velocotyX = playerSpeed * cos(angle)
                    let velocityY = playerSpeed * sin(angle)
                
                    let newVelocity = CGVector(dx: velocotyX, dy: velocityY)
                    player!.physicsBody!.velocity = newVelocity;
                    //updateCamera()
                } else {
                    player!.physicsBody!.resting = true
                }
            }
        }
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
	
	
	// MARK: - SKPhysicsContactDelegate
	
	
	//搞懂这个函数。
	func didBeginContact(contact: SKPhysicsContact) {
		// 1. Create local variables for two physics bodies
		var firstBody: SKPhysicsBody
		var secondBody: SKPhysicsBody
		
		// 2. Assign the two physics bodies so that the one with the lower category is always stored in firstBody
		if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
			firstBody = contact.bodyA
			secondBody = contact.bodyB
		} else {
			firstBody = contact.bodyB
			secondBody = contact.bodyA
		}
		
		// 3. react to the contact between the two nodes
		if firstBody.categoryBitMask == player?.physicsBody?.categoryBitMask &&
			secondBody.categoryBitMask == AI_snakes[0].physicsBody?.categoryBitMask {
			// Player & AI_snake
			gameOver(false)
		}
	}
	

	//Set default skin
	func setDefaultSkin(player:SKSpriteNode){
		let userDefaults = NSUserDefaults.standardUserDefaults()
		
		if let count_skinAnyobj = userDefaults.valueForKey("skin") {
			print(count_skinAnyobj)
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
				player.color=UIColor.grayColor()
				break
			default:
				//Snake_with_Skin!.runAction(Actionbrown)
				player.color=UIColor.brownColor()
				break
			}
		}
		else {
			player.color=UIColor.grayColor()
			print("No color")
		}

	}
	//Set default model
	func setDefaultModel(player:SKSpriteNode){
		let userDefaults = NSUserDefaults.standardUserDefaults()
		
		if let count_modelAnyobj = userDefaults.valueForKey("model") {
			print(count_modelAnyobj)
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
			print("Normal_model")
		}

	}
	// MARK: Helper Functions
	
	private func gameOver(didWin: Bool) {
		print("- - - Game Ended - - -")
		
		
		let menuScene = MenuScene(size: self.size)
		//menuScene.soundToPlay = didWin ? "fear_win.mp3" : "fear_lose.mp3"
		let transition = SKTransition.fadeWithDuration(1)
		menuScene.scaleMode = SKSceneScaleMode.AspectFill
		self.scene!.view?.presentScene(menuScene, transition: transition)
		

	}
	func deCodeJsonData(){
		
	
	}
}

extension GameScene : GameStateSychronizorDelegate{
    func addPlayer(playerId: String){
        otherPlayers[playerId] = nil
        
    }
    func deletePlayer(playerId: String) {
        otherPlayers.removeValueForKey(playerId)
    }
    
    func changeGameState(playerId: String, gameState: String){
        
    }
}
