//
//  ScreenPad.swift
//  GameCube
//
//  Created by Michał.Krupa on 08.03.2018.
//  Copyright © 2018 Michał.Krupa. All rights reserved.
//

import UIKit
import SpriteKit
import CoreGraphics

protocol ScreenPadDelegate {
    func right(padInclination:CGVector)
    func hold(bool:Bool)
}

class ScreenPad: SKCameraNode {
    
    public var padDelegate:ScreenPadDelegate?
    
    private let gestureRecog = UIGestureRecognizer()
    private let screenSize:CGSize
    private let rightPad:Joypad
    private let leftPad:Joypad
    
    init(size:CGSize) {
        
        let padRadius:CGFloat   = 130
        let rightPos            = CGPoint(x: size.width/2.0 - padRadius*0.75, y: -1*size.height/2.0 + padRadius*0.75)
        let leftPos             = CGPoint(x: -1 * size.width/2.0 + padRadius*0.75, y: -1*size.height/2.0 + padRadius*0.75)
        
        screenSize  = size
        rightPad    = Joypad(atPosition: rightPos, withRadius: padRadius)
        leftPad     = Joypad(atPosition: leftPos, withRadius: padRadius, reflex:false)
        
        super.init()
        
        isUserInteractionEnabled = true
        zPosition = 100
        xScale = 2
        yScale = 2
        
        addChild(rightPad)
        addChild(leftPad)
        
    }
  
    
    public var moveInclination:CGVector {
        /*
         Jako że nasz pad jest kołem w przestrzeni kartezjanskiej
         maksymalne wychylenie x wynosi 1 w poziomie i 1 w pionie.
         Moze jednak dojść do momentu że chcemy sie wychylic 'pod skosem'
         wtedy wychylenie moze wynies ~ 0.71x i 0.71y
         Musimy to znormalizować do 1x i 1y max przy 45', aby wychylenia w kole
         miały wartosci z kwadratu wpisanego w niego i nie przekraczaly 1.
         Jest to napisane ze względu na to aby player biegnac i wykonujac skok
         nie 'zwolnil' gdyz dx spadnie wtedy ~ 15-20 %
          
         R - promień koła
         C - cięciwa - 2*r
         A - bok kwadratu
         a - polowa boku kwadratu cyzli maksymalne wychylenie
         
         R          = A * sqrt(2) / 2
         A          = R * 2 / sqrt(2)
         a          = A / 2
         incl.x     = [-1 , 1]
         incl.y     = [-1 , 1]
        */
        
        return (rightPad.inclination/(1/sqrtf(2.0))).clamp(val: 1.0)
    }
    
    public var moveTouchForce:CGFloat {
        return rightPad.force
    }
    
    public var aimInclination:CGVector{
        return leftPad.inclination
    }
    
    public var aimTouchForce:CGFloat {
        return leftPad.force
    }
    
    public func setViewport(by center:CGPoint, maxAimDistance:CGFloat) {
        self.run(SKAction.move(to:  CGPoint(x: (center.x + aimInclination.dx * maxAimDistance * 0.5),
                                            y: (center.y + aimInclination.dy * maxAimDistance * 0.5)), duration: 1/60))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ScreenPad: UIGestureRecognizerDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let point = touch.location(in: self)
            if point.x > 0 && rightPad.didGrab(atPosition: point){
                rightPad.set(to: point)
                rightPad.set(force: touch.force)
            } else if point.x < 0 && leftPad.didGrab(atPosition: point) {
                leftPad.set(to: point)
                leftPad.set(force: touch.force)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let point = touch.location(in: self)
            if point.x > 0 && rightPad.isHold {
                rightPad.calculate(grabPoint: point)
                rightPad.set(force: touch.force)
            } else if point.x < 0 && leftPad.isHold {
                leftPad.calculate(grabPoint: point)
                leftPad.set(force: touch.force)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPoint = touch.location(in: self)
            if touchPoint.x > 0 {
                rightPad.letGo()
                leftPad.set(force: 0)
            } else if touchPoint.x < 0  {
                leftPad.letGo()
                leftPad.set(force: 0)
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // TODO ?
    }
    
}
