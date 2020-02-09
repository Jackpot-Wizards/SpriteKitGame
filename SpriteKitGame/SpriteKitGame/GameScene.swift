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
    private var groundNode1 : Ground?
    private var groundNode2 : Ground?
    private var backGroundNode1: Background?
    private var backGroundNode2: Background?
    private var middleGroundNode1: Background?
    private var middleGroundNode2: Background?
    
    private var bullets : Array<Bullet> = Array()
    private var enemies : Array<Enemy> = Array()
    
    // For the platforms
    private var platformListOnScreen : Array<Platform> = Array()    // List of platforms on the screen
    private var platformController : PlatformController?            // Platfrom controller(generator)
    private let platformDuration = 360                              // Durations between platforms(ms)
    
    var gameCount: Int = 0
    var gameScore: Int = GameOptions.InitScore
    var gameLife: Int = GameOptions.InitLife
    
    // Reset Game based on the level
    func ResetGame(level : String) {
        gameCount = 0
        gameScore = GameOptions.InitScore
        gameLife = GameOptions.InitLife
        
        bullets = [Bullet]()
        enemies = [Enemy]()
        platformListOnScreen = [Platform]()
        
        // Initialize platformController
        platformController = PlatformController(level)
        
        
        addNewPlatformsToScreen()
    }
    
    override func sceneDidLoad() {
        
        physicsWorld.contactDelegate = self
        
        // Reset Game paramerters
        ResetGame(level:"platformsLevel1")
        
        CreateBackGround()
        CreateGround()
        CreateEnemy(xPosition: 400, yPosition: -140)
        CreateCharacter()
    }

    func HandleCharacterCollision(character: SKNode, object: SKNode, contactPoint: CGPoint, contactNormal: CGVector)
    {
        if (object.name == "platform")
        {
            //print("contact point = (\(contactPoint.x), \(contactPoint.y))")
            print("contact vector = (\(contactNormal.dx), \(contactNormal.dy))")
            let characterPosition = character.position
            
            var characterObject = character as! Character
            var platformObject = object as! Platform
            
            if contactNormal.dx == 0
            {
                if ((character.physicsBody?.velocity.dy)! >= 0)
                {
                    // need to check the normalvector
                    character.physicsBody?.collisionBitMask = CollisionCategories.Ground
                }
                else
                {
                    // if we were falling when contact happened
                    character.physicsBody?.collisionBitMask = CollisionCategories.Ground | CollisionCategories.Platform
                }
            }
        }
        else if(object.name == "enemy")
        {
            (object as? Enemy)!.isDestroyed = true
            
            self.gameLife -= 1
            gameManager?.UpdateLife(value: self.gameLife)
            if 0 == self.gameLife {
                self.isGameEnd = true
                self.gameManager?.PresentEndScene()
            }
            
        } else {}
    }
    
    func HandleCharacterCollisionEnd(character: SKNode, object: SKNode)
    {
        if (object.name == "platform")
        {
            character.physicsBody?.collisionBitMask = CollisionCategories.Ground
            // need to set character speed to 0
//            characterXSpeed = 0
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
            groundNode1?.Update()
            groundNode2?.Update()
            backGroundNode1?.Update()
            backGroundNode2?.Update()
            middleGroundNode1?.Update()
            middleGroundNode2?.Update()

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
                    CreateBullet()
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
        characterNode.position = CGPoint(x: -290, y: -80)
        addChild(characterNode)
    }
    
    func CreateGround()
    {
        groundNode1 = Ground(16, -196.5)
        groundNode2 = Ground(944, -196.5)
        addChild(groundNode1!)
        addChild(groundNode2!)
    }
    
    func CreateBackGround() {
        backGroundNode1 = Background(5.894, 0, textureSelector: 0)
        backGroundNode2 = Background(913.672, 0, textureSelector: 0)
        addChild(backGroundNode1!)
        addChild(backGroundNode2!)
        middleGroundNode1 = Background(5.894, 0, textureSelector: 1)
        middleGroundNode2 = Background(913.672, 0, textureSelector: 1)
        addChild(middleGroundNode1!)
        addChild(middleGroundNode2!)
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
