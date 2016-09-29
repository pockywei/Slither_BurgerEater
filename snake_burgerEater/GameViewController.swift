//
//  GameViewController.swift
//  Demo
//
//  Created by Chenhao Wei on 20/08/16.
//  Copyright (c) 2016 WEI. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds


extension SKNode {
	
	class func unarchiveFromFile(file : String) -> SKNode? {
		if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
			let sceneData = try! NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
			let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
			
			archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
			let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! MainScene
			archiver.finishDecoding()
			return scene
		} else {
			return nil
		}
	}
	
}

var interstitialAd:GADInterstitial!

class GameViewController: UIViewController ,GADInterstitialDelegate{
	
    
	override func viewDidLoad() {
        
		super.viewDidLoad()
        interstitialAd = createAndLoadInterstitial()
        
		if let scene = MainScene.unarchiveFromFile("MainScene") as? MainScene {
			// Configure the view.
			let skView = self.view as! SKView
			skView.showsFPS = true
			skView.showsNodeCount = true
			
			/* Sprite Kit applies additional optimizations to improve rendering performance */
			skView.ignoresSiblingOrder = true
			
			/* Set the scale mode to scale to fit the window */
			scene.scaleMode = .AspectFill
			
			skView.presentScene(scene)
		}
	}
	
	override func shouldAutorotate() -> Bool {
		return true
	}
		
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Release any cached data, images, etc that aren't in use.
	}
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial (adUnitID:"ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        let request : GADRequest = GADRequest()
        interstitial.loadRequest(request)
        
        return interstitial
    }
    
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        interstitialAd = createAndLoadInterstitial()
    }
    

    
    func gameOver1() {
        guard interstitialAd != nil else { return }
        if interstitialAd.isReady {
            let currentViewController: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController!
            interstitialAd.presentFromRootViewController(currentViewController!)
        }

    }
}
