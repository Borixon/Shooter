//
//  Enemy.swift
//  Balls of Steel
//
//  Created by Michał.Krupa on 14/03/2019.
//  Copyright © 2019 Michał.Krupa. All rights reserved.
//

import SpriteKit

class Enemy: Persona {
    
    private var legs:SKSpriteNode
    private var head:SKSpriteNode
    private var body:SKSpriteNode
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(inPosition pos:CGPoint) {
        
        let enemyScene      = SKScene(fileNamed: "Enemy.sks")
        let enemyNode       = enemyScene?.childNode(withName: "EnemyNode")
        let enemyHitbox     = enemyNode?.childNode(withName: "Hitbox") as? SKSpriteNode
        let legsScene       = enemyNode?.childNode(withName: "Legs") as? SKSpriteNode
        let bodyScene       = legsScene?.childNode(withName: "Body") as? SKSpriteNode
        let headScene       = bodyScene?.childNode(withName: "Head") as? SKSpriteNode
        
        legs        = SKSpriteNode(texture: SKTexture(imageNamed: "Legs"), color: UIColor.blue, size: legsScene!.size)
        body        = SKSpriteNode(texture: SKTexture(imageNamed: "Body1"), color: UIColor.yellow, size: bodyScene!.size)
        head        = SKSpriteNode(texture: SKTexture(imageNamed: "Head"), color: UIColor.green, size: headScene!.size)
  
        legs.anchorPoint    = legsScene!.anchorPoint
        legs.position       = legsScene!.position
        print("legs position \(legs.position)")
        head.anchorPoint    = headScene!.anchorPoint
        head.position       = headScene!.position
        body.anchorPoint    = bodyScene!.anchorPoint
        body.position       = bodyScene!.position
        
        super.init(texture: nil, color: UIColor.clear, size: enemyHitbox!.size)
        
        name        = "enemy"
        position    = pos
        zPosition   = 1
        xScale      = -1
        
        setPhysicBody()
        setChildrens()
        setLightnigMasks()
    }
    
    override func update() {
        print("enemy \(self.position)")
    }
    
    private func setChildrens() {
        addChild(legs)
        legs.addChild(body)
        body.addChild(head)
        
    }
    
    public func addBulletHole(atPosition pos:CGPoint) {
        let bulletHole = SKSpriteNode(texture: SKTexture(image: UIImage(named: "BulletHole")!), size: CGSize(width: 3, height: 5))
        bulletHole.position.y = pos.y
        bulletHole.position.x = CGFloat.random(in: (size.width*(-0.5))...(size.width*0.5))
        addChild(bulletHole)
    }
    
    override func setLightnigMasks() {
        lightingBitMask = 1
        for child in self.legs.children {
            if let childSprite = child as? SKSpriteNode {
                childSprite.lightingBitMask = 1
            }
        }
    }
    
    override func setPhysicBody() {
        
 

        
//        legs.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Legs"), size: SKTexture(imageNamed: "Legs").size())
//        legs.physicsBody?.affectedByGravity     = true
//        legs.physicsBody?.isDynamic             = true
//        legs.physicsBody?.allowsRotation        = false
//        legs.physicsBody?.pinned                = false
//        legs.physicsBody?.categoryBitMask       = ObjectType.EnemyLegs.rawValue
//        legs.physicsBody?.contactTestBitMask    = ObjectType.PlayerBullet.rawValue
        
//        body.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Body1"), size: SKTexture(imageNamed: "Body1").size())
//        body.physicsBody?.affectedByGravity     = true
//        body.physicsBody?.isDynamic             = true
//        body.physicsBody?.allowsRotation        = false
//        body.physicsBody?.pinned                = true
//        body.physicsBody?.categoryBitMask       = ObjectType.EnemyBody.rawValue
//        body.physicsBody?.contactTestBitMask    = ObjectType.PlayerBullet.rawValue
//
//        head.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Legs"), size: SKTexture(imageNamed: "Legs").size())
//        head.physicsBody?.affectedByGravity     = true
//        head.physicsBody?.isDynamic             = true
//        head.physicsBody?.allowsRotation        = false
//        head.physicsBody?.pinned                = true
//        head.physicsBody?.categoryBitMask       = ObjectType.EnemyHead.rawValue
//        head.physicsBody?.contactTestBitMask    = ObjectType.PlayerBullet.rawValue
//
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity  = true
        physicsBody?.restitution        = 0
        physicsBody?.friction           = 1
        physicsBody?.mass               = 80
        physicsBody?.allowsRotation     = false
        physicsBody?.categoryBitMask    = ObjectType.Enemy.rawValue
        physicsBody?.contactTestBitMask = ObjectType.PlayerBullet.rawValue
        physicsBody?.collisionBitMask   = ObjectType.Wall.rawValue | ObjectType.Floor.rawValue | ObjectType.InvisibleBound.rawValue | ObjectType.PlayerBullet.rawValue
        
    }
    
}
