//
//  Player.swift
//  snake_burgerEater
//
//  Created by WEI on 9/19/16.
//  Copyright © 2016 WEI. All rights reserved.
//

import Foundation
import CoreData
import SpriteKit


class Player{

	var snake: Snake
	var lastTouch: CGPoint?
	var userDefaults : NSUserDefaults?
    var touchedScreen = false
	var speedupTapCount = 0
	
    
// Insert code here to add functionality to your managed object subclass
    init(color:UIColor,gameScence: GameScene) {
        
        self.snake =  Snake(color: color, gameScence: gameScence)
        self.snake.createPlayerInstance(self.snake.length, color: self.snake.snakeColor, headName:"playerhead", bodyName:"playerbody", radius: self.snake.radius)
        self.lastTouch = nil
        self.touchedScreen = false
    }
    
    func updatePlayer() {
        if self.touchedScreen == false{
            let velocotyX = self.snake.snakeSpeed * cos(self.snake.angle)
            let velocityY = self.snake.snakeSpeed * sin(self.snake.angle)
            let newVelocity = CGVector(dx: velocotyX, dy: velocityY)
            self.snake.snakeBodyPoints[0].physicsBody!.velocity = newVelocity;
            self.snake.BodyMoveTwardHead()
        }else{
            let touch = self.lastTouch
            let currentPosition = self.snake.snakeBodyPoints[0].position
            self.snake.angle = atan2((currentPosition.y - touch!.y), (currentPosition.x - touch!.x)) + CGFloat(M_PI)
            let velocotyX = self.snake.snakeSpeed * cos(self.snake.angle)
            let velocityY = self.snake.snakeSpeed * sin(self.snake.angle)
            let newVelocity = CGVector(dx: velocotyX, dy: velocityY)
            self.snake.snakeBodyPoints[0].physicsBody!.velocity = newVelocity;
            self.snake.BodyMoveTwardHead()
            self.touchedScreen = false
        }
        self.snake.gameScence.updateCamera()
    }
	
	func updatePlayerByJoystick(){
		
		let velocotyX = self.snake.snakeSpeed * cos(self.snake.angle)
		let velocityY = self.snake.snakeSpeed * sin(self.snake.angle)
		let newVelocity = CGVector(dx: velocotyX, dy: velocityY)
		self.snake.snakeBodyPoints[0].physicsBody!.velocity = newVelocity;
		self.snake.BodyMoveTwardHead()
		self.snake.gameScence.updateCamera()
		
	
	}
	

}
