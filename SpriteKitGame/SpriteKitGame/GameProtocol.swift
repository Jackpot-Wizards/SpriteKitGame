//
//  GameProtocol.swift
//  SpriteKitGame
//
//  Created by Ignat Pechkurenko on 2020-01-25.
//  Copyright © 2020 Jackpot-Wizards. All rights reserved.
//

import Foundation

protocol GameProtocol
{
    func CheckBounds()
    
    func Reset()
    
    func Start()
    
    func Update()
}
