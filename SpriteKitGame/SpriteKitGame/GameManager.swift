//
//  GameManager.swift
//
//  Created by
//  Ignat Pechkurenko - 301091721
//  Blair Desjardins  - 301086973
//  Heun Oh           - 301082798
//
//  Date last modified: Feb 11 2020
//  Version 1.0

protocol GameManager
{
    func PresentStartScene()
    func PresentEndScene()
    
    func UpdateScore(value:Int)
    func UpdateLife(value:Int)
    func UpdateAmmo(value:Int)
}
