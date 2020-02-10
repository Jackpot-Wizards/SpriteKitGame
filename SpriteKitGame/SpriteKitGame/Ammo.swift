//
//  Ammo.swift
//  SpriteKitGame
//
//  Created by Ignat Pechkurenko on 2020-02-09.
//  Copyright © 2020 Jackpot-Wizards. All rights reserved.
//

import Foundation
import SpriteKit

class Ammo: GameObject
{
    var isDestroyed: Bool = false
    var moveSpeed: CGFloat = 3
    
    // constructor
    override init()
    {
        super.init(imageString: "gun_control", size: CGSize(width: 50.0, height: 50.0))
        super.name = "ammo"
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
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.width!, height: self.height!))
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = CollisionCategories.Ammo
        self.physicsBody?.contactTestBitMask = CollisionCategories.Character
        self.physicsBody?.collisionBitMask = CollisionCategories.Ground + CollisionCategories.Platform
    }
    
    override func Update()
    {
        self.position.x -= moveSpeed
    }
    
    
    func TouchMove(newPos: CGPoint)
    {
    }
}
