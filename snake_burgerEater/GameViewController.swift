//
//  GameViewController.swift
//  Demo
//
//  Created by Chenhao Wei on 20/08/16.
//  Copyright (c) 2016 WEI. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
	
	class func unarchiveFromFile(_ file : String) -> SKNode? {
		if let path = Bundle.main.path(forResource: file, ofType: "sks") {
			let sceneData = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
			let archiver = NSKeyedUnarchiver(forReadingWith: sceneData)
			
			archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
			let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! MainScene
			archiver.finishDecoding()
			return scene
		} else {
			return nil
		}
	}
	
}

class GameViewController: UIViewController {
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let scene = MainScene.unarchiveFromFile("MainScene") as? MainScene {
			// Configure the view.
			let skView = self.view as! SKView
			skView.showsFPS = true
			skView.showsNodeCount = true
			
			/* Sprite Kit applies additional optimizations to improve rendering performance */
			skView.ignoresSiblingOrder = true
			
			/* Set the scale mode to scale to fit the window */
			scene.scaleMode = .aspectFill
			
			skView.presentScene(scene)
		}
	}
	
	override var shouldAutorotate : Bool {
		return true
	}
	
	override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
		if UIDevice.current.userInterfaceIdiom == .phone {
			return UIInterfaceOrientationMask.allButUpsideDown
		} else {
			return UIInterfaceOrientationMask.all
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Release any cached data, images, etc that aren't in use.
	}
	
	override var prefersStatusBarHidden : Bool {
		return true
	}
	
}
