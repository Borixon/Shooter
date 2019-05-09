//
//  Shell.swift
//  Game
//
//  Created by Michał.Krupa on 11/03/2019.
//  Copyright © 2019 Michał.Krupa. All rights reserved.
//

import SpriteKit

class Shell: SKSpriteNode {
    
    static let soundAction1 = SKAction.playSoundFileNamed("GameShell1.mp3", waitForCompletion: false)
    static let soundAction2 = SKAction.playSoundFileNamed("GameShell2.mp3", waitForCompletion: false)
    static let soundAction3 = SKAction.playSoundFileNamed("GameShell3.mp3", waitForCompletion: false)
    private var fallen:Bool = false
    
    init(angle:CGFloat, position:CGPoint) {
        super.init(texture: SKTexture(image: UIImage.init(named: "ShellM4")!), color: UIColor.clear, size: CGSize(width: 6, height: 2))
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity     = true
        self.physicsBody?.categoryBitMask       = ObjectType.Shell.rawValue
        self.physicsBody?.contactTestBitMask    = ObjectType.Floor.rawValue | ObjectType.Wall.rawValue
        self.physicsBody?.collisionBitMask      = ObjectType.Floor.rawValue | ObjectType.Wall.rawValue
        self.physicsBody?.restitution           = 0.5
        self.physicsBody?.mass                  = 0.001
        self.physicsBody?.friction              = 0.3
        
        self.zPosition = 1
        self.position  = position + CGPoint(x: -10, y: 8)
        self.zRotation = angle
        
        self.run(SKAction.applyTorque(createRandomTorque(), duration: 0.1))
        self.run(SKAction.applyImpulse(createForceVector(fromAngle: angle), duration: 0.1))
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5), execute: {
            self.removeFromParent()
        })
    }
    
    private func createRandomTorque() -> CGFloat{
        let randTorque = Float.random(in: 0.00001...0.0001)
        let randDir = Float.random(in: -1...1)
        return CGFloat(randTorque) * (randDir > 0 ? 1.0 : -1.0)
    }
    
    private func createForceVector(fromAngle angle:CGFloat) -> CGVector {
        let addAngle = CGFloat.pi/2// + CGFloat.pi/CGFloat.random(in: 8...10)
        let dir:CGFloat = abs(angle) < addAngle ? 1 : -1
        let scale:CGFloat = CGFloat.random(in: 0.5...0.65)
        return CGVector(dx: cos(angle+addAngle) * scale * dir, dy: sin(angle+addAngle) * scale * dir)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func playContactSound() {
        guard !fallen else { return }
        let rand = Int.random(in: 0...2)
        switch rand {
        case 0:
            run(Shell.soundAction1)
        case 1:
            run(Shell.soundAction2)
        default:
            run(Shell.soundAction3)
        }
        fallen = true
    }
}

class Bullet:SKSpriteNode, SKPhysicsContactDelegate {
    static let soundAction = SKAction.playSoundFileNamed("GunShot.mp3", waitForCompletion: false)
    let bulletSpeed:CGFloat = 10.0
    
    init(angle:CGFloat, position:CGPoint) {
        super.init(texture: SKTexture(image: UIImage.init(named: "BulletM4")!), color: UIColor.red, size: CGSize(width: 6, height: 2))
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity     = false
        self.physicsBody?.categoryBitMask       = ObjectType.PlayerBullet.rawValue
        self.physicsBody?.contactTestBitMask    = ObjectType.Floor.rawValue | ObjectType.Wall.rawValue
        self.physicsBody?.collisionBitMask      = ObjectType.Floor.rawValue | ObjectType.Wall.rawValue
        self.physicsBody?.restitution           = 0.0
        self.physicsBody?.mass                  = 0.001
        self.physicsBody?.friction              = 0.3
        
        self.zPosition = 1
        self.position  = position + CGPoint(x: -10, y: 8)
        self.zRotation = angle
        
        self.run(SKAction.sequence([Bullet.soundAction, SKAction.applyForce(createForceVector(fromAngle: angle), duration: 1)]))
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1), execute: {
            self.removeFromParent()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createForceVector(fromAngle angle:CGFloat) -> CGVector {
        let dx:CGFloat = cos(angle) * bulletSpeed
        let dy:CGFloat = sin(angle) * bulletSpeed
        return CGVector(dx: dx, dy: dy)
    }
     
}
