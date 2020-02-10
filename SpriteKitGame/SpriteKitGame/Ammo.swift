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
    
    private var animFrames: [SKTexture] = []

    // constructor
    override init()
    {
        super.init(imageString: "gun_control", size: CGSize(width: 50.0, height: 50.0))
        dx = 2
        super.name = "ammo"
        buildAnimations()
        animate()
        Start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildAnimations() {
        let animatedAtlas = SKTextureAtlas(named: "power-up")
        
        let numAnimImages = animatedAtlas.textureNames.count
        for i in 1...numAnimImages {
            let animTextureName = "power-up-\(i)"
            animFrames.append(animatedAtlas.textureNamed(animTextureName))
        }
    }
    
    func animate() {
        self.run(SKAction.repeatForever(
          SKAction.animate(with: animFrames,
                           timePerFrame: 0.1,
                           resize: false,
                           restore: true)),
                 withKey:"anim")
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
        self.position.x -= dx!
    }
    
    
    func TouchMove(newPos: CGPoint)
    {
    }
}
