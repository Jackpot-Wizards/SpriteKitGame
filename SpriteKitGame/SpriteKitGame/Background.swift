//
//  Background.swift
//  Moving background with two different textures
//
//  Created by
//  Ignat Pechkurenko - 301091721
//  Blair Desjardins  - 301086973
//  Heun Oh           - 301082798
//
//  Date last modified: Feb 11 2020
//  Version 1.0

import SpriteKit

class Background: GameObject {
    
    var initialX: CGFloat?
    var initialY: CGFloat?
    var leftSpeed: CGFloat?
    
    var textureZ: CGFloat?
    
    init(_ initialX: CGFloat, _ initialY: CGFloat, textureSelector: Int)
    {
        var imageString = ""
        if (textureSelector == 0) {
            imageString = "background"
            self.leftSpeed = 1
            self.textureZ = CGFloat(textureSelector)
        }
        else if (textureSelector == 1){
            imageString = "middleground"
            self.leftSpeed = 2
            self.textureZ = CGFloat(textureSelector)
        }
        super.init(imageString: imageString, size: CGSize(width: 907.779, height: 414))
        self.name = imageString
        
        self.initialX = initialX
        self.initialY = initialY
        
        Start()
    }
    
    override init()
    {
        super.init(imageString: "background", size: CGSize(width: 907.779, height: 414))
        self.name = "background"
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
        position.x = 913
    }
    
    override func Start()
    {
        self.zPosition = self.textureZ!
        
        self.position.x = initialX!
        self.position.y = initialY!
    }
    
    override func Update()
    {
        self.position.x -= leftSpeed!
        if (position.x < -899) {
            Reset()
        }
    }
}
