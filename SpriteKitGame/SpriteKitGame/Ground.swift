import SpriteKit

class Ground: GameObject {
    
    var initialX: CGFloat?
    var initialY: CGFloat?
    var leftSpeed: CGFloat?
    
    
    init(_ initialX: CGFloat, _ initialY: CGFloat)
    {
        super.init(imageString: "ground", size: CGSize(width: 928, height: 61))
        self.name = "ground"
        
        self.initialX = initialX
        self.initialY = initialY
        self.leftSpeed = 2
        
        Start()
    }
    
    override init()
    {
        super.init(imageString: "ground", size: CGSize(width: 928, height: 61))
        self.name = "ground"
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
        position.x = 944
    }
    
    override func Start()
    {
        self.zPosition = 1
        
        self.position.x = initialX!
        self.position.y = initialY!
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: 40))
        self.physicsBody?.isDynamic = false
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.categoryBitMask = CollisionCategories.Ground
        self.physicsBody?.contactTestBitMask = CollisionCategories.Character
        self.physicsBody?.collisionBitMask = 0
    }
    
    override func Update()
    {
        self.position.x -= leftSpeed!
        if (position.x < -911) {
            Reset()
        }
    }
}
