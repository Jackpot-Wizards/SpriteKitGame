//
//  Enemy.swift
//  Enemy class randomly spawned on ground or on platforms
//
//  Created by
//  Ignat Pechkurenko - 301091721
//  Blair Desjardins  - 301086973
//  Heun Oh           - 301082798
//
//  Date last modified: Feb 11 2020
//  Version 1.0

import Foundation
import SpriteKit

class Enemy: GameObject
{
    var isDestroyed: Bool = false
    
    private var walkFrames: [SKTexture] = []
    
    override init()
    {
        super.init(imageString: "enemy", size: CGSize(width: 80.0, height: 60.0))
        dx = 5
        buildAnimations()
        animate()
        Start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildAnimations() {
        let walkAnimatedAtlas = SKTextureAtlas(named: "crab-walk")
        
        let numWalkImages = walkAnimatedAtlas.textureNames.count
        for i in 1...numWalkImages {
            let walkTextureName = "crab-walk-\(i)"
            walkFrames.append(walkAnimatedAtlas.textureNamed(walkTextureName))
        }
    }
    
    func animate() {
        self.run(SKAction.repeatForever(
          SKAction.animate(with: walkFrames,
                           timePerFrame: 0.1,
                           resize: false,
                           restore: true)),
                 withKey:"walking")
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
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 10))
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = CollisionCategories.Enemy
        self.physicsBody?.contactTestBitMask = CollisionCategories.Bullet
        self.physicsBody?.collisionBitMask = 0
    }
    
    override func Update()
    {
        self.position.x -= self.dx!
    }
    
    
    func TouchMove(newPos: CGPoint)
    {
    }
}
