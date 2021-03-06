//
//  Platform.swift
//  SpriteKitGame
//
//  Created by Ignat Pechkurenko on 2020-01-25.
//  Copyright © 2020 Jackpot-Wizards. All rights reserved.
//

import Foundation
//
//  platform.swift
//  Platforms randomly generated from the right and move left
//
//  Created by
//  Ignat Pechkurenko - 301091721
//  Blair Desjardins  - 301086973
//  Heun Oh           - 301082798
//
//  Date last modified: Feb 11 2020
//  Version 1.0

import SpriteKit


class Platform: GameObject
{
    var isDestroyed: Bool = false
    
    var initialX: CGFloat?
    var initialY: CGFloat?

    // Init from dictionay
    convenience init?(dict: [String : Any]) {
        let x = dict["x"] as? CGFloat
        let y = dict["y"] as? CGFloat
        let speed = dict["speed"] as? CGFloat
        //let speed: CGFloat? = 10
        
        let width = dict["width"] as? CGFloat
        let height = dict["height"] as? CGFloat
        self.init(x!, y!, width!, height!, speed!)
    }
    
    init(_ initialX: CGFloat, _ initialY: CGFloat, _ width: CGFloat, _ height: CGFloat, _ leftSpeed: CGFloat)
    {
        super.init(imageString: "platform", size: CGSize(width: width, height: height))
        self.name = "platform"
        
        self.initialX = initialX
        self.initialY = initialY
        self.dx = leftSpeed
        
        Start()
    }
    
    override init()
    {
        super.init(imageString: "platform", size: CGSize(width: 250.0, height: 15.0))
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
            self.position.x -= dx!
        }
    }
}
