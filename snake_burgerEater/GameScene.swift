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

var timecount = 1000
var countfood = 0

class GameScene: SKScene, SKPhysicsContactDelegate , UINavigationControllerDelegate{
    
    
    
    
    let lblScore = SKLabelNode()
    var color = UIColor.grayColor()
    //Game Class
    //var time: NSTimeInterval = 0
    
    /*摇杆的代码*/
    var stickActive : Bool = false
    let base = SKSpriteNode(imageNamed:"circle")
    let ball = SKSpriteNode(imageNamed:"ball")
    let controller = SKSpriteNode(imageNamed:"changeControl")
    var controllerFlag = 0
    
    /*Arrow model code*/
    var ArrowActive : Bool = false
    let pointArrow = SKSpriteNode(imageNamed:"ball")
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    //加速按钮
    var speed_up: SKSpriteNode?
    
    var player:Player?
    var otherPlayers:[String:Player] = [:]
    var otherPlayersList:[Player] = []
    //这是AI snake 的数组
    var AIs:[AI] = []
    
    
    var foods:[SKShapeNode] = []
    var superFoods:[SKShapeNode] = []
    
    var userDataInfo:[String:AnyObject] = [:]
    var mappingUserIndex:[String: Int] = [:]
    //init the wall
    var leftwall = SKSpriteNode()
    var rightwall = SKSpriteNode()
    var topwall = SKSpriteNode()
    var downwall = SKSpriteNode()
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        
        var result:Dictionary<String, AnyObject>?
        
        let lockQueue = dispatch_queue_create("com.test.LockQueue", nil)
        dispatch_sync(lockQueue) {
            if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
                do {
                    result =  try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
                } catch let error as NSError {
                    print(error)
                    result = nil
                }
            }
        }
        
        return result
    }
    
    
    // MARK: - SKScene
    override func didMoveToView(view: SKView) {
        
        if mode == 1{
            communicator!.delegate = self
            communicator?.serviceAdvertiser.startAdvertisingPeer()
            communicator?.serviceBrowser.startBrowsingForPeers()
        }
        
        
        leftwall = self.childNodeWithName("leftwall") as! SKSpriteNode
        rightwall = self.childNodeWithName("rightwall") as! SKSpriteNode
        topwall = self.childNodeWithName("topwall") as! SKSpriteNode
        downwall = self.childNodeWithName("downwall") as! SKSpriteNode
        
        self.player =  Player(color: self.color,gameScence: self)
        self.player!.userDefaults = NSUserDefaults.standardUserDefaults()
        self.player!.snake.snakeSpeed = 75.0
        
        if mode == 1 && joinedGame == true{
            sendInitialPlayerInfo()
        }
        
        if mode == 0{
            self.AIs = AI.initialAiSnake(14,gameScence: self, xMin: 1024, xMax:leftwall.frame.width, yMin:(leftwall.frame.height - downwall.frame.height), yMax:downwall.frame.height)
        }
        // Setup player
        //开启多点触控模式
        self.view?.multipleTouchEnabled = true
        
        //add food
        if(mode == 0 || (mode == 1 && joinedGame == false)){
            self.addFood(180)
            self.addsuperfood(80)
        }
        
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
                
                
                if mode == 1 && player != nil{
                    Player.updateOnlinePlayer(otherPlayersList)
                    self.player!.updatePlayerByJoystick()
                    updateScore()
                    self.updateCamera()
                }
                else{
                    AI.updateAllAISnakes(AIs, player: player!)
                    self.player!.updatePlayerByJoystick()
                    updateScore()
                    self.updateCamera()
                }
                
                
            }
            else if (count_modelAnyobj as! String) == "Arrow_model"
            {
                if mode == 1 && player != nil{
                    Player.updateOnlinePlayer(otherPlayersList)
                    self.player!.updatePlayer()
                    updateScore()
                    self.updateCamera()
                }
                else{
                    AI.updateAllAISnakes(AIs, player: player!)
                    self.player!.updatePlayer()
                    updateScore()
                    self.updateCamera()
                }
                
                
            }else if (count_modelAnyobj as! String) == "Narmal_model"
                
            {
                if mode == 1 && player != nil{
                    Player.updateOnlinePlayer(otherPlayersList)
                    self.player!.updatePlayer()
                    updateScore()
                    self.updateCamera()
                }
                else{
                    AI.updateAllAISnakes(AIs, player: player!)
                    self.player!.updatePlayer()
                    updateScore()
                    self.updateCamera()
                }
                
                
            }
        }else{
            if mode == 1 && player != nil{
                Player.updateOnlinePlayer(otherPlayersList)
                self.player!.updatePlayer()
                updateScore()
                self.updateCamera()
            }
            else{
                AI.updateAllAISnakes(AIs, player: player!)
                self.player!.updatePlayer()
                updateScore()
                self.updateCamera()
            }
            
            
        }
        if(self.player != nil){
            self.checkheadposition(self.player!.snake.snakeBodyPoints[0])
        }
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
                pointArrow.hidden = false
                ArrowActive = true
                handleArrow(touches)
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
                //print("HI")
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
                handleArrow(touches)
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
                handleArrow(touches)
                
                pointArrow.hidden = true
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
    
    //箭头模式
    private func handleArrow(touches: Set<UITouch>){
        print("handleArrow")
        if(ArrowActive==true){
            for touch in touches {
                let location = touch.locationInNode(camera!)
                
                let finger = touch.locationInNode(self)
                print(location)
                pointArrow.position.x = location.x
                pointArrow.position.y = location.y + 200
                pointArrow.hidden = false
                
                
                //				let v = CGVector(dx:pointArrow.position.x - player!.snake.snakeBodyPoints[0].position.x, dy:pointArrow.position.y - player!.snake.snakeBodyPoints[0].position.y)
                //
                //				let angle = atan2(v.dy,v.dx)
                //
                //				self.player?.snake.angle = angle
                
                if(CGRectContainsPoint(speed_up!.frame, location) == false && CGRectContainsPoint(controller.frame, location) == false)
                {
                    player!.lastTouch = finger
                    player!.touchedScreen = true
                }
                else{
                    leaveFood()
                }
                
                
                
            }
        }
        
        
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
                
                if(CGRectContainsPoint(base.frame, location) && CGRectContainsPoint(speed_up!.frame, touchspeed) == false){
                    ball.position = location
                }else if(CGRectContainsPoint(speed_up!.frame, touchspeed) == false){
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
                
                if mode == 1 && player != nil{
                    
                    
                    let lockQueue = dispatch_queue_create("com.test.LockQueue.touch", nil)
                    dispatch_sync(lockQueue) {
                        // code
                        
                        
                        print("send touch info")
                        
                        self.userDataInfo["tag"] = 2
                        self.userDataInfo["userName"] = communicator?.getName()
                        self.userDataInfo["lastTouchX"] = player!.lastTouch?.x
                        self.userDataInfo["lastTouchY"] = player!.lastTouch?.y
                        
                        let dict = self.userDataInfo as NSDictionary
                        var data:NSData?
                        do{
                            data = try NSJSONSerialization.dataWithJSONObject(dict, options:NSJSONWritingOptions.PrettyPrinted)
                        }catch{
                            print("Send error")
                        }
                        
                        let string_data = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
                        
                        communicator!.sendData(string_data)
                        print("send touch info done")
                    }
                }
            }
            else{
                leaveFood()
            }
        }
    }
    
    func checkheadposition(head:SKShapeNode){
        if (head.position.x >= 1024 || head.position.x <= leftwall.frame.width || head.position.y >= (leftwall.frame.height - downwall.frame.height) || head.position.y <= downwall.frame.height){
            playerInToDicks()
            gameOver(false)
        }
    }
    
    func checkHeadPositionAI(head:SKShapeNode, ai:AI){
        if (head.position.x >= 1024 || head.position.x <= leftwall.frame.width || head.position.y >= (leftwall.frame.height - downwall.frame.height) || head.position.y <= downwall.frame.height){
            aiIntoDicks(ai)
        }
    }
        
    func checkHeadPositionOtherPlayer(head:SKShapeNode, player:Player){
        if (head.position.x >= 1024 || head.position.x <= leftwall.frame.width || head.position.y >= (leftwall.frame.height - downwall.frame.height) || head.position.y <= downwall.frame.height){
            playerInToDicks(player)
        }
    }
    
    
    // Determines if the player's position should be updated
    private func shouldMove(currentPosition currentPosition: CGPoint, touchPosition: CGPoint) -> Bool {
        return abs(currentPosition.x - touchPosition.x) > self.player!.snake.snakeBodyPoints[0].frame.width / 2 ||
            abs(currentPosition.y - touchPosition.y) > self.player!.snake.snakeBodyPoints[0].frame.height/2
    }
    
    
    
    
    
    /*===============================物理碰撞相关=================================================*/
    // MARK: - SKPhysicsContactDelegate
    //搞懂这个函数。
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        if let _ = contact.bodyA.node,_ = contact.bodyB.node{
            if(mode == 0){
                
                if (contact.bodyA.categoryBitMask + contact.bodyB.categoryBitMask == 5){
                    
                    self.player!.snake.eatFoodNum+=1
                    //player grow
                    self.player!.snake.addSnakeLength(1)
                    //addSnakeLength(player_snake, length: 1)
                    if(contact.bodyA.node?.name == "food")
                    {
                        contact.bodyA.node?.removeFromParent()
                        self.runAction(SKAction.playSoundFileNamed("hit.wav", waitForCompletion: false))
                    }
                    else
                    {
                        contact.bodyB.node?.removeFromParent()
                        self.runAction(SKAction.playSoundFileNamed("hit.wav", waitForCompletion: false))
                    }
                    addFood(1)
                }
                else if(contact.bodyA.node?.name == "playerhead"){
                    if(contact.bodyB.node!.name!.containsString("aihead") || (contact.bodyB.node!.name! == "aibody") ){
                        
                        playerInToDicks()
                        gameOver(false)
                    }
                }
                else if((contact.bodyA.node?.name?.containsString("aihead")) != false && contact.bodyA.node?.name?.containsString("aihead") != nil){
                    print("`````````````test ai head``````````````````")
                    print(contact.bodyA.node?.name?.containsString("aihead"))
                    print(contact.bodyA.node?.name)
                    print(contact.bodyB.node?.name)
                    if(contact.bodyB.node?.name == "food"){
                        //ai grow
                        let aiName = contact.bodyA.node?.name
                        
                        let length = (aiName?.characters.count)! - 6
                        let indexs = (aiName! as NSString).substringWithRange(NSRange(location:6, length:length))
                        contact.bodyB.node?.removeFromParent()
                        let indexInt = Int(indexs)
                        AIs[indexInt!].snake.addSnakeLength(1)
                        //addFood(1)
                        
                    }
                    else if((contact.bodyB.node?.name?.containsString("aihead")) != false && (contact.bodyB.node?.name?.containsString("aihead")) != nil){
                        //ai die both
                        
                        let aiName = contact.bodyB.node?.name
                        
                        let length = (aiName?.characters.count)! - 6
                        let indexs = (aiName! as NSString).substringWithRange(NSRange(location:6, length:length))
                        
                        let indexInt = Int(indexs)
                        
                        let delete = AIs[indexInt!]
                        
                        aiIntoDicks(delete)
                        
                        AIs[indexInt!] = AI(color: UIColor.greenColor(), bitmask: 2*Int(pow(Double(4),Double(indexInt!+1))), index: indexInt!,gameScence: self,xMin:1024, xMax:leftwall.frame.width, yMin:(leftwall.frame.height - downwall.frame.height), yMax:downwall.frame.height)
                        
                        
                        let aiNameA = contact.bodyA.node?.name
                        
                        let lengthA = (aiNameA?.characters.count)! - 6
                        let indexsA = (aiNameA! as NSString).substringWithRange(NSRange(location:6, length:lengthA))
                        
                        let indexIntA = Int(indexsA)
                        let deleteA = AIs[indexIntA!]
                        aiIntoDicks(deleteA)
                        
                        AIs[indexIntA!] = AI(color: UIColor.greenColor(), bitmask: 2*Int(pow(Double(4),Double(indexIntA!+1))), index: indexIntA!,gameScence: self,xMin:1024, xMax:leftwall.frame.width, yMin:(leftwall.frame.height - downwall.frame.height), yMax:downwall.frame.height)
                        
                    }
                    else if(((contact.bodyB.node?.name!.containsString("aibody")) != false && (contact.bodyB.node?.name!.containsString("aibody")) != nil)||contact.bodyB.node!.name! == "playerbody"){
                        //A snake die
                        
                        let aiName = contact.bodyA.node?.name
                        
                        let length = (aiName?.characters.count)! - 6
                        let indexs = (aiName! as NSString).substringWithRange(NSRange(location:6, length:length))
                        
                        let indexInt = Int(indexs)
                        
                        let delete = AIs[indexInt!]
                        aiIntoDicks(delete)
                        
                        AIs[indexInt!] = AI(color: UIColor.greenColor(), bitmask: 2*Int(pow(Double(4),Double(indexInt!+1))), index: indexInt!,gameScence: self,xMin:1024, xMax:leftwall.frame.width, yMin:(leftwall.frame.height - downwall.frame.height), yMax:downwall.frame.height)
                    }
                    else if(contact.bodyB.node?.name == "playerhead"){
                        playerInToDicks()
                        gameOver(false)
                    }
                }
                else if(contact.bodyA.node?.name == "food"){
                    if((contact.bodyB.node?.name?.containsString("aihead")) != false && (contact.bodyB.node?.name?.containsString("aihead")) != nil){
                        //ai grow
                        contact.bodyA.node?.removeFromParent()
                        let aiName = contact.bodyB.node?.name
                        let length = (aiName?.characters.count)! - 6
                        let indexs = (aiName! as NSString).substringWithRange(NSRange(location:6, length:length))
                        
                        let indexInt = Int(indexs)
                        AIs[indexInt!].snake.addSnakeLength(1)
                    }
                }
                
            }else if(mode == 1){
                
                
                if (contact.bodyA.categoryBitMask + contact.bodyB.categoryBitMask == 5){
                    
                    //player grow
                    self.player!.snake.addSnakeLength(1)
                    //addSnakeLength(player_snake, length: 1)
                    if(contact.bodyA.node?.name == "food")
                    {
                        contact.bodyA.node?.removeFromParent()
                        //sendRemoveFoodPosition((contact.bodyA.node?.position)!)
                    }
                    else
                    {
                        contact.bodyB.node?.removeFromParent()
                        //sendRemoveFoodPosition((contact.bodyB.node?.position)!)
                    }
                    var position:CGPoint
                    if countEatFood < 2{
                        position = addFood(1)
                    }else{
                        position = addsuperfood(1)
                    }
                    
                    self.sendUpdateFoodPosition(position)
                    
                }
                else if(contact.bodyA.node?.name == "playerhead"){
                    if(contact.bodyB.node!.name!.containsString("aihead") || (contact.bodyB.node!.name! == "aibody") ){
                        
                        playerInToDicks()
                        gameOver(false)
                    }
                }
                else if((contact.bodyA.node?.name?.containsString("aihead")) != false && contact.bodyA.node?.name?.containsString("aihead") != nil){
                    print("`````````````test ai head``````````````````")
                    print(contact.bodyA.node?.name?.containsString("aihead"))
                    print(contact.bodyA.node?.name)
                    print(contact.bodyB.node?.name)
                    if(contact.bodyB.node?.name == "food"){
                        //ai grow
                        let aiName = contact.bodyA.node?.name
                        
                        let length = (aiName?.characters.count)! - 6
                        let indexs = (aiName! as NSString).substringWithRange(NSRange(location:6, length:length))
                        
                        let indexInt = Int(indexs)
                        contact.bodyB.node?.removeFromParent()
                        self.otherPlayersList[indexInt!].snake.addSnakeLength(1)
                    }
                    else if((contact.bodyB.node?.name?.containsString("aihead")) != false && (contact.bodyB.node?.name?.containsString("aihead")) != nil){
                        //ai die both
                        
                        let aiName = contact.bodyB.node?.name
                        
                        let length = (aiName?.characters.count)! - 6
                        let indexs = (aiName! as NSString).substringWithRange(NSRange(location:6, length:length))
                        
                        let indexInt = Int(indexs)
                        print("index is")
                        print(indexInt)
                        let delete = self.otherPlayersList[indexInt!]
                        
                        playerInToDicks(delete)
                        
                        
                        let aiNameA = contact.bodyA.node?.name
                        
                        let lengthA = (aiNameA?.characters.count)! - 6
                        let indexsA = (aiNameA! as NSString).substringWithRange(NSRange(location:6, length:lengthA))
                        
                        let indexIntA = Int(indexsA)
                        let deleteA = self.otherPlayersList[indexIntA!]
                        playerInToDicks(deleteA)
                        
                    }
                    else if(((contact.bodyB.node?.name!.containsString("aibody")) != false && (contact.bodyB.node?.name!.containsString("aibody")) != nil)||contact.bodyB.node!.name! == "playerbody"){
                        //A snake die
                        
                        let aiName = contact.bodyA.node?.name
                        
                        let length = (aiName?.characters.count)! - 6
                        let indexs = (aiName! as NSString).substringWithRange(NSRange(location:6, length:length))
                        
                        let indexInt = Int(indexs)
                        
                        print("index is")
                        print(indexInt)
                        
                        
                        let delete = self.otherPlayersList[indexInt!]
                        
                        
                        playerInToDicks(delete)
                        
                        
                    }
                    else if(contact.bodyB.node?.name == "playerhead"){
                        playerInToDicks()
                        gameOver(false)
                    }
                }
                else if(contact.bodyA.node?.name == "food"){
                    if((contact.bodyB.node?.name?.containsString("aihead")) != false && (contact.bodyB.node?.name?.containsString("aihead")) != nil){
                        //ai grow
                        
                        contact.bodyA.node?.removeFromParent()
                        let aiName = contact.bodyB.node?.name
                        let length = (aiName?.characters.count)! - 6
                        let indexs = (aiName! as NSString).substringWithRange(NSRange(location:6, length:length))
                        
                        let indexInt = Int(indexs)
                        self.otherPlayersList[indexInt!].snake.addSnakeLength(1)
                    }
                }
                
                
            }
        }
    }
    
    
    /*===============================食物相关========================================================*/
    
    
    //Add super food
    
    func addSuperFoodWithPosition(position: CGPoint){
        
        let food = SKShapeNode(circleOfRadius: 2)
        food.name = "food"
        food.fillColor = UIColor(red:0.22, green:0.81, blue:0.41, alpha:1.0)
        food.lineWidth=0
        
        food.position = position
        
        food.physicsBody = SKPhysicsBody(circleOfRadius: 2)
        food.physicsBody?.dynamic = true
        food.physicsBody?.categoryBitMask = 4
        food.physicsBody?.collisionBitMask = 0xaaaaaaa9
        food.physicsBody?.contactTestBitMask = 0xaaaaaaa9
        food.physicsBody?.affectedByGravity = false
        food.physicsBody?.allowsRotation = false
        
        
        let wait = SKAction.waitForDuration(0.7)
        let block = SKAction.runBlock({food.fillColor=SKColor.whiteColor()})
        let wait1 = SKAction.waitForDuration(0.7)
        let block1 = SKAction.runBlock({food.fillColor=UIColor(red:0.22, green:0.81, blue:0.41, alpha:1.0)})
        let block2 = SKAction.runBlock({food.fillColor=UIColor(red:0.97, green:0.68, blue:0.68, alpha:1.0)})
        
        let scale = SKAction.scaleTo(0.4, duration: 0.5)
        let fade = SKAction.fadeOutWithDuration(0.5)
        let scale2 = SKAction.scaleTo(1.3, duration: 0.5)
        //let sequence = SKAction.sequence([scale, fade])
        
        
        let forever = SKAction.repeatActionForever(SKAction.sequence([wait,scale,block,wait1,block1,scale2,wait,scale,block,wait1,block2,scale2]))
        
        food.runAction(forever)
        
        addChild(food)
        superFoods.append(food)
        
    }
    
    func addsuperfood(n: Int)->CGPoint{
        var position:CGPoint?
        for _ in 1...n {
            let food = SKShapeNode(circleOfRadius: 4)
            food.name = "food"
            food.fillColor = UIColor(red:0.22, green:0.81, blue:0.41, alpha:1.0)
            food.lineWidth=0
            
            let aix = random(min:100, max:1000)
            
            let aiy = random(min:100, max:1920)
            food.position = CGPoint(x:aix, y:aiy)
            
            food.physicsBody = SKPhysicsBody(circleOfRadius: 4)
            food.physicsBody?.dynamic = true
            food.physicsBody?.categoryBitMask = 4
            food.physicsBody?.collisionBitMask = 0xaaaaaaa9
            food.physicsBody?.contactTestBitMask = 0xaaaaaaa9
            food.physicsBody?.affectedByGravity = false
            food.physicsBody?.allowsRotation = false
            
            
            let wait = SKAction.waitForDuration(0.7)
            let block = SKAction.runBlock({food.fillColor=SKColor.whiteColor()})
            let wait1 = SKAction.waitForDuration(0.7)
            let block1 = SKAction.runBlock({food.fillColor=UIColor(red:0.22, green:0.81, blue:0.41, alpha:1.0)})
            let block2 = SKAction.runBlock({food.fillColor=UIColor(red:0.97, green:0.68, blue:0.68, alpha:1.0)})
            
            let scale = SKAction.scaleTo(0.4, duration: 0.5)
            let fade = SKAction.fadeOutWithDuration(0.5)
            let scale2 = SKAction.scaleTo(1.3, duration: 0.5)
            //let sequence = SKAction.sequence([scale, fade])
            
            
            let forever = SKAction.repeatActionForever(SKAction.sequence([wait,scale,block,wait1,block1,scale2,wait,scale,block,wait1,block2,scale2]))
            
            food.runAction(forever)
            
            addChild(food)
            superFoods.append(food)
            position = food.position
        }
        return position!
        
    }
    // Add food when food is eaten by user
    func addFood(n: Int)->CGPoint{
        var position:CGPoint?
        for _ in 1...n {
            let food = SKShapeNode(circleOfRadius: 2)
            food.name = "food"
            food.fillColor = UIColor(red:0.99, green:1.00, blue:0.17, alpha:1.0)
            
            let aix = random(min:100, max:1000)
            
            let aiy = random(min:100, max:1920)
            food.position = CGPoint(x:aix, y:aiy)
            food.lineWidth=0
            food.physicsBody = SKPhysicsBody(circleOfRadius: 2)
            food.physicsBody?.dynamic = true
            food.physicsBody?.categoryBitMask = 4
            food.physicsBody?.collisionBitMask = 0xaaaaaaa9
            food.physicsBody?.contactTestBitMask = 0xaaaaaaa9
            food.physicsBody?.affectedByGravity = false
            food.physicsBody?.allowsRotation = false
            
            let scale = SKAction.scaleTo(0.4, duration: 0.5)
            //let fade = SKAction.fadeOutWithDuration(0.5)
            let scale2 = SKAction.scaleTo(0.8, duration: 0.5)
            let sequence = SKAction.sequence([scale2,scale])
            
            let forever = SKAction.repeatActionForever(sequence)
            food.runAction(forever)
            addChild(food)
            self.foods.append(food)
            position = food.position
        }
        return position!
    }
    
    func leaveFood(){
        player?.speedupTapCount++
        //print(player?.speedupTapCount)
        
        //		player?.leavedisk()
        if player?.speedupTapCount > 10{
            player?.snake.reduceSnakeLength()
            addFoodwithPostion((player?.snake.snakeBodyPoints[(player?.snake.length)!-1].position)!)
            
            player?.speedupTapCount = 0
        }
        
    }
    
    func addFoodwithPostion(positon:CGPoint){
        let food = SKShapeNode(circleOfRadius: 2)
        food.name = "food"
        food.fillColor = UIColor(red:0.99, green:1.00, blue:0.17, alpha:1.0)
        food.position = positon
        
        food.physicsBody = SKPhysicsBody(circleOfRadius: 2)
        food.physicsBody?.dynamic = true
        food.physicsBody?.categoryBitMask = 4
        food.physicsBody?.collisionBitMask = 0xaaaaaaa9
        food.physicsBody?.contactTestBitMask = 0xaaaaaaa9
        food.physicsBody?.affectedByGravity = false
        food.physicsBody?.allowsRotation = false
        food.lineWidth=0
        let scale = SKAction.scaleTo(0.4, duration: 0.5)
        //let fade = SKAction.fadeOutWithDuration(0.5)
        let scale2 = SKAction.scaleTo(0.8, duration: 0.5)
        let sequence = SKAction.sequence([scale2,scale])
        
        let forever = SKAction.repeatActionForever(sequence)
        food.runAction(forever)
        
        addChild(food)
        self.foods.append(food)
        
        
    }
    
    func aiBigDisks(positon:CGPoint){
        let food = SKShapeNode(circleOfRadius: 4)
        food.name = "food"
        food.fillColor = UIColor(red:0.99, green:1.00, blue:0.17, alpha:1.0)
        food.position = positon
        
        food.physicsBody = SKPhysicsBody(circleOfRadius: 4)
        food.physicsBody?.dynamic = false
        food.physicsBody?.categoryBitMask = 4
        food.physicsBody?.collisionBitMask = 0
        food.physicsBody?.contactTestBitMask = 0xaaaaaaa9
        food.physicsBody?.affectedByGravity = false
        food.physicsBody?.allowsRotation = false
        food.lineWidth=0
        let scale = SKAction.scaleTo(0.4, duration: 0.5)
        //let fade = SKAction.fadeOutWithDuration(0.5)
        let scale2 = SKAction.scaleTo(0.8, duration: 0.5)
        let sequence = SKAction.sequence([scale2,scale])
        
        let forever = SKAction.repeatActionForever(sequence)
        food.runAction(forever)
        
        addChild(food)
        foods.append(food)
        
        
    }
    
    func aiIntoDicks(ai:AI){
        aiBigDisks(ai.snake.snakeBodyPoints[0].position)
        ai.snake.turnIntoDisks()
        //print("ai die!!!")
    }
    
    
    func playerInToDicks(otherPlayer: Player){
        
        for i in (otherPlayer.snake.snakeBodyPoints){
            addFoodwithPostion(i.position)
        }
        otherPlayer.snake.turnIntoDisks()
        
    }
    
    func playerInToDicks(){
        
        for i in (player?.snake.snakeBodyPoints)!{
            addFoodwithPostion(i.position)
        }
        player?.snake.turnIntoDisks()
        communicator?.serviceAdvertiser.stopAdvertisingPeer()
        communicator?.serviceBrowser.stopBrowsingForPeers()
        findGameRoomTag = false
        
    }
    /*===================================功能函数======================================================*/
    // Helper functions, to generate random CGPoints
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
    func updateScore () {
        player?.score = (player?.snake.length)! * 100
        lblScore.text = (String(player!.score))
    }
    
    
    private func gameOver(didWin: Bool) {
        //print("- - - Game Ended - - -")
        var g = GameViewController()
        g.gameOver1()
        let menuScene = MenuScene(size: self.size)
        //menuScene.soundToPlay = didWin ? "fear_win.mp3" : "fear_lose.mp3"
        self.runAction(SKAction.playSoundFileNamed("GameOver.mp3", waitForCompletion: false))
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
            case 3:
                for i in player{
                    i.fillColor=UIColor.brownColor()
                    self.player?.snake.snakeColor = i.fillColor
                }
                break
            default:
                //Snake_with_Skin!.runAction(Actionbrown)
                for i in player{
                    i.fillColor=UIColor(red:0.97, green:0.68, blue:0.68, alpha:1.0)
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
            //print("No color")
        }
        
    }
    //Set default model
    func setDefaultModel(){
        
        
        if let count_modelAnyobj = player!.userDefaults!.valueForKey("model") {
            //print(count_modelAnyobj)
            let count_model = count_modelAnyobj as! String
            switch count_model {
            case "Arrow_model":
                pointArrow.position.x = (camera?.position.x)!
                pointArrow.position.y = (camera?.position.y)!
                pointArrow.zPosition = 6
                pointArrow.size = CGSize(width: 100,height: 100)
                pointArrow.hidden = true
                camera!.addChild(pointArrow)
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
                //print("Default")
                break
            }
        }
        else {
            //set normal way
            //print("Normal_model")
        }
        
    }
    
    //setup camera
    func setupCamera(){
        if let camera_frame = camera{
            
            
            //player?.let lblScore = SKLabelNode()
            lblScore.text = String(player!.score)
            //print(username)
            //print("gggggggg")
            lblScore.fontName = "AvenirNext-Bold"
            lblScore.fontSize = 40
            lblScore.fontColor = UIColor.whiteColor()
            lblScore.position.x = (camera_frame.position.x) + 250
            lblScore.position.y = (camera_frame.position.y) - 1200
            lblScore.zRotation = CGFloat(-M_PI_2)
            
            camera_frame.addChild(lblScore)
            
            
            let light = SKLightNode()
            light.falloff = 2
            light.ambientColor = UIColor.blackColor()
            light.shadowColor = UIColor.darkGrayColor()
            //lightingBitMask = 1
            
            //.mask
            player?.snake.snakeBodyPoints[0].addChild(light)
            
            controller.position.x = (camera?.position.x)! - 420
            controller.position.y =  (camera?.position.y)! - 1100
            controller.setScale(0.4)
            controller.zPosition = 10
            
            speed_up = SKSpriteNode(imageNamed:"rocket-512")
            speed_up?.position.x = (camera?.position.x)! - 620
            speed_up?.position.y = (camera?.position.y)! - 1100
            speed_up?.size = CGSize(width: 100,height: 100)
            
            speed_up?.zPosition = 10
            
            
            if let speed = speed_up{
                camera_frame.addChild(speed)
            }else{
                //print("no speed up")
            }
            
            camera_frame.addChild(controller)
            
            
        }
        
        if let username = userDefaults.valueForKey("username") {
            let label = SKLabelNode(text: username as? String)
            //print(username)
            //print("gggggggg")
            label.fontName = "AvenirNext-Bold"
            label.fontSize = 40
            label.fontColor = UIColor.whiteColor()
            label.position.x = (camera?.position.x)! + 250
            label.position.y = (camera?.position.y)! - 1000
            label.zRotation = CGFloat(-M_PI_2)
            //addChild(label)
            if let camera_frame = camera{
                camera_frame.addChild(label)
                
            }
        }else{
            
        }
        
        
    }
    func updateCamera() {
        if let camera = camera {
            camera.position = CGPoint(x: self.player!.snake.snakeBodyPoints[0].position.x, y: self.player!.snake.snakeBodyPoints[0].position.y)
        }
        
        if let length = self.player?.snake.length{
            //print(length)
            var increment = length%9
            if(increment == 8 && length < 25){
                //print(camera?.frame.size)
                var s = 0.3 + CGFloat(Float(length)/200.0)
                //print(s)
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
                    //print((camera?.position.x)! - 500)
                    //print((camera?.position.y)! + 500)
                    //print((camera?.position.x)! - 720)
                    //print((camera?.position.y)! - 1100)
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
    
    func sendFoodInfo(){
        let lockQueue = dispatch_queue_create("com.test.LockQueue.sendFood", nil)
        dispatch_sync(lockQueue) {
            // code
            
            
            print("send food")
            var foodsInfo:String = ""

            for i in foods {
                foodsInfo = foodsInfo + i.position.x.description+","+i.position.y.description+","
            }
            
            var superFoodInfo:String = ""
            for i in superFoods {
                superFoodInfo = superFoodInfo + i.position.x.description+","+i.position.y.description+","
            }
            
            
            self.userDataInfo["tag"] = 0
            self.userDataInfo["foods"] = foodsInfo
            self.userDataInfo["superFoods"] = superFoodInfo
            
            let dict = self.userDataInfo as NSDictionary
            
            var data:NSData?
            do{
                data = try NSJSONSerialization.dataWithJSONObject(dict, options:NSJSONWritingOptions.PrettyPrinted)
            }catch{
                print("Send error")
            }
            //print(data?.description)
            let string_data = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
            
            //print("begin send data")
            communicator!.sendData(string_data)
            print("send food done")
        }
        
    }
    
    func sendInitialPlayerInfo(){
        print("send initial info")

        //userDataInfo.removeAll()
        
        self.userDataInfo["tag"] = 1
        self.userDataInfo["color"] = colorCode
        self.userDataInfo["userName"] = communicator!.getName()
        self.userDataInfo["X_position"] = player?.snake.snakeBodyPoints[0].position.x
        self.userDataInfo["Y_position"] = player?.snake.snakeBodyPoints[0].position.y
        self.userDataInfo["lastTouch_X"] = player?.lastTouch?.x
        self.userDataInfo["lastTouch_Y"] = player?.lastTouch?.y
        self.userDataInfo["touchedScreen"] = player?.touchedScreen
        self.userDataInfo["speedupTapCount"] = player?.speedupTapCount
        self.userDataInfo["score"] = player?.score
        self.userDataInfo["rewards"] = player?.rewards
        self.userDataInfo["length"] = player?.snake.length
        self.userDataInfo["radius"] = player?.snake.radius
        self.userDataInfo["snakeSpeed"] = player?.snake.snakeSpeed
        self.userDataInfo["angle"] = player?.snake.angle
        self.userDataInfo["eatFoodNum"] = player?.snake.eatFoodNum
        self.userDataInfo["scale"] = player?.snake.scale
        
        let dict = self.userDataInfo as NSDictionary
        
        var data:NSData?
        do{
            data = try NSJSONSerialization.dataWithJSONObject(dict, options:NSJSONWritingOptions.PrettyPrinted)
        }catch{
            print("Send error")
        }
        //print(data?.description)
        let string_data = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
        
        //print("begin send data")
        communicator!.sendData(string_data)
        print("send initial info done")
    }
    
    func createFood(dict:Dictionary<String, AnyObject>){
        if joinedGame == true && getFoodInfo == false{
            getFoodInfo = true
            let foodsInfo: String = dict["foods"] as! String
            let superFoodsInfo: String = dict["superFoods"] as! String
            
            let foodsArray = foodsInfo.componentsSeparatedByString(",")
            var i = 0
            while(i < foodsArray.count-1){
                let xs = foodsArray[i]
                let ys = foodsArray[i+1]
                let xt = NSNumberFormatter().numberFromString(xs)
                let yt = NSNumberFormatter().numberFromString(ys)
                let x = CGFloat(xt!)
                let y = CGFloat(yt!)
                let foodPosition = CGPoint(x: x,y: y)
                self.addFoodwithPostion(foodPosition)
                i = i + 2
            }
            
            let superFoodsArray = superFoodsInfo.componentsSeparatedByString(",")
            i = 0
            while(i < superFoodsArray.count-1){
                let xs = superFoodsArray[i]
                let ys = superFoodsArray[i+1]
                let xt = NSNumberFormatter().numberFromString(xs)
                let yt = NSNumberFormatter().numberFromString(ys)
                let x = CGFloat(xt!)
                let y = CGFloat(yt!)
                let foodPosition = CGPoint(x: x,y: y)
                self.addSuperFoodWithPosition(foodPosition)
                i = i + 2
            }
            
        }
        updateFoodDone = true
    }
    
    
    func createOnlinePlayer(dict:Dictionary<String, AnyObject>){
        let lockQueue = dispatch_queue_create("com.test.LockQueue.createOnlinePlayer", nil)
        dispatch_sync(lockQueue) {
            // code
            
            let userName = dict["userName"] as! String
            print("create onlinePlayer! name")
            print(userName)
            
            if self.otherPlayers[userName] == nil{
                
                print("userName is nor nil")
                let player = Player(dict: dict,gameScence: self)
                self.otherPlayers[userName] = player
                self.otherPlayersList.append(player)
                
                self.sendInitialPlayerInfo()
                
                self.sendFoodInfo()
                
            }
        }
    }
    
    func sendRemoveFoodPosition(position: CGPoint){
        
        let lockQueue = dispatch_queue_create("com.test.LockQueue.sendRemoveFood", nil)
        dispatch_sync(lockQueue) {
            // code
            
            print("send remove food")

            
            self.userDataInfo["tag"] = 4
            self.userDataInfo["food_X"] = position.x
            self.userDataInfo["food_Y"] = position.y
            
            let dict = self.userDataInfo as NSDictionary
            
            var data:NSData?
            do{
                data = try NSJSONSerialization.dataWithJSONObject(dict, options:NSJSONWritingOptions.PrettyPrinted)
            }catch{
                print("Send error")
            }
            //print(data?.description)
            let string_data = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
            
            //print("begin send data")
            communicator!.sendData(string_data)
            print("send remove food done")
        }
        
    }
    
    func sendUpdateFoodPosition(position: CGPoint){
        
        let lockQueue = dispatch_queue_create("com.test.LockQueue.sendUpdateFood", nil)
        dispatch_sync(lockQueue) {
            // code
            
            
            print("send update food")

            
            
            self.userDataInfo["tag"] = 3
            self.userDataInfo["food_X"] = position.x
            self.userDataInfo["food_Y"] = position.y
            if(countEatFood >= 2){
                self.userDataInfo["kind"] = 1
                countEatFood = 0
            }else{
                self.userDataInfo["kind"] = 0
                countEatFood = countEatFood+1
            }
            
            
            let dict = self.userDataInfo as NSDictionary
            
            var data:NSData?
            do{
                data = try NSJSONSerialization.dataWithJSONObject(dict, options:NSJSONWritingOptions.PrettyPrinted)
            }catch{
                print("Send error")
            }
            //print(data?.description)
            let string_data = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
            
            //print("begin send data")
            communicator!.sendData(string_data)
            print("send update food done")
        }
        
    }
    
    
    func onlinePlayerTouchedUpdate(dict:Dictionary<String, AnyObject>){
        let lockQueue = dispatch_queue_create("com.test.LockQueue.onlinePlayerTouchUpdate", nil)
        dispatch_sync(lockQueue) {
            // code
            
            
            let userName = dict["userName"] as! String
            
            print("get user touched uPDATE")
            print("user name")
            print(userName)
            print("my name")
            print(communicator?.displayName)
            let updatePlayer = otherPlayers[userName]
            if updatePlayer != nil{
                let x = dict["lastTouchX"] as! CGFloat
                let y = dict["lastTouchY"] as! CGFloat
                let touch = CGPoint(x: x, y: y)
                updatePlayer?.lastTouch = touch
                updatePlayer?.touchedScreen = true
            }
        }
    }
    
    func removeFood(dict:Dictionary<String, AnyObject>){
        
        let lockQueue = dispatch_queue_create("com.test.LockQueue.removeFood", nil)
        dispatch_sync(lockQueue) {
            // code
            
            if dict["food_X"] != nil && dict["food_Y"] != nil{
            
            let x = dict["food_X"] as! CGFloat
            let y = dict["food_Y"] as! CGFloat
            
            if updateFoodDone == true{
                for i in 0...foods.count-1{
                    if foods[i].position.x == x && foods[i].position.y == y{
                        foods[i].removeFromParent()
                        foods.removeAtIndex(i)
                        break
                    }
                }
                for i in 0...superFoods.count-1{
                    if superFoods[i].position.x == x && superFoods[i].position.y == y{
                        superFoods[i].removeFromParent()
                        superFoods.removeAtIndex(i)
                        break
                    }
                }
            }
            }
        }
    }
    
    
    func addUpdateFood(dict:Dictionary<String, AnyObject>){
        
        let lockQueue = dispatch_queue_create("com.test.LockQueue.addUpdateFood", nil)
        dispatch_sync(lockQueue) {
            // code
            if dict["food_X"] != nil && dict["food_Y"] != nil{
                let x = dict["food_X"] as! CGFloat
                let y = dict["food_Y"] as! CGFloat
                let position = CGPoint(x: x, y: y)
                let kind = dict["kind"] as! Int
                if(kind == 0){
                    self.addFoodwithPostion(position)
                }else{
                    self.addSuperFoodWithPosition(position)
                }
            }
        }
    }
    
}

extension GameScene :MultiNodeCommunicationManagerDelegate{
    
    
    func connectedDevicesChanged(manager: MultiNodeCommunication, connectedDevices: [String]) {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            print("111111Connections: \(connectedDevices)")
            
        }
    }
    
    func lostConnected(lostUserName: String){
        
        let index = self.mappingUserIndex[lostUserName]
        if(index != nil){
            self.playerInToDicks(self.otherPlayers[lostUserName]!)
            self.otherPlayersList.removeAtIndex(index!)
            self.otherPlayers.removeValueForKey(lostUserName)
        }
    }
    
    
    func dataGet(manager : MultiNodeCommunication, data: String){
        print("!!get data!!")
        print(data)
        
        var dict:Dictionary<String, AnyObject>?
        
        if let nsdata = data.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                dict = try NSJSONSerialization.JSONObjectWithData(nsdata, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        if dict != nil{
            
            let dict_copy = dict
            
            let tag = dict_copy!["tag"]! as! Int
            
            if(tag == 1){
                print("tag _1")
                self.createOnlinePlayer(dict_copy!)
                print("tag 1")
            }else if(tag == 2){
                print("tag _2")
                self.onlinePlayerTouchedUpdate(dict_copy!)
                print("tag 2")
            }else if(tag == 0){
                print("tag _0")
                self.createFood(dict_copy!)
                print("tag 0")
            }else if(tag == 3){
                print("tag _3")
                //self.addUpdateFood(dict_copy!)
                print("tag 3")
            }else if(tag == 4){
                print("tag _4")
                //self.removeFood(dict_copy!)
                print("tag 4")
            }
        }
    }
    
}
