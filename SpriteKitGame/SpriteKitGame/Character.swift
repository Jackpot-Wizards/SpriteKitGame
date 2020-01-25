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
    var jumpAction: SKAction!
    var isInJumping: Bool = false
    
    // constructor
    override init()
    {
        super.init(imageString: "character", size: CGSize(width: 100.0, height: 100.0))
        name = "character"
        Start()
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
        self.zPosition = 2
    }
    
    override func Update()
    {
        self.CheckBounds()
    }
    
    
    func TouchMove(newPos: CGPoint)
    {
        self.position = newPos
    }
}

