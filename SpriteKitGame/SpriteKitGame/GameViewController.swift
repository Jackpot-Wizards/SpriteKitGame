//
//  GameViewController.swift
//  SpriteKitGame
//
//  Created by Ignat Pechkurenko on 2020-01-25.
//  Copyright © 2020 Jackpot-Wizards. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, GameManager {

    var currentScene: SKScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set scene
        SetScene(sceneName: "GameScene")
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    /**
     Set current scene to view
      - Parameters:
       - sceneName : Name of the scene. It is the file name
      - Returns: None
     */
    func SetScene(sceneName: String)
    {
        if let view = self.view as! SKView?
        {
            // Load the SKScene from 'GameScene.sks'
            currentScene = SKScene(fileNamed: sceneName)
            
            if let gameScene = currentScene as? GameScene
            {
                gameScene.gameManager = self
            }
            
            // Set the scale mode to scale to fit the window
            currentScene?.scaleMode = .aspectFill
                            
            // Set properties of the View
            view.ignoresSiblingOrder = true
        
            // Present the scene
            view.presentScene(currentScene)
        }
    }
    
    func PresentStartScene() {
//        StartButtonOutlet.isHidden = false
    }
    
    func PresentEndScene() {
//        BackButtonOutlet.isHidden = false
//        SetScene(sceneName: "EndScene")
    }
}
