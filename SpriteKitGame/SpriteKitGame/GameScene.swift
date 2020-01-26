//
//  GameScene.swift
//  SpriteKitGame
//
//  Created by Ignat Pechkurenko on 2020-01-25.
//  Copyright © 2020 Jackpot-Wizards. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var characterNode : Character!
    private var groundNode : SKSpriteNode!
    private var platformNode : Platform!
    
    private var bullets : Array<Bullet> = Array()
    private var enemies : Array<Enemy> = Array()
    
    private var characterXSpeed : CGFloat = 0.0
    private let platformTestSpeed : CGFloat = 1
    
    override func sceneDidLoad() {
        
        physicsWorld.contactDelegate = self
        
        bullets = [Bullet]()
        enemies = [Enemy]()
        
        CreateGround()
        CreatePlatform()
        CreateCharacter()
        CreateEnemy(xPosition: 400, yPosition: -140)
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
                print("character velocity >= 0.1")
                print((character.physicsBody?.velocity.dy)!)
            }
            else
            {
                // if we were falling when contact happened
                print("character velocity < 0.1")
                print((character.physicsBody?.velocity.dy)!)
//                characterXSpeed = platformTestSpeed
            }
        }
    }
    
    func HadleCharacterCollisionEnd(character: SKNode, object: SKNode)
    {
        if (object.name == "platform")
        {
            print("character/platform collision ends")
            // need to set character speed to 0
//            characterXSpeed = 0
        }
    }
    
    func HadleBulletCollision(bullet: SKNode, object: SKNode)
    {
        if (object.name == "enemy")
        {
            (object as? Enemy)!.isDestroyed = true

            for (i,enemy) in enemies.enumerated().reversed()
            {
                
                if enemy.isDestroyed
                {
                    enemies.remove(at: i)
                    enemy.removeFromParent()
                }
            }
            
            (bullet as? Bullet)!.isDestroyed = true
            
            for (i,bullet) in bullets.enumerated().reversed()
            {
                
                if bullet.isDestroyed
                {
                    bullets.remove(at: i)
                    bullet.removeFromParent()
                }
            }
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
        else if contact.bodyA.node?.name == "bullet"
        {
            HadleBulletCollision(bullet: contact.bodyA.node!, object: contact.bodyB.node!)
        }
        else if contact.bodyB.node?.name == "bullet"
        {
            HadleBulletCollision(bullet: contact.bodyB.node!, object: contact.bodyA.node!)
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
    
    
    func touchDown(atPoint pos : CGPoint)
    {
    }
    
    func touchMoved(toPoint pos : CGPoint)
    {
    }
    
    func touchUp(atPoint pos : CGPoint)
    {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // just for test
        characterNode.Update()
        platformNode.Update()
        
        for (i,bullet) in bullets.enumerated().reversed()
        {
            bullet.Update()
            
            if bullet.position.x > 475
            {
                bullets.remove(at: i)
                bullet.removeFromParent()
            }
        }
        
        if (enemies.count == 0)
        {
            // this is just for testing
            CreateEnemy(xPosition: 400, yPosition: -140)
        }
        
        for (i,enemy) in enemies.enumerated().reversed()
        {
            enemy.Update()
            
            if enemy.position.x < -475
            {
                enemy.isDestroyed = true
                enemies.remove(at: i)
                enemy.removeFromParent()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches {
            let location = touch.location(in: self)
            let node : SKNode = self.atPoint(location)
            
            if node.name == "gunControl" {
                print("gunControl clicked")
                CreateBullet()
            }
            else
            {
                characterNode.Jump()
            }
        }
    }
    
    
    func CreateCharacter()
    {
        characterNode = Character()
        characterNode.position = CGPoint(x: 0, y: -100)
        addChild(characterNode)
    }
    
    func CreateGround()
    {
        groundNode = self.childNode(withName: "//groundNode") as? SKSpriteNode
        groundNode.physicsBody = SKPhysicsBody(rectangleOf: groundNode.size)
        groundNode.physicsBody?.isDynamic = false
        groundNode.physicsBody?.categoryBitMask = CollisionCategories.Ground
        groundNode.physicsBody?.collisionBitMask = 0
    }
    
    func CreatePlatform()
    {
        platformNode = Platform()
        addChild(platformNode)
    }
    
    func CreateEnemy(xPosition: CGFloat, yPosition: CGFloat)
    {
        var enemyNode : Enemy = Enemy()
        enemyNode.position.x = xPosition
        enemyNode.position.y = yPosition
        enemies.append(enemyNode)
        addChild(enemyNode)
    }
    
    func CreateBullet()
    {
        var bulletNode : Bullet = Bullet()
        
        bulletNode.position.x = characterNode.position.x + 25
        bulletNode.position.y = characterNode.position.y - 12
        bullets.append(bulletNode)
        addChild(bulletNode)
    }
}
