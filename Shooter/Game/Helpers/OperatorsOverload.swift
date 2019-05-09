//
//  OperatorsOverliad.swift
//  GameCube
//
//  Created by Michał.Krupa on 13.03.2018.
//  Copyright © 2018 Michał.Krupa. All rights reserved.
//

import SceneKit

// AŻ dziw że nie ma tego zrobionego w SceneKit ale moze nie znalazlem
extension SCNVector3: Equatable {
    
    public static func ==(left: SCNVector3, right: SCNVector3) -> Bool {
        if left.x == right.x && left.y == right.y && left.z == right.z {
            return true
        }
        return false
    }
    
    public static func !=(left: SCNVector3, right: SCNVector3) -> Bool {
        if left.x == right.x && left.y == right.y && left.z == right.z {
            return false
        }
        return true
    }
    
    public static func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(left.x+right.x, left.y+right.y, left.z+right.z)
    }
}



extension CGVector: Equatable {
    public static func *(left: CGVector, right: Int) -> CGVector {
        if right == 0 {
            return CGVector.zero
        } else {
            return CGVector(dx: left.dx * CGFloat(right), dy: left.dy * CGFloat(right))
        }
    }
    
    public static func /(left: CGVector, right: Float) -> CGVector {
        if right == 0 {
            return CGVector.zero
        } else {
            return CGVector(dx: left.dx / CGFloat(right), dy: left.dy / CGFloat(right))
        }
    }
    
    public func clamp(val:CGFloat) -> CGVector {
        if val != 0 {
            var vec:CGVector = self
            if abs(self.dx) > val {
                let face:CGFloat = self.dx > 0 ? 1 : -1
                vec.dx = face * val
            }
            if abs(self.dy) > val {
                let face:CGFloat = self.dy > 0 ? 1 : -1
                vec.dy = face * val
            }
            return vec
        } else {
            return CGVector.zero
        }
    }
    
    public static func +(left: CGVector, right: CGVector) -> CGVector {
        return CGVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
    }
    
    public static func *(left: CGVector, right: CGFloat) -> CGVector {
        return CGVector(dx: left.dx * right, dy: left.dy * right)
    }
}

extension CGPoint: Equatable {
    public static func +(left:CGPoint, right:CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    public static func -(left:CGPoint, right:CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    public static func *(left:CGPoint, right:CGFloat) -> CGPoint {
        return CGPoint(x: left.x * right, y: left.y * right)
    }
}

class GeometricHelper {
    public func toRadians(degree:CGFloat) -> CGFloat {
        return degree * CGFloat.pi / 180
    }
    
}
