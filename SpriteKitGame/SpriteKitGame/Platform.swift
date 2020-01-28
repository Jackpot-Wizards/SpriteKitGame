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
    var initialDx: CGFloat?
    var initialDy: CGFloat?
    
    init(_ initialX: CGFloat?, _ initialY: CGFloat?)
    {
        super.init(imageString: "nextButton", size: CGSize(width: 250.0, height: 15.0))
        self.name = "platform"
        
        initialDx = initialX
        initialDy = initialY
        
        Start()
    }
    
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
        position.x = initialDx!
    }
    
    override func Start()
    {
        self.zPosition = 2
        
        self.position.x = initialDx!
        self.position.y = initialDy!
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.categoryBitMask = CollisionCategories.Platform
        self.physicsBody?.contactTestBitMask = CollisionCategories.Character
        self.physicsBody?.collisionBitMask = 0
    }
    
    override func Update()
    {
        if (position.x < -550)
        {
            Reset()
        }
        else
        {
            position.x -= 1
        }
    }
}
