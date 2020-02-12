//
//  CollisionCategories.swift
//
//  Created by
//  Ignat Pechkurenko - 301091721
//  Blair Desjardins  - 301086973
//  Heun Oh           - 301082798
//
//  Date last modified: Feb 11 2020
//  Version 1.0

import Foundation

struct CollisionCategories {
    static let Character: UInt32 = 1;
    static let Platform: UInt32 = 2;
    static let Ground: UInt32 = 4;
    static let Bullet: UInt32 = 8;
    static let Enemy: UInt32 = 16;
    static let Ammo: UInt32 = 32;
}
