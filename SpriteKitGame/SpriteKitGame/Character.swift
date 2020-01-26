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
    var characterSpeed = 0.0
    
    // constructor
    override init()
    {
        super.init(imageString: "character", size: CGSize(width: 100.0, height: 100.0))
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
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.angularDamping = 0.0
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = CollisionCategories.Character
        self.physicsBody?.contactTestBitMask = CollisionCategories.Platform
        self.physicsBody?.collisionBitMask = CollisionCategories.Ground
    }
    
    override func Update()
    {
        if ((self.physicsBody?.velocity.dy)! < 0.1 && (self.physicsBody?.velocity.dy)! >= -0.1 )
        {
            eligibleToJump = true
        }
        
        // TODO: use state machine here
        if ((self.physicsBody?.velocity.dy)! >= 0)
        {
            self.physicsBody?.collisionBitMask = CollisionCategories.Ground
        }
        else
        {
            self.physicsBody?.collisionBitMask = CollisionCategories.Ground | CollisionCategories.Platform
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
            eligibleToJump = false
            SecondJump()
        }
    }
    
    func FirstJump()
    {
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 300))
        print("speed first jump")
        print((self.physicsBody?.velocity.dy)!)
    }
    
    func SecondJump()
    {
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 200))
        print("speed second jump")
        print((self.physicsBody?.velocity.dy)!)
    }
}

