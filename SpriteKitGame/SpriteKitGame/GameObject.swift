//
//  GameObject.swift
//  Game object class to be inherited by all game objects
//
//  Created by
//  Ignat Pechkurenko - 301091721
//  Blair Desjardins  - 301086973
//  Heun Oh           - 301082798
//
//  Date last modified: Feb 11 2020
//  Version 1.0

import Foundation
import SpriteKit
import GameplayKit

class GameObject: SKSpriteNode, GameProtocol
{
    // Instance Members
    var dx: CGFloat?
    var dy: CGFloat?
    var width: CGFloat?
    var height: CGFloat?
    var halfHeight: CGFloat?
    var halfWidth: CGFloat?
    var scale: CGFloat?
    var isColliding: Bool?
    var randomSource: GKARC4RandomSource?
    var randomDist: GKRandomDistribution?
    
    init() {
        let texture = SKTexture(imageNamed: "bubble")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.isHidden = true
    }
    
    init(imageString: String, size: CGSize)
    {
        // initialize the object with an image
        let texture = SKTexture(imageNamed: imageString)
        let color = UIColor.clear
        super.init(texture: texture, color: color, size: size)
        
        self.width = size.width
        self.height = size.height
        self.halfWidth = self.width! * 0.5
        self.halfHeight = self.height! * 0.5
        self.isColliding = false
        self.name = imageString
        randomSource = GKARC4RandomSource()
    }
    
    init(imageString: String, initialScale: CGFloat)
    {
        // initialize the object with an image
        let texture = SKTexture(imageNamed: imageString)
        let color = UIColor.clear
        super.init(texture: texture, color: color, size: texture.size())
        
        self.scale = initialScale
        self.setScale(scale!)
        self.width = texture.size().width * self.scale!
        self.height = texture.size().height * self.scale!
        self.halfWidth = self.width! * 0.5
        self.halfHeight = self.height! * 0.5
        self.isColliding = false
        self.name = imageString
        randomSource = GKARC4RandomSource()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func CheckBounds() {
        
    }
    
    public func Reset() {
        
    }
    
    public func Start() {
        
    }
    
    public func Update() {
        
    }
}
