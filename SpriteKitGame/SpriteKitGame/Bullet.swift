//
//  Bullet.swift
//  SpriteKitGame
//
//  Created by Ignat Pechkurenko on 2020-01-25.
//  Copyright © 2020 Jackpot-Wizards. All rights reserved.
//

import Foundation
import SpriteKit

class Bullet: GameObject
{
    var isDestroyed: Bool = false
    // constructor
    override init()
    {
        super.init(imageString: "bullet", size: CGSize(width: 30.0, height: 30.0))
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
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = CollisionCategories.Bullet
        self.physicsBody?.contactTestBitMask = CollisionCategories.Enemy
        self.physicsBody?.collisionBitMask = 0
    }
    
    override func Update()
    {
        self.position.x += 3
    }
    
    
    func TouchMove(newPos: CGPoint)
    {
        self.position = newPos
    }
}

