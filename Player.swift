//
//  Player.swift
//  snake_burgerEater
//
//  Created by WEI on 9/19/16.
//  Copyright © 2016 WEI. All rights reserved.
//

import Foundation
import CoreData
import SpriteKit

class Player: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    var playerSpeed: CGFloat?
    var player: SKSpriteNode?
    var lastTouch: CGPoint?
    
}
