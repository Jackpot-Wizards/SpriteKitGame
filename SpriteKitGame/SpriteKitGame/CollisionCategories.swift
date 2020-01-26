//
//  CollisionCategories.swift
//  SpriteKitGame
//
//  Created by Ignat Pechkurenko on 2020-01-26.
//  Copyright © 2020 Jackpot-Wizards. All rights reserved.
//

import Foundation

struct CollisionCategories {
    static let Character: UInt32 = 1;
    static let Platform: UInt32 = 2;
    static let Ground: UInt32 = 4;
    static let Bullet: UInt32 = 8;
    static let Enemy: UInt32 = 16;
}
