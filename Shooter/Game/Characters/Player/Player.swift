//
//  Player.swift
//  Game
//
//  Created by Michał.Krupa on 11/02/2019.
//  Copyright © 2019 Michał.Krupa. All rights reserved.
//

import SpriteKit

protocol PlayerDelegate {
    func throwShell(angle:CGFloat)
}
  
class Player: Persona {
    
    public var delegate:PlayerDelegate? = nil
    
    private var aimCross:SKSpriteNode      
    private var legs:SKSpriteNode
    private var head:SKSpriteNode
    private var body:SKSpriteNode
    private var handR:SKSpriteNode
    private var handL:SKSpriteNode
    
    private var gun:GunProtocol {
        return guns[currentGunIndex]
    }
    
    private var maxAimDistance:CGFloat {
        return guns[currentGunIndex].aimDistance
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        fatalError()
    }
    
    init(inPosition pos:CGPoint) {
        
        let playerScene  = SKScene(fileNamed: "Player.sks")
        let playerNode   = playerScene?.childNode(withName: "PlayerNode")
        let playerHitbox = playerNode?.childNode(withName: "PlayerHitbox") as? SKSpriteNode
        let legsScene    = playerNode?.childNode(withName: "Legs") as? SKSpriteNode
        let bodyScene    = legsScene?.childNode(withName: "Body") as? SKSpriteNode
        let headScene    = bodyScene?.childNode(withName: "Head") as? SKSpriteNode
        let handLScene   = bodyScene?.childNode(withName: "HandLeft") as? SKSpriteNode
        let handRScene   = bodyScene?.childNode(withName: "HandRight") as? SKSpriteNode
        
        legs        = SKSpriteNode(texture: SKTexture(imageNamed: "Legs"), size: legsScene!.size)
        body        = SKSpriteNode(texture: SKTexture(imageNamed: "Body2"), size: bodyScene!.size)
        head        = SKSpriteNode(texture: SKTexture(imageNamed: "Head"), size: headScene!.size)
        aimCross    = SKSpriteNode(texture: SKTexture(imageNamed: "AimCross"), size:CGSize(width: 40, height: 40))
        handR       = SKSpriteNode(texture: SKTexture(imageNamed: "HandRight"), size: handRScene!.size)
        handL       = SKSpriteNode(texture: SKTexture(imageNamed: "HandLeft"), size: handLScene!.size)
        
        legs.anchorPoint    = legsScene!.anchorPoint
        legs.position       = legsScene!.position
        head.anchorPoint    = headScene!.anchorPoint
        head.position       = headScene!.position
        body.anchorPoint    = bodyScene!.anchorPoint
        body.position       = bodyScene!.position
        handR.position      = handRScene!.position
        handR.anchorPoint   = handRScene!.anchorPoint
        handL.position      = handLScene!.position
        handL.anchorPoint   = handLScene!.anchorPoint
        
        super.init(texture: nil, color: UIColor.clear, size: playerHitbox!.size)
        
        name        = "player"
        position    = pos
        zPosition   = 0
        
        setPhysicBody()
        setChildrens()
        setLightnigMasks()
    }
    
    private func setChildrens() {
        addChild(legs)
        gun.spriteNode.addChild(aimCross)
        legs.addChild(body)
        body.addChild(head)
        body.addChild(handL)
        body.addChild(handR)
        handL.addChild(gun.spriteNode)
        handR.zPosition = -1
        aimingCross.zPosition = 5
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
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity  = true
        physicsBody?.restitution        = 0
        physicsBody?.friction           = 1
        physicsBody?.mass               = 0.1
        physicsBody?.allowsRotation     = false
        physicsBody?.categoryBitMask    = ObjectType.Player.rawValue
        physicsBody?.contactTestBitMask = ObjectType.Ladder.rawValue | ObjectType.Aid.rawValue
        physicsBody?.collisionBitMask   = ObjectType.Wall.rawValue | ObjectType.Floor.rawValue | ObjectType.InvisibleBound.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    public var gunPosition: CGPoint {
        return position + gun.spriteNode.position
    }
    
    public var aimingCross:SKNode {
        return aimCross
    }
    
    public func receive(moveInclination:CGVector) {
       
        if !contacts.isEmpty {
            
            // Reset params
            physicsBody?.velocity = CGVector.zero
            
            if let invisible = contacts[ObjectType.InvisibleBound.rawValue | ObjectType.Player.rawValue] {
                if (invisible.contactPoint.x < position.x && moveInclination.dx < 0) ||
                    invisible.contactPoint.x > position.x && moveInclination.dx > 0 {
                    acceleration.dx = 0
                }
            }
            
            if let floor = contacts[ObjectType.Floor.rawValue | ObjectType.Player.rawValue] {
                let dir:CGFloat = moveInclination.dx > 0 ? 1 : -1
                if moveInclination.dx != 0 {
                    // Poruszanie się <- P ->
                    if abs(moveInclination.dx) > 0.4 && abs(moveInclination.dx) < 0.8 {
                        acceleration.dx = walkSpeed * floor.contactNormal.dy * -1.0 * dir
                        acceleration.dy = walkSpeed * floor.contactNormal.dx
                    } else if abs(moveInclination.dx) >= 0.8 {
                        acceleration.dx = runSpeed * floor.contactNormal.dy * -1.0 * dir
                        acceleration.dy = runSpeed * floor.contactNormal.dx
                    } else {
                        acceleration.dx = 0
                        acceleration.dy = 0
                    }
                    
                } else {
                    acceleration.dx = 0
                }
                
                if moveInclination.dy < 0.5 && !canJump {
                    canJump = true
                    acceleration.dy = 0
                } else if moveInclination.dy >= 0.5 && canJump && contacts[ObjectType.Ladder.rawValue | ObjectType.Player.rawValue] == nil {
                    canJump = false
                    acceleration.dy = jumpForce
                    contacts.removeValue(forKey: ObjectType.Floor.rawValue | ObjectType.Player.rawValue)
                }
            }
            
            if let ladderContact = contacts[ObjectType.Ladder.rawValue | ObjectType.Player.rawValue] {
                if physicsBody?.affectedByGravity == true {
                    physicsBody?.affectedByGravity = false
                }

                let ladderNode = ladderContact.bodyA.categoryBitMask == ObjectType.Ladder.rawValue ? ladderContact.bodyA.node : ladderContact.bodyB.node
                if abs(moveInclination.dy) > 0.5 {
                    acceleration.dy = walkSpeed * (moveInclination.dy)
                    if position.x != ladderNode?.position.x {
                        run(SKAction.move(to: CGPoint(x: ladderNode!.position.x, y: position.y), duration: 0.2))
                    }
                } else {
                    acceleration.dy = 0
                }
            } else if contacts[ObjectType.Ladder.rawValue | ObjectType.Player.rawValue] == nil && physicsBody?.affectedByGravity == false {
                physicsBody?.affectedByGravity = true
                
            }
        } else {
            physicsBody?.affectedByGravity = true
            if moveInclination.dx == 0 {
                acceleration.dx = 0
            } else {
                let dir:CGFloat = moveInclination.dx > 0 ? 1 : -1
                if abs(moveInclination.dx) > 0.4 && abs(moveInclination.dx) < 0.8 {
                    acceleration.dx = walkSpeed * dir
                } else if abs(moveInclination.dx) >= 0.8 {
                    acceleration.dx = runSpeed * dir
                }
            }
        }
        
    }
    
    public func receive(aimInclination:CGVector) {
        
        aimIncl = aimInclination
        
        // Sprawdzamy czy nie obrocic delikwenta
        if aimInclination.dx < 0 && xScale > 0 {
            xScale = -1
        } else if aimInclination.dx > 0 && xScale < 0 {
            xScale = 1
        }
        
        // Sciemnianie kzyzyka do celowania
        if aimDistance < 120 {
            let normalized = (aimDistance - 45)/75.0
            aimCross.alpha = CGFloat(normalized)
        } else {
            aimCross.alpha = 1.0
        }
        
        
        // Matematyczna magia
        let maxBodyAngle:CGFloat    = GeometricHelper().toRadians(degree: 30)   // maksymalny kat ciala
        let maxArmHeadAngle:CGFloat = GeometricHelper().toRadians(degree: 60)   // maksymalny kat glowy i ramienia 60
        let radAngle                = atan2((aimIncl.dy), (aimIncl.dx))         // kąt w radianach
        let boundary                = CGFloat.pi / 2                            // 90 stopni, granicya calkowitego wychylu gora/dol
        
        guns[currentGunIndex].angle = radAngle
        
        // magia kątowa
        let percent:CGFloat
        if abs(radAngle) < boundary {
            // twarza w prawo
            percent = radAngle/boundary
        } else {
            if radAngle > 0 {
                // twarz w lewo do gory
                percent = (CGFloat.pi - radAngle) / boundary
            } else {
                // twarz w lewo do dolu
                percent = (-1 * CGFloat.pi - radAngle) / boundary
            }
        }
        
        let bodyAngle       = maxBodyAngle * percent
        let armHeadAngle    = maxArmHeadAngle * percent
        let distance        = CGFloat(sqrtf(Float(pow(aimInclination.dx, 2.0)+pow(aimInclination.dy, 2.0))))
        
        body.run(SKAction.rotate(toAngle: bodyAngle, duration: 1.0/60.0))
        handL.run(SKAction.rotate(toAngle: armHeadAngle, duration: 1.0/60.0))
        head.run(SKAction.rotate(toAngle: armHeadAngle, duration: 1.0/60.0))
        aimCross.run(SKAction.rotate(toAngle: GeometricHelper().toRadians(degree: -90) * percent, duration: 1.0/60.0))  // utrzymywanie poziomu krzyzyka
        aimCross.run(SKAction.move(to: CGPoint(x: distance * maxAimDistance, y: 0), duration: 1.0/60.0))
        
    }
    
    public func getAimPad(force:CGFloat) {
        if force > 2 && !actions.contains(.ShootFirst) {
            actions.append(.ShootFirst)
        } else if force < 2 && actions.contains(.ShootFirst) {
            actions = actions.filter({ $0 != .ShootFirst })
        }
    }
    
    override func animate() {
        if actions.contains(.ShootFirst) && !gun.isShooting {
            gun.shoot()
            if let mapScence = (self.parent as? GameMap) {
                let pos = gun.spriteNode.convert(gun.position, to: mapScence)
                mapScence.playerShoot(pos, angle: gun.angle)
            }
        } else if !actions.contains(.ShootFirst) && gun.isShooting {
            gun.stopShoot()
        }
    }
    
    public func getMovePad(force:CGFloat) {
    
    }
    
    public var aimDistance:Float {
        return sqrtf(Float(pow(CGFloat(aimIncl.dx * maxAimDistance), 2) + pow(CGFloat(aimIncl.dy * maxAimDistance), 2)))
    }
    
    public var maxAimingDistance:Float{
        return Float(maxAimDistance)
    }
    
    override public func update() {
        if acceleration != CGVector.zero {
            run(SKAction.move(by: acceleration, duration: 1.0/60.0))
        }
        animate()
    }
    
}
