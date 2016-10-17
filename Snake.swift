//
//  Snake.swift
//  snake_burgerEater
//
//  Created by Chris Sun on 8/10/16.
//  Copyright © 2016 WEI. All rights reserved.
//

import Foundation
import SpriteKit
import CoreData

class Snake{
    var snakeBodyPoints: [SKShapeNode]
    var length:Int
    var radius:CGFloat
    var snakeColor:UIColor
    var snakeSpeed:CGFloat
    var angle:CGFloat
    var eatFoodNum:Int
    var gameScence:GameScene
    var scale:CGFloat
    var otherSnakeColor = colorCode
    
    static var alph:CGFloat = 0.6
    static var playerPositionX = 200
    static var playerPositionY = 200
    
    static var colors = [0:UIColor.grayColor(), 1: UIColor.brownColor(), 2:UIColor.blueColor(), 3:UIColor.redColor(), 4: UIColor(red:0.97, green:0.68, blue:0.68, alpha:1.0)]
    
	class func createPlayerSnake(color:UIColor, gameScence:GameScene)->Snake{
		let playerSnake =  Snake(color: color, gameScence: gameScence)
		playerSnake.createPlayerInstance(playerSnake.length, color: playerSnake.snakeColor, headName:"playerhead", bodyName:"playerbody", radius: playerSnake.radius)
		return playerSnake
	}
	
	class func createAI(color:UIColor, bitmask:Int, index:Int, gameScence:GameScene, xMin:CGFloat, xMax:CGFloat, yMin:CGFloat, yMax:CGFloat)->Snake{
		let AISnake =  Snake(color: color, bitmask: bitmask, index: index, gameScence: gameScence)
		AISnake.createAiSnake(AISnake.length, bitmask: bitmask, index: index, color: AISnake.snakeColor, radius: AISnake.radius, xmin: xMin, xMax: xMax, yMin: yMin, yMax: yMax)
		return AISnake
	}
	
    init(color:UIColor, gameScence:GameScene) {
        
        self.snakeBodyPoints = []
        self.length = 4
        self.radius = 4.0
        self.snakeColor = color
        self.snakeSpeed = 75.0
        self.angle = atan2(-1, -1) + CGFloat(M_PI)
        self.eatFoodNum = 0;
        self.gameScence = gameScence
        self.scale = 1.0
    }
    
    init(color:UIColor, bitmask:Int, index:Int, gameScence:GameScene) {
        
        self.snakeBodyPoints = []
        self.length = 4
        self.radius = 4.0
        self.snakeColor = color
        self.snakeSpeed = 65.0
        self.angle = atan2(-1, -1) + CGFloat(M_PI)
        self.eatFoodNum = 0
        self.gameScence = gameScence
        self.scale = 1.0
    }
    
    init(dict:Dictionary<String, AnyObject>, gameScence:GameScene){

        let colorIndex = dict["color"] as! Int
        self.snakeColor = Snake.colors[colorIndex]! as UIColor
        self.length = dict["length"] as! Int
        self.radius = dict["radius"] as! CGFloat
        self.snakeSpeed = dict["snakeSpeed"] as! CGFloat
        self.angle = dict["angle"] as! CGFloat
        self.eatFoodNum = dict["eatFoodNum"] as! Int
        self.scale = dict["scale"] as! CGFloat
        self.gameScence = gameScence
        self.snakeBodyPoints = []
        self.otherSnakeColor = colorIndex
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createPlayerInstance(length:Int, color: UIColor, headName:String, bodyName:String, radius:CGFloat){
        // Build user snake array
        for i in 0...length-1{
            let point = SKShapeNode(circleOfRadius: CGFloat(radius))
            point.fillColor = color
            if mode == 0{
                point.position = CGPoint(x:Snake.playerPositionX+i, y:Snake.playerPositionY)
            }else{
                let user_x = random(min:180, max:200)
                let user_y = random(min:180, max:200)
                point.position = CGPoint(x:Int(user_x)+i, y:Int(user_y))
            }
            point.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(radius))
            point.physicsBody?.dynamic = true
			point.lineWidth=0
            
            if(i==0){
                point.name = headName
                point.physicsBody?.categoryBitMask = 0x00000001
                point.physicsBody?.collisionBitMask = 0x00000004//0xfffffffc
                point.physicsBody?.contactTestBitMask = 0xfffffffc
            }else{
                point.name = bodyName
                point.physicsBody?.categoryBitMask = 0x00000002
                point.physicsBody?.collisionBitMask = 0
                point.physicsBody?.contactTestBitMask = 0xaaaaaaa8
            }
            
            point.physicsBody?.affectedByGravity = false
            point.physicsBody?.allowsRotation = false
            self.gameScence.addChild(point)
            self.snakeBodyPoints.append(point)
        }
    }
    
    
    
    // Add one AI snake with length n
    func createAiSnake(length: Int,bitmask:Int, index:Int, color:UIColor, radius:CGFloat, xmin: CGFloat, xMax:CGFloat, yMin:CGFloat, yMax:CGFloat ){
        
        
        let aix = random(min:xmin, max:xMax)
        
        let aiy = random(min:yMin, max:yMax)
        
        let aiHeadBitMask = UInt32(bitmask)
        let aiBodyBitMask = aiHeadBitMask << 2
        for i in 0...length-1{
            let point = SKShapeNode(circleOfRadius: radius)
            point.fillColor = color
            
            point.position = CGPoint(x:Int(aix) + i, y:Int(aiy))
            
            point.physicsBody = SKPhysicsBody(circleOfRadius: radius)
            point.physicsBody?.dynamic = true
            point.lineWidth=0
            if(i == 0){
                point.name = "aihead"+String(index)
                point.physicsBody?.categoryBitMask = aiHeadBitMask
                point.physicsBody?.collisionBitMask = 0
                //point.physicsBody?.collisionBitMask = ~(aiHeadBitMask | aiBodyBitMask)
                point.physicsBody?.contactTestBitMask = ~(aiHeadBitMask | aiBodyBitMask)
                point.fillColor = SKColor.whiteColor()
            }else{
                point.name = "aibody"
                point.physicsBody?.categoryBitMask = aiBodyBitMask
                point.physicsBody?.collisionBitMask = 0
                
                //point.physicsBody?.collisionBitMask = ~(aiHeadBitMask | aiBodyBitMask | 4)
                point.physicsBody?.contactTestBitMask = ~(aiHeadBitMask | aiBodyBitMask | 4 | 0x55555550)
            }
            
            point.physicsBody?.affectedByGravity = false
            point.physicsBody?.allowsRotation = false
            
            self.gameScence.addChild(point)
            self.snakeBodyPoints.append(point)
        }
    }

	// Add one AI snake with length n
	func createOnlinePlayerSnake(bitmask:Int, index:Int,x: CGFloat, y:CGFloat){
        print("get Bit Mask")
		print(bitmask)
        
		let aiHeadBitMask = UInt32(bitmask)
		let aiBodyBitMask = aiHeadBitMask << 2
		for i in 0...self.length-1{
			let point = SKShapeNode(circleOfRadius: self.radius)
			point.fillColor = self.snakeColor
			
			point.position = CGPoint(x:Int(x) + i, y:Int(y))
			
			point.physicsBody = SKPhysicsBody(circleOfRadius: self.radius)
			point.physicsBody?.dynamic = true
            point.setScale(self.scale)
			point.lineWidth=0
			if(i == 0){
				point.name = "aihead"+String(index)
				point.physicsBody?.categoryBitMask = aiHeadBitMask
				//point.physicsBody?.collisionBitMask = 0
				point.physicsBody?.collisionBitMask = ~(aiHeadBitMask | aiBodyBitMask)
				point.physicsBody?.contactTestBitMask = ~(aiHeadBitMask | aiBodyBitMask)
			}else{
				point.name = "aibody"
				point.physicsBody?.categoryBitMask = aiBodyBitMask
				point.physicsBody?.collisionBitMask = 0
				
				//point.physicsBody?.collisionBitMask = ~(aiHeadBitMask | aiBodyBitMask | 4)
				point.physicsBody?.contactTestBitMask = ~(aiHeadBitMask | aiBodyBitMask | 4 | 0x55555550)
			}
			
			point.physicsBody?.affectedByGravity = false
			point.physicsBody?.allowsRotation = false
			
			self.gameScence.addChild(point)
			self.snakeBodyPoints.append(point)
		}
	}
	
    func addSnakeLength(length:Int){
        self.eatFoodNum+=1
        let categoryBM = self.snakeBodyPoints[2].physicsBody!.categoryBitMask
        let collisionBM = self.snakeBodyPoints[2].physicsBody!.collisionBitMask
        let contactBM = self.snakeBodyPoints[2].physicsBody!.contactTestBitMask
		
        for _ in 0...length-1 {
            let point = SKShapeNode(circleOfRadius: CGFloat(self.radius))
            
            point.fillColor = self.snakeColor
            point.position =  CGPoint(x:self.snakeBodyPoints[self.length-1].position.x+1, y:self.snakeBodyPoints[self.length-1].position.y+1)
            
            point.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.radius))
            point.physicsBody?.dynamic = true
            point.setScale(self.scale)
			point.lineWidth=0
            point.name = "playerbody"
            point.physicsBody?.categoryBitMask = categoryBM
            point.physicsBody?.collisionBitMask = collisionBM
            point.physicsBody?.contactTestBitMask = contactBM
            
            point.physicsBody?.affectedByGravity = false
            point.physicsBody?.allowsRotation = false
			
            
            self.snakeBodyPoints.append(point)
            self.gameScence.addChild(point)
        }
        self.length += length
        if(self.eatFoodNum >= 3)
        {
            //print("opopop")
            self.changePlayerSankeWidth()
            self.eatFoodNum=0
        }
    }
    
    
    func changePlayerSankeWidth(){
        
        //print("hhhhhhhh")
        self.scale += CGFloat(Snake.alph)
        for i in 0...self.length-1{
            let Act = SKAction.scaleTo(self.scale, duration: 1)
            self.snakeBodyPoints[i].runAction(Act)
        }
        Snake.alph *= Snake.alph
        Snake.alph += 0.05
    }
    
    func BodyMoveTwardHead(){
        for i in 1...self.length-1{
            let angle = atan2(self.snakeBodyPoints[i].position.y - self.snakeBodyPoints[i-1].position.y, self.snakeBodyPoints[i].position.x - self.snakeBodyPoints[i-1].position.x) + CGFloat(M_PI)
            let velocotyX = self.snakeSpeed * cos(angle)
            let velocityY = self.snakeSpeed * sin(angle)
            let newVelocity = CGVector(dx: velocotyX, dy: velocityY)
            self.snakeBodyPoints[i].physicsBody!.velocity = newVelocity;
        }
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
   
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
	
	func reduceSnakeLength(){
		
		if(self.length > 3)
		{
			self.snakeBodyPoints[length-1].removeFromParent()
			self.snakeBodyPoints.removeAtIndex(length-1)
			self.length = self.length - 1
		}
	}
	
	func turnIntoDisks(){
		for i in self.snakeBodyPoints{
			i.removeFromParent()
		}
	}
	

}
