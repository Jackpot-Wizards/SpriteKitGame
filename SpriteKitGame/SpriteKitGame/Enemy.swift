//
//  Enemy.swift
//  SpriteKitGame
//
//  Created by Ignat Pechkurenko on 2020-01-25.
//  Copyright © 2020 Jackpot-Wizards. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy: GameObject
{
    var isDestroyed: Bool = false
    // constructor
    override init()
    {
        super.init(imageString: "enemy", size: CGSize(width: 50.0, height: 130.0))
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
        self.zPosition = 3
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: self.size.height))
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = CollisionCategories.Enemy
        self.physicsBody?.contactTestBitMask = CollisionCategories.Bullet
        self.physicsBody?.collisionBitMask = 0
    }
    
    override func Update()
    {
        self.position.x -= 3
    }
    
    
    func TouchMove(newPos: CGPoint)
    {
        self.position = newPos
    }
}
