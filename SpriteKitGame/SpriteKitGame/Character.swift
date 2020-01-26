//
//  Charecter.swift
//  SpriteKitGame
//
//  Created by Ignat Pechkurenko on 2020-01-25.
//  Copyright © 2020 Jackpot-Wizards. All rights reserved.
//

import Foundation
import SpriteKit

class Character: GameObject
{
    var jumpAction: SKAction!
    
    var eligibleToJump = true
    var isInFirstJump: Bool = true
    
    
    // constructor
    override init()
    {
        super.init(imageString: "character", size: CGSize(width: 100.0, height: 100.0))
        name = "character"
        Start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func CheckBounds()
    {
    }
    
    override func Reset()
    {
        
    }
    
    override func Start()
    {
        self.zPosition = 2
    }
    
    override func Update()
    {
        if ((self.physicsBody?.velocity.dy)! < 0.1 && (self.physicsBody?.velocity.dy)! >= -0.1 )
        {
            eligibleToJump = true
        }
    }
    
    
    func TouchMove(newPos: CGPoint)
    {
        self.position = newPos
    }
    
    func Jump()
    {
        if ((self.physicsBody?.velocity.dy)! < 0.1 && (self.physicsBody?.velocity.dy)! >= -0.1 && eligibleToJump == true)
        {
            FirstJump()
        }
        else if (eligibleToJump)
        {
            print("speed second jump")
            print((self.physicsBody?.velocity.dy)!)
            eligibleToJump = false
            SecondJump()
        }
    }
    
    func FirstJump()
    {
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 300))
    }
    
    func SecondJump()
    {
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 200))
    }
}

