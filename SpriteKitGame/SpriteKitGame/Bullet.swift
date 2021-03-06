//
//  Bullet.swift
//  Bullet fired by player when fire button is pressed
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

class Bullet: GameObject
{
    var isDestroyed: Bool = false
    
    private var animFrames: [SKTexture] = []
    
    // constructor
    override init()
    {
        super.init(imageString: "bullet", size: CGSize(width: 30.0, height: 20.0))
        buildAnimations()
        animate()
        Start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildAnimations() {
        let animatedAtlas = SKTextureAtlas(named: "shot")
        
        let numAnimImages = animatedAtlas.textureNames.count
        for i in 1...numAnimImages {
            let animTextureName = "shot-\(i)"
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
        
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = CollisionCategories.Bullet
        self.physicsBody?.contactTestBitMask = CollisionCategories.Enemy
        self.physicsBody?.collisionBitMask = 0
    }
    
    override func Update()
    {
        self.position.x += 10
    }
    
    
    func TouchMove(newPos: CGPoint)
    {
        self.position = newPos
    }
}

