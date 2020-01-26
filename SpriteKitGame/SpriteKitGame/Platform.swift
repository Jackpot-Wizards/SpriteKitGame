//
//  Platform.swift
//  SpriteKitGame
//
//  Created by Ignat Pechkurenko on 2020-01-25.
//  Copyright © 2020 Jackpot-Wizards. All rights reserved.
//

import Foundation
import SpriteKit

class Platform: GameObject
{
    var isDestroyed: Bool = false
    // constructor
    override init()
    {
        super.init(imageString: "nextButton", size: CGSize(width: 250.0, height: 15.0))
        self.name = "platform"
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
        position.x = 300;
        position.y = 0;
    }
    
    override func Start()
    {
        self.zPosition = 2
        
        // do random here
        self.position.x = 300;
        self.position.y = 0;
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.categoryBitMask = CollisionCategories.Platform
        self.physicsBody?.contactTestBitMask = CollisionCategories.Character
        self.physicsBody?.collisionBitMask = 0
    }
    
    override func Update()
    {
        if (position.x < -415)
        {
            Reset()
        }
        else
        {
            position.x -= 1
        }
    }
}
