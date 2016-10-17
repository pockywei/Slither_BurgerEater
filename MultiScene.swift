//
//  MenuScene.swift
//  Demo
//
//  Created by Chenhao Wei on 20/08/16.
//  Copyright (c) 2016 WEI. All rights reserved.
//

import UIKit
import SpriteKit

class MultiScene: SKScene {
    
    var soundToPlay: String?
    var share = SKLabelNode()
    var label:SKLabelNode?
    var sucess:SKLabelNode?
    var cancel:SKLabelNode?
    var createRoom:SKLabelNode?
    override func didMoveToView(view: SKView) {
        
        
        self.backgroundColor = SKColor(red: 0, green:0, blue:0, alpha: 1)
        
        // Setup label
        label = SKLabelNode(text: "Finding the online game room....")
        label!.fontName = "Chalkduster"
        label!.fontSize = 55
        label!.fontColor = UIColor.whiteColor()
        label!.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        label!.hidden = false
        self.addChild(label!)
        
        
        
        let delay = 5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            // Put your code which should be executed with a delay here
            
            self.label!.removeFromParent()
            if(findGameRoomTag == true){
                
                self.label!.hidden = true
                
                self.sucess = SKLabelNode(text: "Connected!")
                self.sucess!.fontName = "Chalkduster"
                self.sucess!.fontSize = 55
                self.sucess!.fontColor = UIColor.whiteColor()
                self.sucess!.position =  CGPointMake(CGRectGetMidX(self.frame)-200, CGRectGetMidY(self.frame)+200)
                self.sucess!.hidden = false
                
                self.cancel = SKLabelNode(text: "Cancel")
                self.cancel!.fontName = "Chalkduster"
                self.cancel!.fontSize = 55
                self.cancel!.fontColor = UIColor.whiteColor()
                self.cancel!.position = CGPointMake(CGRectGetMidX(self.frame)+200, CGRectGetMidY(self.frame)+200)
                self.cancel!.hidden=false
                self.addChild(self.sucess!)
                self.addChild(self.cancel!)
                
            }
            else{
                self.createRoom = SKLabelNode(text: "Create Game")
                self.createRoom!.fontName = "Chalkduster"
                self.createRoom!.fontSize = 55
                self.createRoom!.fontColor = UIColor.whiteColor()
                self.createRoom!.position = CGPointMake(CGRectGetMidX(self.frame)-200, CGRectGetMidY(self.frame)+200)
                self.createRoom!.hidden=false
                
                
                self.cancel = SKLabelNode(text: "Cancel")
                self.cancel!.fontName = "Chalkduster"
                self.cancel!.fontSize = 55
                self.cancel!.fontColor = UIColor.whiteColor()
                self.cancel!.position = CGPointMake(CGRectGetMidX(self.frame)+200, CGRectGetMidY(self.frame)+200)
                self.cancel!.hidden=false
                self.addChild(self.createRoom!)
                self.addChild(self.cancel!)
            }
            
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let position = touch.locationInNode(self) // Get the x,y point of the touch
            
            if(findGameRoomTag == false){
                if CGRectContainsPoint(createRoom!.frame, position) {
                    
                    let gameScene = GameScene(fileNamed: "GameScene")
                    let transition = SKTransition.fadeWithDuration(1)
                    let skView = self.view as SKView!
                    gameScene?.scaleMode = .AspectFill
                    dispatch_async(dispatch_get_main_queue(), {
                        skView.presentScene(gameScene!, transition: transition)
                    })
                }
            }else if(findGameRoomTag == true){
                if CGRectContainsPoint(sucess!.frame, position) {
                    joinedGame = true
                    let gameScene = GameScene(fileNamed: "GameScene")
                    let transition = SKTransition.fadeWithDuration(1)
                    let skView = self.view as SKView!
                    gameScene?.scaleMode = .AspectFill
                    dispatch_async(dispatch_get_main_queue(), {
                        skView.presentScene(gameScene!, transition: transition)
                    })
                }
            }
        }
    }
}


