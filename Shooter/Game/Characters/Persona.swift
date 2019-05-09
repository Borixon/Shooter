//
//  Persona.swift
//  Balls of Steel
//
//  Created by Michał.Krupa on 14/03/2019.
//  Copyright © 2019 Michał.Krupa. All rights reserved.
//

import SpriteKit

class Persona: SKSpriteNode {
    
    internal let jumpForce: CGFloat          = 9.5
    internal let walkSpeed: CGFloat          = 3.0
    internal let runSpeed: CGFloat           = 6.5
    internal var aimIncl:CGVector            = CGVector(dx: 0, dy: 0)
    internal var moveIncl:CGVector           = CGVector(dx: 0, dy: 0)
    internal var acceleration:CGVector       = CGVector(dx: 0, dy: 0)
    internal var canJump:Bool                = true
    internal var contacts                    = Dictionary<UInt32, SKPhysicsContact>()
    internal var actions:[PersonaActions]    = [.Fall]
    internal var guns:[GunProtocol]          = [GunMK4()]
    internal var currentGunIndex:Int         = 0
    
    public func set(contact: SKPhysicsContact) { contacts[contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask] = contact }
    
    public func remove(contact: SKPhysicsContact) { contacts.removeValue(forKey: contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) }
    
    public func update() { }
    
    internal func animate() { }
    
    internal func setPhysicBody() { }
    
    internal func setLightnigMasks() {}
}

public enum PersonaActions:Int{
    case Fall
    case Stand
    case Jump
    case Walk
    case WalkLeft
    case WalkRight
    case Crouch
    case SlideLeft
    case SlideRight
    case JumpLeft
    case JumpRight
    case ShootFirst
    case ShootSecondary
}
