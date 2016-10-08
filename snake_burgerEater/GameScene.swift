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
	
	var alph = 0.600
	var beta = 1.000
	var gama = 1.000
	var time: NSTimeInterval = 0
	
	var radius = 10.0
	
	var foodcount = 0
	/*摇杆的代码*/
	var stickActive : Bool = false
	let base = SKSpriteNode(imageNamed:"circle")
	let ball = SKSpriteNode(imageNamed:"ball")
	
	let userDefaults = NSUserDefaults.standardUserDefaults()

	var color = UIColor.grayColor()
	
	//这是AI的速度
	let AI_snakeSpeed: CGFloat = 75.0
	
	//加速按钮
	var speed_up: SKSpriteNode?
	
	//这是我们的蛇
	var player_snake: [SKShapeNode]=[]
	
	//这是AI snake 的数组
	var AI : [[SKShapeNode]] = []
	
	var AI_snakes: [SKShapeNode] = []
	
	//food array
	var foods: [SKSpriteNode] = []
	
	//最后触碰的点
	//var lastTouch: CGPoint? = nil
	
	var player = Player()
	
	//init the wall
	var leftwall = SKSpriteNode()
	var rightwall = SKSpriteNode()
	var topwall = SKSpriteNode()
	var downwall = SKSpriteNode()
	
	// MARK: - SKScene
	
	override func didMoveToView(view: SKView) {
		
		setupCamera()
		
		leftwall = self.childNodeWithName("leftwall") as! SKSpriteNode
		rightwall = self.childNodeWithName("rightwall") as! SKSpriteNode
		topwall = self.childNodeWithName("topwall") as! SKSpriteNode
		downwall = self.childNodeWithName("downwall") as! SKSpriteNode
		
		
		
		player.playersnakes = player_snake
		
		player.userDefaults = NSUserDefaults.standardUserDefaults()
		
		player.playerSpeed = 150.0
		
		// Setup player
		//开启多点触控模式
		self.view?.multipleTouchEnabled = true
		
		// Build user snake array
		addPlayer(3)
		
		// Build AI snake array
		
		addAiSnake(20, bitnum: 4)
		
		//add food
		addFood(20)
		
		//设置用户的皮肤和操作模式
		setDefaultSkin(player.playersnakes)
		setDefaultModel()
		
		// Setup physics world's contact delegate
		physicsWorld.contactDelegate = self
		
	}
	
	

	/*=============================神级update函数=====================================================*/
	
	override func update(currentTime: NSTimeInterval) {
		if (currentTime-time > 50)
		{
			updatePlayer()
			time=currentTime
		}
	}

	
	/*=============================touch点相关=======================================================*/
	//这是函数是你刚tap下去就会发生的事
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
		if let count_modelAnyobj = player.userDefaults!.valueForKey("model")
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
				//print(position)
				 player.playerSpeed = 300.0
			}
		}
		
	}
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if let count_modelAnyobj = player.userDefaults!.valueForKey("model")
		{
			if (count_modelAnyobj as! String) == "Rocker_model"
			{
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
		if let count_modelAnyobj = player.userDefaults!.valueForKey("model")
		{
			if (count_modelAnyobj as! String) == "Rocker_model"
			{
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
				handleTouches(touches)
			}
			
		}
		else{
			handleTouches(touches)
		}
		
		player.playerSpeed = 100.0
	}
	
	//摇杆模式的函数
	private func handJoyStick(touches: Set<UITouch>){
		if(stickActive==true){
				for touch in touches {
					let location = touch.locationInNode(camera!)
					
					var v = CGVector(dx:location.x - base.position.x, dy:location.y-base.position.y)
					
					
					
					
					let angle = atan2(v.dy,v.dx)

					let length:CGFloat = base.frame.size.height/4
					
					let xDist:CGFloat = sin(angle-1.57079633) * length
					let yDist:CGFloat = cos(angle-1.57079633) * length
					
					if(CGRectContainsPoint(base.frame, location)){
						ball.position = location
					}else{
						ball.position = CGPointMake(base.position.x-xDist, base.position.y+yDist)
					}
					updatePlayerWithKeepMoving(v)
				}
				
		
		
	
		}
	}
	
	//主要是更新最后的tap 点坐标，lastTouch是个全局变量
	private func handleTouches(touches: Set<UITouch>) {
		
			for touch in touches {
				
				let touchLocation = touch.locationInNode(self)
				
				let touchspeed = touch.locationInNode(camera!)
				
				if(CGRectContainsPoint(speed_up!.frame, touchspeed) == false)
				{
					player.lastTouch = touchLocation
				}
			}
	}
	// MARK - Updates
	/*===============================蛇类通用函数======================================================*/
	
	///////////////////////////////////////////////////////////////////////////////////////////////////
	func addSnakeLength(snake:[SKShapeNode], length:Int){
		//var bitMask = snake[1].physicsBody?.categoryBitMask
		//var collisionMask = snake[1].physicsBody?.collisionBitMask
		//var contactTestMask = snake[1].physicsBody?.contactTestBitMask
		
		for var i = 0; i < length; i++ {
			let snake = SKShapeNode(circleOfRadius: CGFloat(radius))
			snake.fillColor = color
			//print(player.playersnakes.count)
			snake.position =  CGPoint(x:player.playersnakes[player.playersnakes.count-1].position.x+5, y:player.playersnakes[player.playersnakes.count-1].position.y+5)
			snake.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(radius))
			snake.physicsBody?.dynamic = true
			
			snake.name = "playerbody"
			snake.physicsBody?.categoryBitMask = 0x00000002
			snake.physicsBody?.collisionBitMask = 0xaaaaaaa8
			snake.physicsBody?.contactTestBitMask = 0xaaaaaaa8
			
			snake.physicsBody?.affectedByGravity = false
			snake.physicsBody?.allowsRotation = false
			
			player.playersnakes.append(snake)
			addChild(snake)
			
			if(foodcount >= 3)
			{
				print("opopop")
				changePlayerSankeWidth()
				foodcount=0
			}
		}
	}
	func checkheadposition(head:SKShapeNode){
		
		if (head.position.x >= 1024 || head.position.x <= leftwall.frame.width || head.position.y >= (leftwall.frame.height - downwall.frame.height) || head.position.y <= downwall.frame.height){
			
			gameOver(false)
			
		}
		
	}

	/*=============================Player相关=======================================================*/
	// Updates the player's position by moving towards the last touch made
	func updatePlayer() {
		//print("updatePlayer")
		print(player.playersnakes[0].physicsBody!.velocity.dx)
		player.playersnakes[0].physicsBody!.velocity.dx = player.playersnakes[0].physicsBody!.velocity.dx + 1
		player.playersnakes[0].physicsBody!.velocity.dy = player.playersnakes[0].physicsBody!.velocity.dx + 1
		
		if let touch = player.lastTouch {
			//print(touch)
			//这里是吧第一个蛇头的点，给到当前的current
			let currentPosition = player.playersnakes[0].position
			//print(player.playersnakes[0])
			checkheadposition(player.playersnakes[0])
			
				
				var angle = atan2((currentPosition.y - touch.y), (currentPosition.x - touch.x)) + CGFloat(M_PI)
				//let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0)
				
				
				
				let velocotyX = player.playerSpeed! * cos(angle)
				//print(velocotyX)
				let velocityY = player.playerSpeed! * sin(angle)
				//print(velocityY)
				var newVelocity = CGVector(dx: velocotyX, dy: velocityY)
				
				var i=0

				
				
				for(i=0;i<player.playersnakes.count-1;i += 1){
					
					player.playersnakes[i].physicsBody!.velocity = newVelocity;
					
					angle = atan2(player.playersnakes[i+1].position.y - player.playersnakes[i].position.y, player.playersnakes[i+1].position.x - player.playersnakes[i].position.x) + CGFloat(M_PI)
					let velocotyX = player.playerSpeed! * cos(angle)
					let velocityY = player.playerSpeed! * sin(angle)
					
					newVelocity = CGVector(dx: velocotyX, dy: velocityY)
				}
				player.playersnakes[i].physicsBody!.velocity = newVelocity;
				
			player.playersnakes[i].physicsBody!.velocity.dx = player.playersnakes[i].physicsBody!.velocity.dx + 1
			player.playersnakes[i].physicsBody!.velocity.dy = player.playersnakes[i].physicsBody!.velocity.dx + 1
				
					
				
				
				updateCamera()
			
		}
	}
	func addPlayer(n:Int){
		
		// Build user snake array
		for var i = 0; i <= n; i = i+1 {
			
			
			
			let snake = SKShapeNode(circleOfRadius: CGFloat(radius))
			snake.fillColor = color
			snake.position = CGPoint(x:200+i*5, y:200)
			snake.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(radius))
			snake.physicsBody?.dynamic = true
			//头是1，身体是2
			if(i==0){
				snake.name = "playerhead"
				snake.physicsBody?.categoryBitMask = 0x00000001
				snake.physicsBody?.collisionBitMask = 0x00000004//0xfffffffc
				snake.physicsBody?.contactTestBitMask = 0xfffffffc
			}else{
				snake.name = "playerbody"
				snake.physicsBody?.categoryBitMask = 0x00000002
				snake.physicsBody?.collisionBitMask = 0xaaaaaaa8
				snake.physicsBody?.contactTestBitMask = 0xaaaaaaa8
			}
			
			snake.physicsBody?.affectedByGravity = false
			snake.physicsBody?.allowsRotation = false
			addChild(snake)
			player.playersnakes.append(snake)
			
		}
		
		
	}
	func updatePlayerWithKeepMoving(v:CGVector){
		
		var newVelocity = v
		var i=0
		for(i=0;i<player.playersnakes.count-1;i++){
			
			
			player.playersnakes[i].physicsBody!.velocity = newVelocity;
			var angle = atan2(player.playersnakes[i+1].position.y - player.playersnakes[i].position.y, player.playersnakes[i+1].position.x - player.playersnakes[i].position.x) + CGFloat(M_PI)
			let velocotyX = base.frame.size.height/4 * cos(angle)
			let velocityY = base.frame.size.height/4 * sin(angle)
			
			newVelocity = CGVector(dx: velocotyX, dy: velocityY)
			
		}
		player.playersnakes[i].physicsBody!.velocity = newVelocity;
		
	}
	func updatePlayerMoving(){
		
		
		var i=0
		for(i=0;i<player.playersnakes.count-1;i++){
			
			player.playersnakes[i+1].position.x = player.playersnakes[i].position.x
			
			player.playersnakes[i+1].position.y = player.playersnakes[i].position.y
			
			
			
			
		}
		
	}
	// Determines if the player's position should be updated
	private func shouldMove(currentPosition currentPosition: CGPoint, touchPosition: CGPoint) -> Bool {
		return abs(currentPosition.x - touchPosition.x) > player.playersnakes[0].frame.width / 2 ||
			abs(currentPosition.y - touchPosition.y) > player.playersnakes[0].frame.height/2
	}
	func changePlayerSankeWidth(){
		print("hhhhhhhh")
		
		
		for(var i=0;i<player.playersnakes.count;i++)
		{
			print("kjkjkj")
			
			
			player.playersnakes[i].setScale(1.21)
			
		}
		
		radius = radius * 1.1
		
	}
	
	/*=============================AI相关=======================================================*/
	// Updates the position of all AI_snakes by moving towards the player
	func updateAI_snakes() {
		let targetPosition = player.playersnakes[0].position
		
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
	// Add one AI snake with length n
	func radomAddAiSnakePot(n: Int,bitmask:Int, index:Int){
		
		let aix = random(min:100, max:1000)
		let aiy = random(min:100, max:1920)
		
		let aiHeadBitMask = UInt32(bitmask)
		let aiBodyBitMask = aiHeadBitMask << 2
		for var i = 0; i <= n; i=i+1 {
			let ai = SKShapeNode(circleOfRadius: 10)
			ai.fillColor = UIColor(red:0.96, green:0.41, blue:0.41, alpha:1.0)
			
			ai.position = CGPoint(x:Int(aix) + i*5, y:Int(aiy) + i*5)
			
			ai.physicsBody = SKPhysicsBody(circleOfRadius: 10)
			ai.physicsBody?.dynamic = true
			
			if(i == 1){
				ai.name = "aihead"+(index as NSNumber).stringValue
				ai.physicsBody?.categoryBitMask = aiHeadBitMask
				ai.physicsBody?.collisionBitMask = ~(aiHeadBitMask | aiBodyBitMask)
				ai.physicsBody?.contactTestBitMask = ~(aiHeadBitMask | aiBodyBitMask)
			}else{
				ai.name = "aibody"
				ai.physicsBody?.categoryBitMask = aiBodyBitMask
				ai.physicsBody?.collisionBitMask = ~(aiHeadBitMask | aiBodyBitMask | 4)
				ai.physicsBody?.contactTestBitMask = ~(aiHeadBitMask | aiBodyBitMask | 4)
			}
			
			ai.physicsBody?.affectedByGravity = false
			ai.physicsBody?.allowsRotation = false
			
			addChild(ai)
			AI_snakes.append(ai)
			AI.append(AI_snakes)
			
		}
	}
	//按坐标加点
	func addAisnakePot(postion:CGPoint){
		
		
	}
	//加入AI snake, n 是数量
	func addAiSnake(n:Int,bitnum:Int){
		
		//bitnum从4开始
		var bit_num=2
		var snakeNum:Int
		if(n>14){
			snakeNum = 14
		}else{
			snakeNum = n
		}
		
		for var i = 0; i <= snakeNum; i = i+1 {
			bit_num = bit_num*4
			// 4 is the length of the AI snake
			//bitnum is egual and bigger than 4
			radomAddAiSnakePot(4,bitmask: bit_num,index: i)
		}
		
	}
	
	
	
	/*===============================物理碰撞相关=================================================*/
	// MARK: - SKPhysicsContactDelegate
	//搞懂这个函数。
	override func didSimulatePhysics() {
		
		if let count_modelAnyobj = player.userDefaults!.valueForKey("model")
		{
			if (count_modelAnyobj as! String) == "Rocker_model"
			{
				
			}
			else if (count_modelAnyobj as! String) == "Arrow_model"
			{
				
			}
			else
			{
				updatePlayer()
			}
			
		}
		else{
			updatePlayer()
		}
		
		
		//updateAI_snakes()
		
	}

	func didBeginContact(contact: SKPhysicsContact) {
		// 1. Create local variables for two physics bodies

		print("hello~~")
		
        
        if (contact.bodyA.categoryBitMask + contact.bodyB.categoryBitMask == 5){
            //player grow
            addSnakeLength(player_snake, length: 1)
            if(contact.bodyA.node?.name == "food")
            {
                contact.bodyA.node?.removeFromParent()
            }
            else
            {
                contact.bodyB.node?.removeFromParent()
            }
            addFood(1)
			foodcount = foodcount + 1
        }
        else if(contact.bodyA.node?.name == "playerhead"){
            if(contact.bodyB.node!.name!.containsString("aihead") || (contact.bodyB.node!.name! == "aibody") ){
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
		
		for var i = 1; i <= n; i = i+1 {
			let food = SKShapeNode(circleOfRadius: 4)
            food.name = "food"
			food.fillColor = UIColor(red:0.22, green:0.41, blue:0.41, alpha:1.0)
			
			let aix = random(min:100, max:1000)
			
			let aiy = random(min:100, max:1920)
			food.position = CGPoint(x:aix, y:aiy)
			
			food.physicsBody = SKPhysicsBody(circleOfRadius: 3)
			food.physicsBody?.dynamic = true
			food.physicsBody?.categoryBitMask = 4
            food.physicsBody?.collisionBitMask = 0xaaaaaaa9
			food.physicsBody?.contactTestBitMask = 0xaaaaaaa9
			food.physicsBody?.affectedByGravity = false
			food.physicsBody?.allowsRotation = false
			addChild(food)
		}
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
					color = i.fillColor
				}
				break
			case 1:
				//Snake_with_Skin!.runAction(Actionblue)
				for i in player{
				i.fillColor=UIColor.blueColor()
					color = i.fillColor
				}
				break
			case 2:
				//Snake_with_Skin!.runAction(Actionwhite)
				for i in player{
				i.fillColor=UIColor.grayColor()
					color = i.fillColor
				}
				break
			default:
				//Snake_with_Skin!.runAction(Actionbrown)
				for i in player{
				i.fillColor=UIColor.brownColor()
					color = i.fillColor
				}
				break
			}
		}
		else {
			for i in player{
				i.fillColor=UIColor.grayColor()
				color = i.fillColor
			}
			print("No color")
		}

	}
	//Set default model
	func setDefaultModel(){
		
		
		if let count_modelAnyobj = player.userDefaults!.valueForKey("model") {
			//print(count_modelAnyobj)
			let count_model = count_modelAnyobj as! String
			switch count_model {
			case "Arrow_model":
				print("Arrow")
				break
			case "Rocker_model":
				base.position.x = (camera?.position.x)! - 400
				base.position.y = (camera?.position.y)! - 1100
				
				//base.position = CGPointMake(150, 200)
				base.size=CGSize(width: 300,height: 300)
				
				ball.position.x = (camera?.position.x)! - 400
				ball.position.y = (camera?.position.y)! - 1100
				
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
		
		if let username = userDefaults.valueForKey("username") {
			let label = SKLabelNode(text: username as! String)
			print(username)
			print("gggggggg")
			label.fontName = "AvenirNext-Bold"
			label.fontSize = 40
			label.fontColor = UIColor.whiteColor()
			label.position.x = (camera?.position.x)! + 150
			label.position.y = (camera?.position.y)! - 1200
			//addChild(label)
			
			
			speed_up = SKSpriteNode(imageNamed:"rocket-512")
			speed_up?.position.x = (camera?.position.x)! - 620
			speed_up?.position.y = (camera?.position.y)! - 1100
			
			
			
			speed_up?.size = CGSize(width: 100,height: 100)
			
			speed_up?.zPosition = 10
			
			
			// Setup initial camera component
			
			
			
			if let camera_frame = camera{
				camera_frame.addChild(label)
				if let speed = speed_up{
					camera_frame.addChild(speed_up!)
				}else{
					print("no speed up")
				}
			}
			
		}else{
			print("f+ck")
		}
		
		
	}
	func updateCamera() {
		if let camera = camera {
			camera.position = CGPoint(x: player.playersnakes[0].position.x, y: player.playersnakes[0].position.y)
			
			
		}
		
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	func handleArrowTap(){
		
	
	}
	
	
	
}
