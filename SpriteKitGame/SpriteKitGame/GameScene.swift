//
//  GameScene.swift
//  SpriteKitGame
//
//  Created by Ignat Pechkurenko on 2020-01-25.
//  Copyright © 2020 Jackpot-Wizards. All rights reserved.
//

import SpriteKit
import GameplayKit

struct CollisionCategories {
    static let Character: UInt32 = 0x01;
    static let Platform: UInt32 = 0x02;
    static let Ground: UInt32 = 0x04;
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var characterNode : Character!
    private var groundNode : SKSpriteNode!
    private var platformNode : SKSpriteNode!
    private var characterXSpeed : CGFloat = 0.0
    
    private let platformTestSpeed : CGFloat = 0.05
    
    override func sceneDidLoad() {
        
        physicsWorld.contactDelegate = self
        
        characterNode = Character()
        characterNode.position = CGPoint(x: 250, y: -100)
        addChild(characterNode)
        
        groundNode = self.childNode(withName: "//groundNode") as? SKSpriteNode
        groundNode.physicsBody = SKPhysicsBody(rectangleOf: groundNode.size)
        groundNode.physicsBody?.isDynamic = false
        groundNode.physicsBody?.categoryBitMask = CollisionCategories.Ground
        groundNode.physicsBody?.collisionBitMask = 0
        
        platformNode = self.childNode(withName: "//platform") as? SKSpriteNode
        platformNode.physicsBody = SKPhysicsBody(rectangleOf: platformNode.size)
        platformNode.physicsBody?.isDynamic = false
        platformNode.physicsBody?.restitution = 0.0
        platformNode.physicsBody?.categoryBitMask = CollisionCategories.Platform
        platformNode.physicsBody?.contactTestBitMask = CollisionCategories.Character
        platformNode.physicsBody?.collisionBitMask = 0
        
        characterNode.physicsBody = SKPhysicsBody(rectangleOf: characterNode.size)
        characterNode.physicsBody?.isDynamic = true
        characterNode.physicsBody?.angularDamping = 0.0
        characterNode.physicsBody?.allowsRotation = false
        characterNode.physicsBody?.restitution = 0.0
        characterNode.physicsBody?.usesPreciseCollisionDetection = true
        characterNode.physicsBody?.categoryBitMask = CollisionCategories.Character
        characterNode.physicsBody?.contactTestBitMask = CollisionCategories.Platform
        characterNode.physicsBody?.collisionBitMask = CollisionCategories.Ground
    }
    
    func HadleCharacterCollision(character: SKNode, object: SKNode)
    {
        if (object.name == "platform")
        {
            // comparison with 0 here doesn't work -
            // while being on a platform and making short tap, after the character lands,
            // velocity is equal to very small value for some reason (maybe because of bounce
            // despite restitution is set to zero?)
            if ((character.physicsBody?.velocity.dy)! >= 0.1)
            {
                print((character.physicsBody?.velocity.dy)!)
                characterNode.physicsBody?.collisionBitMask = CollisionCategories.Ground
            }
            else
            {
                characterNode.physicsBody?.collisionBitMask = CollisionCategories.Ground | CollisionCategories.Platform
                characterXSpeed = platformTestSpeed
            }
        }
    }
    
    func HadleCharacterCollisionEnd(character: SKNode, object: SKNode)
    {
        if (object.name == "platform")
        {
            // need to set character speed to 0
            characterXSpeed = 0
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        if contact.bodyA.node?.name == "character"
        {
            HadleCharacterCollision(character: contact.bodyA.node!, object: contact.bodyB.node!)
        }
        else if contact.bodyB.node?.name == "character"
        {
            HadleCharacterCollision(character: contact.bodyB.node!, object: contact.bodyA.node!)
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact)
    {
        if contact.bodyA.node?.name == "character"
        {
            HadleCharacterCollisionEnd(character: contact.bodyA.node!, object: contact.bodyB.node!)
        }
        else if contact.bodyB.node?.name == "character"
        {
            HadleCharacterCollisionEnd(character: contact.bodyB.node!, object: contact.bodyA.node!)
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        characterNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 200))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // just for test
        platformNode.position.x -= self.platformTestSpeed
        characterNode.position.x -= characterXSpeed
    }
}
