//
//  Joypad.swift
//  Game
//
//  Created by Michał.Krupa on 21/02/2019.
//  Copyright © 2019 Michał.Krupa. All rights reserved.
//

import SpriteKit

class Joypad: SKNode {
    
    private let joystick            = SKSpriteNode(imageNamed: "joystick")
    private let joypad              = SKSpriteNode(imageNamed: "joyBack")
    public var percInclination      = CGVector(dx: 0, dy: 0)
    private var hold:Bool 	        = false
    private let dimeAlpha:CGFloat 	= 0.3
    private let fullAlpha:CGFloat 	= 0.65
    public var isReflexive          = false
    public var force:CGFloat        = 0
    
    private var newCenter:CGPoint
    private let joysticRadius:CGFloat
    private let joysticSize:CGSize
    private let joypadSize:CGSize
    private let center:CGPoint
    private let maxIncPoint:CGFloat
    
    
    init(atPosition position:CGPoint, withRadius rad:CGFloat, reflex:Bool = true) {
        
        center              = position
        newCenter           = position
        joysticRadius       = rad
        joypadSize          = CGSize(width: joysticRadius, height: joysticRadius)
        joysticSize         = CGSize(width: joysticRadius * 0.3, height: joysticRadius * 0.3)
        maxIncPoint         = (joypadSize.width/2.0 - joysticSize.width/4.0)
        joystick.size       = joysticSize
        joypad.size         = joypadSize
        joystick.position   = center
        joypad.position     = center
        isReflexive         = reflex
        
        super.init()
        
        alpha = dimeAlpha
        
        addChild(joypad)
        addChild(joystick)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var inclination: CGVector {
        let i = CGVector(dx: Double(joystick.position.x - newCenter.x), dy: Double(joystick.position.y - newCenter.y))
        let p = CGVector(dx: i.dx/maxIncPoint, dy: i.dy/maxIncPoint)
        return p
    }
    
    public var isHold:Bool {
        return hold
    }
    
    func calculate(grabPoint:CGPoint) {
        
        let xPositive   = grabPoint.x > newCenter.x ? true : false
        let yPositive   = grabPoint.y > newCenter.y ? true : false
        let x           = abs(newCenter.x - grabPoint.x)
        let y           = abs(newCenter.y - grabPoint.y)
        let c           = sqrt(pow(x, 2.0) + pow(y, 2.0))

        if c <= maxIncPoint {
            joystick.position = grabPoint
        } else {
            let prop = maxIncPoint/c
            let newX = newCenter.x + (x * (xPositive ? 1 : -1)) * prop
            let newY = newCenter.y + (y * (yPositive ? 1 : -1)) * prop
            joystick.position = CGPoint(x: newX, y: newY)
        }
    }
    
    public func letGo() {
        alpha = dimeAlpha
        hold  = false
        
        if isReflexive {
            newCenter           = center
            joystick.position   = center
            joypad.position     = center
        } else {
            let offset          = joypad.position - joystick.position
            newCenter           = center
            joypad.position     = center
            joystick.position   = center - offset
        }
    }
    
    // Funkcja odpala się po złapaniu za joystick
    public func set(to newPosition:CGPoint) {
        alpha = fullAlpha
        if isReflexive {
            newCenter           = newPosition
            joystick.position   = newPosition
            joypad.position     = newPosition
        } else {
            let joyPos          = joystick.position
            let offset          = joyPos - newPosition
            newCenter           = center - offset
            joystick.position   = newPosition
            joypad.position     = center - offset
        }
    }
    
    public func set(force:CGFloat) {
        self.force = force
    }
    
    public func didGrab(atPosition pos:CGPoint) -> Bool {
        if  (pos.x < joystick.position.x + joysticSize.width/2.0 && pos.x > joystick.position.x - joysticSize.width/2.0) &&
            (pos.y < joystick.position.y + joysticSize.width/2.0 && pos.y > joystick.position.y - joysticSize.width/2.0) {
            hold = true
        } else {
            hold = false
        }
        return isHold
    }
}
