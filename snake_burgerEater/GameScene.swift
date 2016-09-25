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
	let AI_snakeSpeed: CGFloat = 75.0
	
	var goal: SKSpriteNode?
	var player: SKSpriteNode?
	var AI_snakes: [SKSpriteNode] = []
	
	var lastTouch: CGPoint? = nil
	
	
	// MARK: - SKScene
	
	override func didMoveToView(view: SKView) {
		// Setup player
		player = self.childNodeWithName("player") as? SKSpriteNode
		
		
		
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
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		handleTouches(touches)
		playerSpeed = 300.0
	}
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		handleTouches(touches)
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		handleTouches(touches)
		playerSpeed = 150.0
	}
	
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
	
	
	// MARK: - SKPhysicsContactDelegate
	
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
		} else if firstBody.categoryBitMask == player?.physicsBody?.categoryBitMask &&
			secondBody.categoryBitMask == goal?.physicsBody?.categoryBitMask {
			// Player & Goal
			gameOver(true)
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
	
	
	
}
