//
//  GameScene.swift
//  SpriteKitGame
//
//  Created by Ignat Pechkurenko on 2020-01-25.
//  Copyright © 2020 Jackpot-Wizards. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameManager: GameManager?
    var isGameEnd : Bool = false
    
    private var characterNode : Character!
    private var groundNode : SKSpriteNode!
    
    private var bullets : Array<Bullet> = Array()
    private var enemies : Array<Enemy> = Array()
    private var ammos: Array<Ammo> = Array()
    
    // For the platforms
    private var platformListOnScreen : Array<Platform> = Array()    // List of platforms on the screen
    private var platformController : PlatformController?            // Platfrom controller(generator)
    private let platformDuration = 360                              // Durations between platforms(ms)
    
    var gameCount: Int = 0
    var gameScore: Int = GameOptions.InitScore
    var gameLife: Int = GameOptions.InitLife
    var ammoCount: Int = GameOptions.InitAmmo
    
    // Reset Game based on the level
    func ResetGame(level : String) {
        gameCount = 0
        gameScore = GameOptions.InitScore
        gameLife = GameOptions.InitLife
        ammoCount = GameOptions.InitAmmo
        
        bullets = [Bullet]()
        enemies = [Enemy]()
        ammos = [Ammo]()
        
        platformListOnScreen = [Platform]()
        
        // Initialize platformController
        platformController = PlatformController(level)
        
        
        addNewPlatformsToScreen()
    }
    
    override func sceneDidLoad() {
        
        physicsWorld.contactDelegate = self
        
        // Reset Game paramerters
        ResetGame(level:"platformsLevel1")
        
        CreateGround()
        CreateCharacter()
        CreateEnemy(xPosition: 400, yPosition: -140)
    }

    func HandleCharacterCollision(character: SKNode, object: SKNode, contactPoint: CGPoint, contactNormal: CGVector)
    {
        if (object.name == "platform")
        {

                if ((character.physicsBody?.velocity.dy)! >= 0)
                {
                    // need to check the normalvector
                    character.physicsBody?.collisionBitMask = CollisionCategories.Ground
                }
                else if contactNormal.dx == 0
                {
                    // if we were falling when contact happened
                    character.physicsBody?.collisionBitMask = CollisionCategories.Ground | CollisionCategories.Platform
                }
        }
        else if object.name == "enemy"
        {
            (object as? Enemy)!.isDestroyed = true
            
            self.gameLife -= 1
            gameManager?.UpdateLife(value: self.gameLife)
            
            if 0 == self.gameLife
            {
                self.isGameEnd = true
                self.gameManager?.PresentEndScene()
            }
        }
        else if object.name == "ammo"
        {
            (object as? Ammo)!.isDestroyed = true
            
            self.ammoCount += 1
            
            gameManager?.UpdateAmmo(value: self.ammoCount)
            
            for (i,ammo) in ammos.enumerated().reversed()
            {
                
                if ammo.isDestroyed
                {
                    ammos.remove(at: i)
                    ammo.removeFromParent()
                }
            }
        }
    }
    
    func HandleCharacterCollisionEnd(character: SKNode, object: SKNode)
    {
        if (object.name == "platform")
        {
            character.physicsBody?.collisionBitMask = CollisionCategories.Ground
        }
    }
    
    func HandleBulletCollision(bullet: SKNode, object: SKNode)
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
            HandleCharacterCollision(character: contact.bodyA.node!, object: contact.bodyB.node!, contactPoint: contact.contactPoint, contactNormal: contact.contactNormal)
        }
        else if contact.bodyB.node?.name == "character"
        {
            HandleCharacterCollision(character: contact.bodyB.node!, object: contact.bodyA.node!, contactPoint: contact.contactPoint, contactNormal: contact.contactNormal)
        }
        else if contact.bodyA.node?.name == "bullet"
        {
            HandleBulletCollision(bullet: contact.bodyA.node!, object: contact.bodyB.node!)
        }
        else if contact.bodyB.node?.name == "bullet"
        {
            HandleBulletCollision(bullet: contact.bodyB.node!, object: contact.bodyA.node!)
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact)
    {
        if contact.bodyA.node?.name == "character"
        {
            HandleCharacterCollisionEnd(character: contact.bodyA.node!, object: contact.bodyB.node!)
        }
        else if contact.bodyB.node?.name == "character"
        {
            HandleCharacterCollisionEnd(character: contact.bodyB.node!, object: contact.bodyA.node!)
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
    
    
    override func update(_ currentTime: TimeInterval)
    {
        // TODO : check overflow
        // TODO : check end condition
        self.gameCount += 1
        
        if(0 == self.gameCount%60) {
            gameManager?.UpdateScore(value: self.gameCount/60)
        }
        
        if false == self.isGameEnd
        {
            characterNode.Update()

            // Update platforms
            for (i, platform) in platformListOnScreen.enumerated().reversed()
            {
                platform.Update()
                if platform.isDestroyed
                {
                    platformListOnScreen.remove(at:i)
                    platform.removeFromParent()
                    platform.Reset()
                }
            }
            
            // Add new platfroms to the screen in every 'platformDuration' duration
            if(0 == self.gameCount%platformDuration) {
                addNewPlatformsToScreen()
            }
            
            
            // Update bullets
            for (i, bullet) in bullets.enumerated().reversed()
            {
                bullet.Update()
                
                if bullet.position.x > 475
                {
                    bullets.remove(at: i)
                    bullet.removeFromParent()
                }
            }
            
            if (ammos.count == 0)
            {
                // this is just for testing
                CreateAmmo(xPosition: 300, yPosition: -140)
            }
            
            // Update ammos
            for (i, ammo) in ammos.enumerated().reversed()
            {
                ammo.Update()
                
                if ((ammo.position.x < -475) || (ammo.isDestroyed))
                {
                    ammos.remove(at: i)
                    ammo.removeFromParent()
                }
            }
            
            
            if (enemies.count == 0)
            {
                // this is just for testing
                CreateEnemy(xPosition: 400, yPosition: -140)
            }
            
            // Update enemies
            for (i, enemy) in enemies.enumerated().reversed()
            {
                enemy.Update()
                
                if ((enemy.position.x < -475) || (enemy.isDestroyed))
                {
                    enemies.remove(at: i)
                    enemy.removeFromParent()
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if false == self.isGameEnd
        {
            for touch in touches {
                let location = touch.location(in: self)
                let node : SKNode = self.atPoint(location)
                
                if node.name == "gunControl" {
                    print("gunControl clicked")
                    
                    if self.ammoCount > 0
                    {
                        CreateBullet()
                        
                        self.ammoCount -= 1
                        
                        gameManager?.UpdateAmmo(value: self.ammoCount)
                    }
                    
                }
                else
                {
                    characterNode.Jump()
                }
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
        groundNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 896.0, height: 45))
        groundNode.physicsBody?.isDynamic = false
        groundNode.physicsBody?.restitution = 0
        groundNode.physicsBody?.categoryBitMask = CollisionCategories.Ground
        groundNode.physicsBody?.collisionBitMask = 0
    }
    
    func CreateAmmo(xPosition: CGFloat, yPosition: CGFloat)
    {
        let ammoNode : Ammo = Ammo()
        
        ammoNode.position.x = xPosition
        ammoNode.position.y = yPosition
        ammos.append(ammoNode)
        addChild(ammoNode)
    }
    
    func CreateEnemy(xPosition: CGFloat, yPosition: CGFloat)
    {
        let enemyNode : Enemy = Enemy()
        
        enemyNode.position.x = xPosition
        enemyNode.position.y = yPosition
        enemies.append(enemyNode)
        addChild(enemyNode)
    }
    
    func CreateBullet()
    {
        let bulletNode : Bullet = Bullet()
        
        bulletNode.position.x = characterNode.position.x + 25
        bulletNode.position.y = characterNode.position.y - 12
        bullets.append(bulletNode)
        addChild(bulletNode)
    }
    
    /**
     Add new platforms to the screen from the platform list pool
     */
    func addNewPlatformsToScreen()
    {
        if let newPlatformList = platformController?.getNewPlatformList()
        {
            for plt in newPlatformList
            {
                if plt.parent == nil
                {
                    platformListOnScreen.append(plt)
                    addChild(plt)
                }
            }
        }
    }

}
