//
//  Charecter.swift
//  SpriteKitGame
//
//  Created by Ignat Pechkurenko on 2020-01-25.
//  Copyright © 2020 Jackpot-Wizards. All rights reserved.
//

import Foundation
import SpriteKit

class Character: GameObject
{
    enum playerState {
        case running
        case jumping
        case run_shooting
        case jump_shooting
        case taking_damage
    }
    
    var currState: playerState?
    
    private var runFrames: [SKTexture] = []
    private var jumpFrames: [SKTexture] = []
    
    var jumpAction: SKAction!
    
    var numOfJumps = 1
    var isInFirstJump: Bool = true
    var characterSpeed = 0.0
    
    // constructor
    override init()
    {
        super.init(imageString: "character", size: CGSize(width: 200.0, height: 200.0))
        buildAnimations()
        Start()
        animate()
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
        self.zPosition = 5
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 112), center: CGPoint(x: self.position.x, y: self.position.y))
        self.physicsBody?.mass = 0.5
        self.physicsBody?.isDynamic = true
        self.physicsBody?.angularDamping = 0.0
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = CollisionCategories.Character
        self.physicsBody?.contactTestBitMask = CollisionCategories.Platform + CollisionCategories.Enemy
        self.physicsBody?.collisionBitMask = CollisionCategories.Ground
    }
    
    func buildAnimations() {
        currState = playerState.running
        
        let runAnimatedAtlas = SKTextureAtlas(named: "player-run")
        
        let numRunImages = runAnimatedAtlas.textureNames.count
        for i in 1...numRunImages {
            let runTextureName = "player-run-\(i)"
            runFrames.append(runAnimatedAtlas.textureNamed(runTextureName))
        }
        
        let jumpAnimatedAtlas = SKTextureAtlas(named: "player-jump")
        
        let numJumpImages = jumpAnimatedAtlas.textureNames.count
        for i in 1...numJumpImages {
            let jumpTextureName = "player-jump-\(i)"
            jumpFrames.append(jumpAnimatedAtlas.textureNamed(jumpTextureName))
        }
        
    }
    
    func animate() {
        if let state = currState {
            switch state {
            case playerState.running:
                self.run(SKAction.repeatForever(
                  SKAction.animate(with: runFrames,
                                   timePerFrame: 0.1,
                                   resize: false,
                                   restore: true)),
                         withKey:"running")
            case playerState.jumping:
                self.run(SKAction.repeatForever(
                    SKAction.animate(with: jumpFrames,
                                     timePerFrame: 0.1,
                                     resize: false,
                                     restore: true)),
                         withKey:"jumping")
            default:
                break
            }
        }
    }
    
    override func Update()
    {
        if self.position.x != 0
        {
            self.position.x = 0
        }
        
        // cannot jump while fallin
        if (self.physicsBody?.velocity.dy)! < -0.1
        {
            numOfJumps = 0
        }
        
        if ((self.physicsBody?.velocity.dy)! < 0.1 && (self.physicsBody?.velocity.dy)! >= -0.1 && numOfJumps < 1)
        {
            numOfJumps = 1
            self.removeAction(forKey: "jumping")
            currState = playerState.running
            animate()
        }
    }
    
    
    func TouchMove(newPos: CGPoint)
    {
        self.position = newPos
    }
    
    func Jump()
    {
        if ((self.physicsBody?.velocity.dy)! < 0.1 && (self.physicsBody?.velocity.dy)! > -0.1 && numOfJumps == 1)
        {
            self.removeAction(forKey: "running")
            currState = playerState.jumping
            animate()
            
            numOfJumps -= 1
            FirstJump()
        }
    }
    
    func FirstJump()
    {
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 350))
    }
    
}

