//
//  GameProtocol.swift
//  Game object protocol
//
//  Created by
//  Ignat Pechkurenko - 301091721
//  Blair Desjardins  - 301086973
//  Heun Oh           - 301082798
//
//  Date last modified: Feb 11 2020
//  Version 1.0

import Foundation

protocol GameProtocol
{
    func CheckBounds()
    
    func Reset()
    
    func Start()
    
    func Update()
}
