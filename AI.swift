//
//  AI.swift
//  snake_burgerEater
//
//  Created by Chris Sun on 8/10/16.
//  Copyright © 2016 WEI. All rights reserved.
//

import Foundation
import SpriteKit
class AI{
    
    var snake: Snake
    
    init(color:UIColor, bitmask:Int, index:Int, gameScence:GameScene) {
        snake = Snake.createAI(color, bitmask: bitmask, index: index, gameScence: gameScence)
    }

    func updatePlayer() {
       
    }
    
    //加入AI snake, n 是数量
    class func initialAiSnake(aiNum:Int, gameScence:GameScene)->[AI]{
        var AIs:[AI] = []
        //bitnum从4开始
        var bit_num=2
        var snakeNum:Int
        if(aiNum>14){
            snakeNum = 14
        }else{
            snakeNum = aiNum
        }
        
        for i in 0...snakeNum-1 {
            bit_num = bit_num*4
            let ai = AI(color: UIColor.greenColor(), bitmask:bit_num, index: i,gameScence: gameScence)
            AIs.append(ai)
        }
        return AIs
    }
}


