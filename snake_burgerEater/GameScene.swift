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
	
    var color = UIColor.grayColor()
    //Game Class
	var time: NSTimeInterval = 0
	
    /*摇杆的代码*/
	var stickActive : Bool = false
	let base = SKSpriteNode(imageNamed:"circle")
	let ball = SKSpriteNode(imageNamed:"ball")
	let controller = SKSpriteNode(imageNamed:"changeControl")
	var controllerFlag = 0
	
	let userDefaults = NSUserDefaults.standardUserDefaults()

	//加速按钮
	var speed_up: SKSpriteNode?
	
    var player:Player?
    
	//这是AI snake 的数组
    var AIs:[AI] = []
	
	//init the wall
	var leftwall = SKSpriteNode()
	var rightwall = SKSpriteNode()
	var topwall = SKSpriteNode()
	var downwall = SKSpriteNode()
	
	// MARK: - SKScene
	override func didMoveToView(view: SKView) {
		
		
		
		leftwall = self.childNodeWithName("leftwall") as! SKSpriteNode
		rightwall = self.childNodeWithName("rightwall") as! SKSpriteNode
		topwall = self.childNodeWithName("topwall") as! SKSpriteNode
		downwall = self.childNodeWithName("downwall") as! SKSpriteNode
		
        
        self.player = Player(color: self.color,gameScence: self)
		
		self.player!.userDefaults = NSUserDefaults.standardUserDefaults()
        self.player!.snake.snakeSpeed = 75.0
		
        self.AIs = AI.initialAiSnake(14,gameScence: self)
		
        // Setup player
		//开启多点触控模式
		self.view?.multipleTouchEnabled = true
		
		//add food
		self.addFood(80)
		
		//设置用户的皮肤和操作模式
		setDefaultSkin(self.player!.snake.snakeBodyPoints)
		setDefaultModel()
		
		// Setup physics world's contact delegate
		physicsWorld.contactDelegate = self
		
		setupCamera()
		
	}
	
	

	/*=============================神级update函数=====================================================*/
	
	override func update(currentTime: NSTimeInterval) {
		
			if let count_modelAnyobj = self.player!.userDefaults!.valueForKey("model")
			{
				if (count_modelAnyobj as! String) == "Rocker_model"
				{
					print("hello Rocker update")
					self.player!.updatePlayerByJoystick()
					self.updateCamera()
				}
				else if (count_modelAnyobj as! String) == "Arrow_model"
				{
					
				}
				else
				{
					self.player!.updatePlayer()
					self.updateCamera()
				}

				
			}
			
			
			
			time=currentTime
            
		
		self.checkheadposition(self.player!.snake.snakeBodyPoints[0])
	}

	
	/*=============================touch点相关=======================================================*/
	//这是函数是你刚tap下去就会发生的事
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
		if let count_modelAnyobj = self.player!.userDefaults!.valueForKey("model")
		{
			if (count_modelAnyobj as! String) == "Rocker_model"
			{
				for touch in (touches ){
					let location = touch.locationInNode(camera!)
					if(CGRectContainsPoint(ball.frame, location)){
						stickActive = true
						handJoyStick(touches)
					}else
					{
						stickActive=false
					}
				}
			}
			else if (count_modelAnyobj as! String) == "Arrow_model"
			{
				
			}
			else
			{
				handleTouches(touches)
			}
			
		}
		else{
			handleTouches(touches)
		}
		
		//这是当用户按到加速按钮时的时候，会加速的
		for touch: AnyObject in touches {
			//let position = touch.locationInNode(self) // Get the x,y point of the touch
			
			let touchspeed = touch.locationInNode(camera!)
			if CGRectContainsPoint(speed_up!.frame, touchspeed) {
				print("HI")
                self.player!.snake.snakeSpeed = 125.0
			}
		}
		
	}
    
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if let count_modelAnyobj = player!.userDefaults!.valueForKey("model")
		{
			if (count_modelAnyobj as! String) == "Rocker_model"
			{
				stickActive = true
				handJoyStick(touches)
			}
			else if (count_modelAnyobj as! String) == "Arrow_model"
			{
				
			}
			else
			{
				handleTouches(touches)
			}
		
		}
		else{
		handleTouches(touches)
		}
		
	}
    
	//这个是你放手的时候，才会执行的
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
		if let count_modelAnyobj = player!.userDefaults!.valueForKey("model")
		{
			if (count_modelAnyobj as! String) == "Rocker_model"
			{
				changeControlPlaceJoystick(touches)
				if(stickActive==true)
				{
					let move:SKAction = SKAction.moveTo(base.position, duration: 0.2)
					move.timingMode = .EaseOut
					ball.runAction(move)
					
					
					handJoyStick(touches)
				}
			}
			else if (count_modelAnyobj as! String) == "Arrow_model"
			{
				
			}
			else
			{
				changeControlPlaceNormal(touches)
				handleTouches(touches)
			}
			
		}
		else{
			changeControlPlaceNormal(touches)
			handleTouches(touches)
		}
		
		self.player!.snake.snakeSpeed = 75.0
	}
	
	//摇杆模式的函数
	private func handJoyStick(touches: Set<UITouch>){
		
		if(stickActive==true){
			//updateCamera()
			//print("I am been handled")
				for touch in touches {
					let location = touch.locationInNode(camera!)
					let touchspeed = touch.locationInNode(camera!)
					let v = CGVector(dx:location.x - base.position.x, dy:location.y-base.position.y)
					
					let angle = atan2(v.dy,v.dx)

					let length:CGFloat = base.frame.size.height/4
					
					let xDist:CGFloat = sin(angle-1.57079633) * length
					let yDist:CGFloat = cos(angle-1.57079633) * length
					
					if(CGRectContainsPoint(base.frame, location)){
						ball.position = location
					}else{
						ball.position = CGPointMake(base.position.x-xDist, base.position.y+yDist)
					}
					
					if(CGRectContainsPoint(speed_up!.frame, touchspeed) == false && CGRectContainsPoint(controller.frame, touchspeed) == false)
					{
					self.player?.snake.angle = angle
					}
					else{
						leaveFood()
					}
				}
		}
	}
	
    
	//主要是更新最后的tap 点坐标，lastTouch是个全局变量
	private func handleTouches(touches: Set<UITouch>) {
		
			for touch in touches {
				
				let touchLocation = touch.locationInNode(self)
				let touchspeed = touch.locationInNode(camera!)
				
				if(CGRectContainsPoint(speed_up!.frame, touchspeed) == false && CGRectContainsPoint(controller.frame, touchspeed) == false)
				{
					player!.lastTouch = touchLocation
                    player!.touchedScreen = true
				}
				else{
					leaveFood()
				}
			}
	}
    
	func checkheadposition(head:SKShapeNode){
		if (head.position.x >= 1024 || head.position.x <= leftwall.frame.width || head.position.y >= (leftwall.frame.height - downwall.frame.height) || head.position.y <= downwall.frame.height){
			inToDicks()
			gameOver(false)
		}
	}

	
    // Determines if the player's position should be updated
	private func shouldMove(currentPosition currentPosition: CGPoint, touchPosition: CGPoint) -> Bool {
		return abs(currentPosition.x - touchPosition.x) > self.player!.snake.snakeBodyPoints[0].frame.width / 2 ||
			abs(currentPosition.y - touchPosition.y) > self.player!.snake.snakeBodyPoints[0].frame.height/2
	}
    
    
	/*=============================AI相关=======================================================*/
	// Updates the position of all AI_snakes by moving towards the player
	/*func updateAI_snakes() {
		let targetPosition = self.player.snake.snakeBodyPoints[0].position
		
		for AI_snake in AIs {
			let currentPosition = AI_snake.snake.position
			
			let angle = atan2(currentPosition.y - targetPosition.y, currentPosition.x - targetPosition.x) + CGFloat(M_PI)
			let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0.0)
			AI_snake.runAction(rotateAction)
			
			let velocotyX = AI_snakeSpeed * cos(angle)
			let velocityY = AI_snakeSpeed * sin(angle)
			
			let newVelocity = CGVector(dx: velocotyX, dy: velocityY)
			AI_snake.physicsBody!.velocity = newVelocity;
		}
	}*/
    
	
	
	
	/*===============================物理碰撞相关=================================================*/
	// MARK: - SKPhysicsContactDelegate
	//搞懂这个函数。
	override func didSimulatePhysics() {
		
		if let count_modelAnyobj = player!.userDefaults!.valueForKey("model")
		{
			if (count_modelAnyobj as! String) == "Rocker_model"
			{
				
			}
			else if (count_modelAnyobj as! String) == "Arrow_model"
			{
				
			}
			else
			{
				self.player!.updatePlayer()
			}
			
		}
		else{
			self.player!.updatePlayer()
		}
		
		
		//updateAI_snakes()
		
	}

	func didBeginContact(contact: SKPhysicsContact) {
		// 1. Create local variables for two physics bodies

		print("hello~~")
		
        
        if (contact.bodyA.categoryBitMask + contact.bodyB.categoryBitMask == 5){
            
            self.player!.snake.eatFoodNum+=1
            //player grow
            self.player!.snake.addSnakeLength(1)
            //addSnakeLength(player_snake, length: 1)
            if(contact.bodyA.node?.name == "food")
            {
                contact.bodyA.node?.removeFromParent()
            }
            else
            {
                contact.bodyB.node?.removeFromParent()
            }
            addFood(1)
        }
        else if(contact.bodyA.node?.name == "playerhead"){
            if(contact.bodyB.node!.name!.containsString("aihead") || (contact.bodyB.node!.name! == "aibody") ){
				
				inToDicks()
                gameOver(false)
            }
        }
        else if((contact.bodyA.node?.name?.containsString("aihead")) != nil){
            if(contact.bodyB.node?.name == "food"){
                //ai grow
            }
            else if((contact.bodyB.node?.name?.containsString("aihead")) != nil){
                //ai die both
            }
            else if((contact.bodyB.node?.name!.containsString("aihead")) != nil || contact.bodyB.node!.name! == "playerbody"){
                //A snake die
            }
            else if(contact.bodyB.node?.name == "playerhead"){
				inToDicks()
                gameOver(false)
            }
        }
        else if(contact.bodyA.node?.name == "food"){
            if((contact.bodyB.node?.name?.containsString("aihead")) != nil){
                //ai grow
            }
        }
    }
	
	
	/*===============================食物相关========================================================*/
	
	// Add food when food is eaten by user
	func addFood(n: Int){
		
		for _ in 1...n {
			let food = SKShapeNode(circleOfRadius: 1)
            food.name = "food"
			food.fillColor = UIColor(red:0.22, green:0.41, blue:0.41, alpha:1.0)
			
			let aix = random(min:100, max:1000)
			
			let aiy = random(min:100, max:1920)
			food.position = CGPoint(x:aix, y:aiy)
			
			food.physicsBody = SKPhysicsBody(circleOfRadius: 1)
			food.physicsBody?.dynamic = true
			food.physicsBody?.categoryBitMask = 4
            food.physicsBody?.collisionBitMask = 0xaaaaaaa9
			food.physicsBody?.contactTestBitMask = 0xaaaaaaa9
			food.physicsBody?.affectedByGravity = false
			food.physicsBody?.allowsRotation = false
			addChild(food)
		}
	}
	
	func leaveFood(){
		player?.speedupTapCount++
		print(player?.speedupTapCount)

//		player?.leavedisk()
		if player?.speedupTapCount > 20{
			player?.snake.reduceSnakeLength()
			addFoodwithPostion((player?.snake.snakeBodyPoints[(player?.snake.length)!-1].position)!)
			
			player?.speedupTapCount = 0
		}
		
		

	}
	
	func addFoodwithPostion(positon:CGPoint){
		let food = SKShapeNode(circleOfRadius: 1)
		food.name = "food"
		food.fillColor = UIColor(red:0.22, green:0.41, blue:0.41, alpha:1.0)
		food.position = positon
		
		food.physicsBody = SKPhysicsBody(circleOfRadius: 1)
		food.physicsBody?.dynamic = true
		food.physicsBody?.categoryBitMask = 4
		food.physicsBody?.collisionBitMask = 0xaaaaaaa9
		food.physicsBody?.contactTestBitMask = 0xaaaaaaa9
		food.physicsBody?.affectedByGravity = false
		food.physicsBody?.allowsRotation = false
		addChild(food)

	
	}
	
	func inToDicks(){
	
		for i in (player?.snake.snakeBodyPoints)!{
			addFoodwithPostion(i.position)
		}
		player?.snake.turnIntoDisks()
		
	}
	/*===================================功能函数======================================================*/
	// Helper functions, to generate random CGPoints
	func random() -> CGFloat {
		return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
	}
	
	func random(min min: CGFloat, max: CGFloat) -> CGFloat {
		return random() * (max - min) + min
	}
	
	private func gameOver(didWin: Bool) {
		print("- - - Game Ended - - -")
		
		let menuScene = MenuScene(size: self.size)
		//menuScene.soundToPlay = didWin ? "fear_win.mp3" : "fear_lose.mp3"
		let transition = SKTransition.fadeWithDuration(1)
		menuScene.scaleMode = SKSceneScaleMode.AspectFill
		self.scene!.view?.presentScene(menuScene, transition: transition)
		
		
	}
	/*设置初始的界面*/
/*===================================初始用户信息设置===================================================*/
	//Set default skin
	func setDefaultSkin(player:[SKShapeNode]){
		let userDefaults = NSUserDefaults.standardUserDefaults()
		
		if let count_skinAnyobj = userDefaults.valueForKey("skin") {
			//print(count_skinAnyobj)
			let count_skin = count_skinAnyobj as! Int
			switch count_skin {
			case 0:
				//Snake_with_Skin!.runAction(Actionred)
				for i in player{
				i.fillColor=UIColor.redColor()
					self.player?.snake.snakeColor = i.fillColor
				}
				break
			case 1:
				//Snake_with_Skin!.runAction(Actionblue)
				for i in player{
				i.fillColor=UIColor.blueColor()
					self.player?.snake.snakeColor = i.fillColor
				}
				break
			case 2:
				//Snake_with_Skin!.runAction(Actionwhite)
				for i in player{
				i.fillColor=UIColor.grayColor()
					self.player?.snake.snakeColor = i.fillColor
				}
				break
			default:
				//Snake_with_Skin!.runAction(Actionbrown)
				for i in player{
				i.fillColor=UIColor.brownColor()
					self.player?.snake.snakeColor = i.fillColor
				}
				break
			}
		}
		else {
			for i in player{
				i.fillColor=UIColor.grayColor()
				self.player?.snake.snakeColor = i.fillColor
			}
			print("No color")
		}

	}
	//Set default model
	func setDefaultModel(){
		
		
		if let count_modelAnyobj = player!.userDefaults!.valueForKey("model") {
			//print(count_modelAnyobj)
			let count_model = count_modelAnyobj as! String
			switch count_model {
			case "Arrow_model":
				print("Arrow")
				break
			case "Rocker_model":
				base.position.x = (camera?.position.x)! - 500
				base.position.y = (camera?.position.y)! + 500
				base.zPosition=6
				//base.position = CGPointMake(150, 200)
				base.size=CGSize(width: 300,height: 300)
				
				ball.position.x = (camera?.position.x)! - 500
				ball.position.y = (camera?.position.y)! + 500
				ball.zPosition=6
				//ball.position = CGPointMake(150,200)
				ball.size=CGSize(width: 100,height: 100)
				camera!.addChild(base)
				camera!.addChild(ball)
				
				break
			
			default:
				print("Default")
				break
			}
		}
		else {
			//set normal way
			print("Normal_model")
		}

	}
	
	//setup camera
	func setupCamera(){
		if let camera_frame = camera{
			let light = SKLightNode()
			light.falloff = 2
			light.ambientColor = UIColor.blackColor()
			light.shadowColor = UIColor.darkGrayColor()
			//lightingBitMask = 1
			
			//.mask
			player?.snake.snakeBodyPoints[0].addChild(light)
			
			controller.position.x = (camera?.position.x)! - 420
			controller.position.y =  (camera?.position.y)! - 1100
			controller.setScale(0.3)
			controller.zPosition = 10
			
			speed_up = SKSpriteNode(imageNamed:"rocket-512")
			speed_up?.position.x = (camera?.position.x)! - 620
			speed_up?.position.y = (camera?.position.y)! - 1100
			speed_up?.size = CGSize(width: 100,height: 100)
			
			speed_up?.zPosition = 10
			
			
			if let speed = speed_up{
				camera_frame.addChild(speed)
			}else{
				print("no speed up")
			}
			
				camera_frame.addChild(controller)
			
			
		}
		
		if let username = userDefaults.valueForKey("username") {
			let label = SKLabelNode(text: username as? String)
			print(username)
			print("gggggggg")
			label.fontName = "AvenirNext-Bold"
			label.fontSize = 40
			label.fontColor = UIColor.whiteColor()
			label.position.x = (camera?.position.x)! + 150
			label.position.y = (camera?.position.y)! - 1200
			//addChild(label)
			if let camera_frame = camera{
			camera_frame.addChild(label)
			
			}
			// Setup initial camera component
			
		}else{
			print("f+ck")
		}
		
		
	}
	func updateCamera() {
		if let camera = camera {
			camera.position = CGPoint(x: self.player!.snake.snakeBodyPoints[0].position.x, y: self.player!.snake.snakeBodyPoints[0].position.y)
		}
		
		if let length = self.player?.snake.length{
			print(length)
			var increment = length%9
			if(increment == 8 && length < 25){
				print(camera?.frame.size)
				var s = 0.1 + CGFloat(Float(length)/200.0)
				print(s)
				let zoomInAction = SKAction.scaleTo(s, duration: 1)
				camera!.runAction(zoomInAction)

			}
		}
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	func handleArrowTap(){
		
	
	}
	
	func changeControlPlaceNormal(touches: Set<UITouch>){
		for touch in touches{
			let touched = touch.locationInNode(camera!)
			if(CGRectContainsPoint(controller.frame, touched) == true){
				
				controllerFlag += 1
				controllerFlag = controllerFlag%2
				if(controllerFlag==1){
					
					let pos = CGPoint(x: -200,y: 673)
					
					
					let move_speed = SKAction.moveTo(pos, duration: 1)
					
					
					speed_up?.runAction(move_speed)
					
					
				}else{
					
					let pos = CGPoint(x:-367,y:-626)
					
					let move_speed = SKAction.moveTo(pos, duration: 1)
					speed_up?.runAction(move_speed)
					
					
					
				}
			}
			
		}
	
	}
	
	func changeControlPlaceJoystick(touches: Set<UITouch>){
	
		for touch in touches{
			let touched = touch.locationInNode(camera!)
			if(CGRectContainsPoint(controller.frame, touched) == true){
			
				controllerFlag += 1
				controllerFlag = controllerFlag%2
				if(controllerFlag==1){
					print((camera?.position.x)! - 500)
					print((camera?.position.y)! + 500)
					print((camera?.position.x)! - 720)
					print((camera?.position.y)! - 1100)
					let pos = CGPoint(x: -200,y: 673)
					let pos2 = CGPoint(x:-367,y:-626)
					
					let move_speed = SKAction.moveTo(pos, duration: 1)
					let move_joystick = SKAction.moveTo(pos2, duration: 1)
					
					speed_up?.runAction(move_speed)
					ball.runAction(move_joystick)
					base.runAction(move_joystick)
					
				}else{
					
					let pos = CGPoint(x:-367,y:-626)
					let pos2 = CGPoint(x: -200,y: 673)
					let move_speed = SKAction.moveTo(pos, duration: 1)
					speed_up?.runAction(move_speed)
					let move_joystick = SKAction.moveTo(pos2, duration: 1)
					
					ball.runAction(move_joystick)
					base.runAction(move_joystick)
					
				
				}
			}
		
		}
		

	}
	
	
}
