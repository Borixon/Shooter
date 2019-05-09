//
//  GameState.swift
//  GameCube
//
//  Created by Michał.Krupa on 19.02.2018.
//  Copyright © 2018 Michał.Krupa. All rights reserved.
//

import UIKit
import SpriteKit

enum StageState:Int {
    
    case start
    case play
    case pause
    case end    
    case menu
    
}
 
protocol StageProtocol {
    
    var hudScene:ScreenPad { get set }
    var gameScene:SKScene { get } 
//    
    func updateState(atTime time:TimeInterval) 
    
}




