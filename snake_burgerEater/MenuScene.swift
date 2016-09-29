//
//  MenuScene.swift
//  Demo
//
//  Created by Chenhao Wei on 20/08/16.
//  Copyright (c) 2016 WEI. All rights reserved.
//

import UIKit
import SpriteKit

class MenuScene: SKScene {

  var soundToPlay: String?
  
  override func didMove(to view: SKView) {
	
	
    self.backgroundColor = SKColor(red: 0, green:0, blue:0, alpha: 1)
	
	
    
    // Setup label
    let label = SKLabelNode(text: "Press anywhere to play again!")
    label.fontName = "AvenirNext-Bold"
    label.fontSize = 55
    label.fontColor = UIColor.white
    label.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
	
	
    
    // Play sound
    if let soundToPlay = soundToPlay {
      self.run(SKAction.playSoundFileNamed(soundToPlay, waitForCompletion: false))
    }
    
    self.addChild(label)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    let mainScene = MainScene(fileNamed: "MainScene")
    let transition = SKTransition.fade(withDuration: 1)
    let skView = self.view as SKView!
    mainScene?.scaleMode = .aspectFill
	
    skView?.presentScene(mainScene!, transition: transition)
  }
  
}
