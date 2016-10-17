//
//  AI.swift
//  snake_burgerEater
//
//  Created by Chris Sun on 8/10/16.
//  Copyright © 2016 WEI. All rights reserved.
//

import Foundation
import SpriteKit
class AI{
	
	var snake: Snake
	
	init(color:UIColor, bitmask:Int, index:Int, gameScence:GameScene, xMin:CGFloat, xMax:CGFloat, yMin:CGFloat, yMax:CGFloat) {
		snake = Snake.createAI(color, bitmask: bitmask, index: index, gameScence: gameScence,xMin: xMin, xMax: xMax, yMin: yMin, yMax: yMax)
	}
	
	func updateAISnake(player: Player){
		
		
		let x = self.snake.snakeBodyPoints[0].position.x
		let y = self.snake.snakeBodyPoints[0].position.y
		
		let x1 = player.snake.snakeBodyPoints[0].position.x
		let y1 = player.snake.snakeBodyPoints[0].position.x
		
		self.snake.angle = atan2(y - y1, x - x1) + CGFloat(M_PI)
		let velocotyX = self.snake.snakeSpeed * cos(self.snake.angle)
		let velocityY = self.snake.snakeSpeed * sin(self.snake.angle)
		let newVelocity = CGVector(dx: velocotyX, dy: velocityY)
		self.snake.snakeBodyPoints[0].physicsBody!.velocity = newVelocity
		self.snake.BodyMoveTwardHead()
        self.snake.gameScence.checkheadposition(self.snake.snakeBodyPoints[0])
		
	}
	
	class func updateAllAISnakes(snakes:[AI], player: Player){
		for snake in snakes{
			snake.updateAISnake(player)
		}
	}

	class func initialAiSnake(aiNum:Int, gameScence:GameScene, xMin:CGFloat, xMax:CGFloat, yMin:CGFloat, yMax:CGFloat)->[AI]{
		var AIs:[AI] = []

		var bit_num=2
		var snakeNum:Int
		if(aiNum>14){
			snakeNum = 14
		}else{
			snakeNum = aiNum
		}
		
		for i in 0...snakeNum-1 {
			bit_num = bit_num*4
			let ai = AI(color: UIColor.greenColor(), bitmask:bit_num, index: i,gameScence: gameScence,xMin: xMin, xMax: xMax, yMin: yMin, yMax: yMax)
			AIs.append(ai)
		}
		return AIs
	}
}
