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
import Social


var hardOrNot = 0
var Player_unlock_skin = 0
var mode = 0
var colorCode = 0
var joinedGame:Bool = false
var findGameRoomTag:Bool = false
var getFoodInfo = false
var countEatFood = 0
var updateFoodDone = false
var communicator:MultiNodeCommunication?

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
	//let userDefaults = NSUserDefaults.standardUserDefaults()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameViewController.showTweetSheet), name: "WhateverYouCalledTheAlertInTheOtherLineOfCode", object: nil)
		
		interstitialAd = createAndLoadInterstitial()
		if let scene = MainScene.unarchiveFromFile("MainScene") as? MainScene {
			// Configure the view.
			let skView = self.view as! SKView
			skView.showsFPS = false
			skView.showsNodeCount = false
			
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
	
	override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
		if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
			return UIInterfaceOrientationMask.AllButUpsideDown
		} else {
			return UIInterfaceOrientationMask.All
		}
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
	
	func showTweetSheet() {
		print("showTweetSheet")
		let tweetSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
		tweetSheet.completionHandler = {
			result in
			switch result {
			case SLComposeViewControllerResult.Cancelled:
				//Add code to deal with it being cancelled
				break
				
			case SLComposeViewControllerResult.Done:
				print("showTweetSheet======================================================")
				Player_unlock_skin=1
				print(Player_unlock_skin)
				//Add code here to deal with it being completed
				//Remember that dimissing the view is done for you, and sending the tweet to social media is automatic too. You could use this to give in game rewards?
				break
			}
		}
		
		tweetSheet.setInitialText("I am playing Slither.BurgerEater, join us please! Share to get more skin!!") //The default text in the tweet
		tweetSheet.addImage(UIImage(named: "share.png")) //Add an image if you like?
		tweetSheet.addURL(NSURL(string: "http://twitter.com")) //A url which takes you into safari if tapped on
		
		self.presentViewController(tweetSheet, animated: false, completion: {
			//Optional completion statement
		})
	}
	
}
