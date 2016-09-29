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
	
	
	
	
	var stickActive : Bool = false
	
	//load user default
	//let userDefaults = NSUserDefaults.standardUserDefaults()
	// MARK: - Instance Variables
	//var Database_player = Player()// in the database
	
	let base = SKSpriteNode(imageNamed:"circle")
	let ball = SKSpriteNode(imageNamed:"ball")
	
	
	
	//Set game paramter
	//var playerSpeed: CGFloat = 150.0
	
	
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
	
	// MARK: - SKScene
	
	override func didMoveToView(view: SKView) {
		
		
		
		
		
		player.playersnakes = player_snake
		
		player.userDefaults = NSUserDefaults.standardUserDefaults()
		
		player.playerSpeed = 150.0
		
		// Setup player
		//开启多点触控模式
		self.view?.multipleTouchEnabled = true
		
		// Build user snake array
		addPlayer(2)
		
		
		
		// Build AI snake array
		
		addAiSnake(20, bitnum: 4)
		
		//add food
		addFood(20)

		
		
		
		
		//同理
		speed_up = self.childNodeWithName("speed_up") as? SKSpriteNode
		
		
		//set player Skin and Model
		
		//设置用户的皮肤和操作模式
		setDefaultSkin(player.playersnakes)
		setDefaultModel()
		
		//到这里位置，我们的用户是一个sknode，我们的用户颜色有了。
		
		
//		// Setup AI_snakes
//		for child in self.children {
//			if child.name == "AI_snake" {
//				if let child = child as? SKSpriteNode {
//					AI_snakes.append(child)
//				}
//			}
//		}
		
		
		// Setup physics world's contact delegate
		physicsWorld.contactDelegate = self
		
		// Setup initial camera position
		updateCamera()
	}
	
	

	// Helper functions, to generate random CGPoints
	func random() -> CGFloat {
		return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
	}
	
	func random(min min: CGFloat, max: CGFloat) -> CGFloat {
		return random() * (max - min) + min
	}
	
	func screenSize() -> (CGFloat, CGFloat){
		let screenSize: CGRect = UIScreen.mainScreen().bounds
		let width = screenSize.width
		let height = screenSize.height
		return (width, height)
	}

	
	
	//这是函数是你刚tap下去就会发生的事
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
		if let count_modelAnyobj = player.userDefaults!.valueForKey("model")
		{
			if (count_modelAnyobj as! String) == "Rocker_model"
			{
				for touch in (touches ){
					let location = touch.locationInNode(self)
					if(CGRectContainsPoint(ball.frame, location)){
						stickActive = true
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
			let position = touch.locationInNode(self) // Get the x,y point of the touch
			if CGRectContainsPoint(speed_up!.frame, position) {
				print(position)
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
		
		player.playerSpeed = 150.0
	}
	
	//摇杆模式的函数
	private func handJoyStick(touches: Set<UITouch>){
		if(stickActive==true){
				for touch in touches {
					let location = touch.locationInNode(self)
					
					let v = CGVector(dx:location.x - base.position.x, dy:location.y-base.position.y)
					let angle = atan2(v.dy,v.dx)
					
					let deg = angle*CGFloat(180/M_PI)
					
					let length:CGFloat = base.frame.size.height/4
					let xDist:CGFloat = sin(angle-1.57079633) * length
					let yDist:CGFloat = cos(angle-1.57079633) * length
					
					if(CGRectContainsPoint(base.frame, location)){
						ball.position = location
					}else{
						ball.position = CGPointMake(base.position.x-xDist, base.position.y+yDist)
					}
					
				}
				
				
		
	
		}
		
		
	}
	
	//主要是更新最后的tap 点坐标，lastTouch是个全局变量
	private func handleTouches(touches: Set<UITouch>) {
		
		
			for touch in touches {
				let touchLocation = touch.locationInNode(self)
				player.lastTouch = touchLocation
			}
		
	}
	
	
	// MARK - Updates
	
	
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
			
			
			updateAI_snakes()
		
	}
	
	// Determines if the player's position should be updated
	private func shouldMove(currentPosition currentPosition: CGPoint, touchPosition: CGPoint) -> Bool {
		return abs(currentPosition.x - touchPosition.x) > player.playersnakes[0].frame.width / 2 ||
			abs(currentPosition.y - touchPosition.y) > player.playersnakes[0].frame.height/2
	}
	
	// Updates the player's position by moving towards the last touch made
	func updatePlayer() {
		if let touch = player.lastTouch {
			
			//这里是吧第一个蛇头的点，给到当前的current
			let currentPosition = player.playersnakes[0].position
			
			
			if shouldMove(currentPosition: currentPosition, touchPosition: touch) {
				
				let angle = atan2(currentPosition.y - touch.y, currentPosition.x - touch.x) + CGFloat(M_PI)
				let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0)
				
				player.playersnakes[0].runAction(rotateAction)
				
				let velocotyX = player.playerSpeed! * cos(angle)
				let velocityY = player.playerSpeed! * sin(angle)
				
				let newVelocity = CGVector(dx: velocotyX, dy: velocityY)
				
				for(var i=0;i<player.playersnakes.count;i += 1){
					player.playersnakes[i].physicsBody!.velocity = newVelocity;
				}
				
				updateCamera()
			} else {
				for(var i=0;i<player.playersnakes.count;i++){
					player.playersnakes[i].physicsBody!.resting = true
				}
				
				
			}
		}
	}
	
	func updateCamera() {
		if let camera = camera {
			camera.position = CGPoint(x: player.playersnakes[0].position.x, y: player.playersnakes[0].position.y)
		}
	}
	
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
	
	
	// MARK: - SKPhysicsContactDelegate
	//搞懂这个函数。
	func didBeginContact(contact: SKPhysicsContact) {
		// 1. Create local variables for two physics bodies
		var firstBody: SKPhysicsBody
		var secondBody: SKPhysicsBody
		
		
		// 2. Make sure the user object is always stored in "firstBody"
		//当两个碰撞在一起的时候，加起来小于4的情况，就是player和食物相遇。
		if contact.bodyA.categoryBitMask + contact.bodyB.categoryBitMask <= 4{
			if contact.bodyA.categoryBitMask == 1{
				firstBody = contact.bodyA
				secondBody = contact.bodyB
			} else{
				firstBody = contact.bodyB
				secondBody = contact.bodyA
			}
			
			
			
			
			
			// 3. Proceed based on which object the user hits
			
			if(secondBody.categoryBitMask == 3){
				print("Snake just eat a food")
				//self.player!.size = CGSize(width: player!.frame.size.width*1.002, height: player!.frame.size.height*1.002)
				if let foodnode = secondBody.node{
					
					foodnode.removeFromParent()
				}
				
				addFood(1)
			}
		}
			//就是两个碰撞在一起都大于3，说明是AI 和 AI 相遇了
		else if contact.bodyA.categoryBitMask>=4 && contact.bodyB.categoryBitMask>=4{
			
		
		}
			//说明1 和 4或者4以上的碰到了。 那就是 自己的头和 AI 的全部
		else if (contact.bodyA.categoryBitMask + contact.bodyB.categoryBitMask >= 6){
			if (contact.bodyA.categoryBitMask == 2){
				//AI 就是BodyB 要死
			}
			else if(contact.bodyB.categoryBitMask == 2){
				// AI 就是BodyA 要死
			}
				//如果是bodyA 是头
			else if(contact.bodyA.categoryBitMask==1){
				//gameover
			}
			else if(contact.bodyB.categoryBitMask==1){
				//gameover
			}
		}

		
		
	}
	
	
	// Add food when food is eaten by user
	func addFood(n: Int){
		
		for var i = 1; i <= n; i++ {
			let food = SKShapeNode(circleOfRadius: 4)
			food.fillColor = UIColor(red:0.22, green:0.41, blue:0.41, alpha:1.0)
			
			let aix = random(min:100, max:1000)
			print(screenSize())
			let aiy = random(min:100, max:1920)
			food.position = CGPoint(x:aix, y:aiy)
			
			food.physicsBody = SKPhysicsBody(circleOfRadius: 3)
			food.physicsBody?.dynamic = true
			food.physicsBody?.categoryBitMask = 3
			food.physicsBody?.contactTestBitMask = 1
			food.physicsBody?.affectedByGravity = false
			food.physicsBody?.allowsRotation = false

			addChild(food)
		}
	}
	
	// Add one AI snake with length n
	func radomAddAiSnakePot(n: Int,bitmask:Int){
		
		let aix = random(min:100, max:1000)
		let aiy = random(min:100, max:1920)
		
		for var i = 0; i <= n; i++ {
			let ai = SKShapeNode(circleOfRadius: 10)
			ai.fillColor = UIColor(red:0.96, green:0.41, blue:0.41, alpha:1.0)
			
			
			ai.position = CGPoint(x:Int(aix) + i*5, y:Int(aiy) + i*5)
			
			
			
			ai.physicsBody = SKPhysicsBody(circleOfRadius: 10)
			ai.physicsBody?.dynamic = true
			
			ai.physicsBody?.categoryBitMask = UInt32(bitmask)
			
			ai.physicsBody?.contactTestBitMask = 1
			ai.physicsBody?.affectedByGravity = false
			ai.physicsBody?.allowsRotation = false
			
			addChild(ai)
			AI_snakes.append(ai)
			
			
			
		}
	
	
	}
	
	//按坐标加点
	func addAisnakePot(postion:CGPoint){
		
	
	}
	
	
	//加入AI snake, n 是数量
	func addAiSnake(n:Int,bitnum:Int){
		
		//bitnum从4开始
		var bit_num=bitnum
		for var i = 0; i <= n; i++ {
			bit_num++
			// 4 is the length of the AI snake
			//bitnum is egual and bigger than 4
			radomAddAiSnakePot(4,bitmask: bit_num)
		}
	
	}

	func addPlayer(n:Int){
		
		// Build user snake array
		for var i = 0; i <= n; i++ {
			let snake = SKShapeNode(circleOfRadius: 10)
			snake.fillColor = UIColor(red:0.91, green:0.89, blue:0.49, alpha:1.0)
			snake.position = CGPoint(x:200+i*5, y:200)
			snake.physicsBody = SKPhysicsBody(circleOfRadius: 10)
			snake.physicsBody?.dynamic = true
			//头是1，身体是2
			if(i==0){
			snake.physicsBody?.categoryBitMask = 1
			}else{
				snake.physicsBody?.categoryBitMask = 2
			}
			
			snake.physicsBody?.contactTestBitMask = 0
			snake.physicsBody?.affectedByGravity = false
			snake.physicsBody?.allowsRotation = false
			addChild(snake)
			player.playersnakes.append(snake)
			
		}

	
	}
	
	
	
	//Set default skin
	func setDefaultSkin(player:[SKShapeNode]){
		let userDefaults = NSUserDefaults.standardUserDefaults()
		
		if let count_skinAnyobj = userDefaults.valueForKey("skin") {
			print(count_skinAnyobj)
			let count_skin = count_skinAnyobj as! Int
			switch count_skin {
			case 0:
				//Snake_with_Skin!.runAction(Actionred)
				for i in player{
				i.fillColor=UIColor.redColor()
				}
				break
			case 1:
				//Snake_with_Skin!.runAction(Actionblue)
				for i in player{
				i.fillColor=UIColor.blueColor()
				}
				break
			case 2:
				//Snake_with_Skin!.runAction(Actionwhite)
				for i in player{
				i.fillColor=UIColor.grayColor()
				}
				break
			default:
				//Snake_with_Skin!.runAction(Actionbrown)
				for i in player{
				i.fillColor=UIColor.brownColor()
				}
				break
			}
		}
		else {
			for i in player{
				i.fillColor=UIColor.grayColor()
			}
			print("No color")
		}

	}
	//Set default model
	func setDefaultModel(){
		
		
		if let count_modelAnyobj = player.userDefaults!.valueForKey("model") {
			print(count_modelAnyobj)
			let count_model = count_modelAnyobj as! String
			switch count_model {
			case "Arrow_model":
				print("Arrow")
				break
			case "Rocker_model":
				base.position = CGPointMake(150, 200)
				base.size=CGSize(width: 300,height: 300)
				ball.position = CGPointMake(150,200)
				ball.size=CGSize(width: 100,height: 100)
				addChild(base)
				addChild(ball)
				
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
	// MARK: Helper Functions
	
	private func gameOver(didWin: Bool) {
		print("- - - Game Ended - - -")
		
		let menuScene = MenuScene(size: self.size)
		//menuScene.soundToPlay = didWin ? "fear_win.mp3" : "fear_lose.mp3"
		let transition = SKTransition.fadeWithDuration(1)
		menuScene.scaleMode = SKSceneScaleMode.AspectFill
		self.scene!.view?.presentScene(menuScene, transition: transition)
		

	}
	
	
	func handleArrowTap(){
		
	
	}
	
	
	
}
