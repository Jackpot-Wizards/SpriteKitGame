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

    // Outlets
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnInstructions: UIButton!
    @IBOutlet weak var btnDescription: UIButton!
    @IBOutlet weak var btnPlayAgain: UIButton!
    @IBOutlet weak var btnReturnMain: UIButton!
    @IBOutlet weak var btnShoot: UIButton!
    
    @IBOutlet weak var labelLife: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var labelAmmo: UILabel!
    @IBOutlet weak var labelDescription: UILabel!

    
    private var posPlayButton : CGPoint?
    
    // Current scence
    var currentScene: SKScene?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set scene with StartScene
        SetScene(sceneName: "StartScene")
        PresentStartScene()
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
       - sceneName : Name of the scene.
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
                UpdateScore(value: GameOptions.InitScore)
                UpdateLife(value: GameOptions.InitLife)
                UpdateAmmo(value: GameOptions.InitAmmo)
            }
            
            // Set the scale mode to scale to fit the window
            currentScene?.scaleMode = .aspectFill
            currentScene?.name = sceneName
                            
            // Set properties of the View
            view.ignoresSiblingOrder = true
        
            // Present the scene
            view.presentScene(currentScene)
        }
    }
    
    // GameManager
    func PresentStartScene() {
        setEndView(hide: true)
        setStartView(hide: false)
        setInstructionsView(hide: true)
        
        if let posOrigin = self.posPlayButton {
            btnStart.frame.origin = posOrigin
        }
        
    }
    
    // GameManager
    func PresentEndScene() {
//        BackButtonOutlet.isHidden = false
        setEndView(hide:false)
        SetScene(sceneName: "EndScene")
    }
    
    // GameManager
    func UpdateScore(value:Int) {
        labelScore.text = "SCORE: \(value)"
    }
    // GameManager
    func UpdateLife(value:Int) {
        labelLife.text = "LIFE: \(value)"
    }
    // GameManager
    func UpdateAmmo(value:Int) {
        labelAmmo.text = "\(value)"
    }
    
    @IBAction func OnClickStartButton(_ sender: UIButton) {
        if let gameScene = currentScene as? GameScene
        {
            gameScene.ResetGame(level: "level01")
            gameScene.isGameEnd = false
        } else {
            // Change to GameScene
            SetScene(sceneName: "GameScene")
        }
        
        setEndView(hide: true)
        setStartView(hide:true)
        setInstructionsView(hide:true)
    }
    
    @IBAction func OnClickInstructionButton(_ sender: UIButton) {
        btnInstructions.isHidden = true
        setInstructionsView(hide:false)
        
        posPlayButton = btnStart.frame.origin
        btnStart.frame.origin = CGPoint(x: btnStart.frame.origin.x, y: 350)
        btnDescription.setImage(UIImage(named: "ins01"), for: .normal)
    }
    
    @IBAction func OnClickDescription(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "ins01") {
            sender.setImage(UIImage(named: "ins02"), for: .normal)
        }
        else {
            sender.setImage(UIImage(named: "ins01"), for: .normal)
        }
    }
    
    @IBAction func OnClickReturnMain(_ sender: UIButton) {
        // Set scene with StartScene
        SetScene(sceneName: "StartScene")
        PresentStartScene()
    }
    
    @IBAction func onClickShoot(_ sender: Any) {
        if currentScene?.name == "GameScene" {
            if let gameScene = currentScene as? GameScene {
                gameScene.btnShootPressed()
            }
        }
    }
    
    func setStartView(hide:Bool) {
        btnStart.isHidden = hide
        btnInstructions.isHidden = hide
        labelAmmo.isHidden = !hide
        btnShoot.isHidden = !hide
    }
    
    func setInstructionsView(hide:Bool) {
        labelDescription.isHidden = hide
        btnDescription.isHidden = hide
    }
    
    func setEndView(hide:Bool) {
        btnPlayAgain.isHidden = hide
        btnReturnMain.isHidden = hide
        labelAmmo.isHidden = !hide
        btnShoot.isHidden = !hide
    }
}
