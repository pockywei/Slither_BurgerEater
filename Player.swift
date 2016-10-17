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
	var score = 0
	var rewards = 0
    

    static var onlinePlayers = 0
    static var bit_num=2
	
    
// Insert code here to add functionality to your managed object subclass
    init(color:UIColor,gameScence: GameScene) {
        
        self.snake =  Snake(color: color, gameScence: gameScence)
        self.snake.createPlayerInstance(self.snake.length, color: self.snake.snakeColor, headName:"playerhead", bodyName:"playerbody", radius: self.snake.radius)
        self.lastTouch = nil
        self.touchedScreen = false
        self.score = self.snake.length * 100
        
    }
    
    init(dict:Dictionary<String, AnyObject>, gameScence: GameScene){
        
        Player.bit_num = 4*Player.bit_num
        if let _ = dict["lastTouch_X"]{
        
            let _lastTouch_x = dict["lastTouch_X"] as! CGFloat
            let _lastTouch_y = dict["lastTouch_Y"] as! CGFloat
            self.lastTouch = CGPoint(x: _lastTouch_x, y: _lastTouch_y)
        }
        
        self.touchedScreen = dict["touchedScreen"] as! Bool
        self.speedupTapCount = dict["speedupTapCount"] as! Int
        self.score = dict["score"] as! Int
        self.rewards = dict["rewards"] as! Int
        
        self.snake = Snake(dict: dict, gameScence: gameScence)
        Player.bit_num = Player.bit_num*4

        let x = dict["X_position"] as! CGFloat
        let y = dict["Y_position"] as! CGFloat
        self.snake.createOnlinePlayerSnake(Player.bit_num, index: Player.onlinePlayers, x: x, y: y)
        
    }
    
    func updatePlayer() {
        self.score = self.snake.length * 100
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
    
    class func updateOnlinePlayer(players:[Player]){
        for player in players{
            player.updatePlayer()
        }
    }
    
    func updatePlayerByArrow(){
        let velocotyX = self.snake.snakeSpeed * cos(self.snake.angle)
        let velocityY = self.snake.snakeSpeed * sin(self.snake.angle)
        let newVelocity = CGVector(dx: velocotyX, dy: velocityY)
        self.snake.snakeBodyPoints[0].physicsBody!.velocity = newVelocity;
        self.snake.BodyMoveTwardHead()
        self.snake.gameScence.updateCamera()
    }
}
