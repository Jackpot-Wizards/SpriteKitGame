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
    
    var initialX: CGFloat?
    var initialY: CGFloat?
    var leftSpeed: CGFloat?


    // Init from dictionay
    convenience init?(dict: [String : Any]) {
        let x = dict["x"] as? CGFloat
        let y = dict["y"] as? CGFloat
        let speed = dict["speed"] as? CGFloat
        
        let width = dict["width"] as? CGFloat
        let height = dict["height"] as? CGFloat
        self.init(x!, y!, width!, height!, speed!)
    }
    
    init(_ initialX: CGFloat, _ initialY: CGFloat, _ width: CGFloat, _ height: CGFloat, _ leftSpeed: CGFloat)
    {
        super.init(imageString: "nextButton", size: CGSize(width: width, height: height))
        self.name = "platform"
        
        self.initialX = initialX
        self.initialY = initialY
        self.leftSpeed = leftSpeed
        
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
        position.x = initialX!
        isDestroyed = false
    }
    
    override func Start()
    {
        self.zPosition = 2
        
        self.position.x = initialX!
        self.position.y = initialY!
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.categoryBitMask = CollisionCategories.Platform
        self.physicsBody?.contactTestBitMask = CollisionCategories.Character
        self.physicsBody?.collisionBitMask = 0
    }
    
    override func Update()
    {
        // TODO : replace -475
        if (self.position.x + self.halfWidth! < -475)
        {
            isDestroyed = true;
        }
        else
        {
            self.position.x -= leftSpeed!
        }
    }
}
