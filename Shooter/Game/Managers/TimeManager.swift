//
//  TimeManager.swift
//  GameCube
//
//  Created by Michał.Krupa on 07.03.2018.
//  Copyright © 2018 Michał.Krupa. All rights reserved.
//

import UIKit

class TimeMachine: NSObject {
    
    static let shared       	    = TimeMachine()
    public var currTime             = TimeInterval(exactly: 0)
    public let interval             = 1.0 / 60.0
    public var oldTime:TimeInterval = 0
 
    public func set(time:TimeInterval) {
        currTime = time
    }
}
