//
//  GameManager.swift
//  GameCube
//
//  Created by Michał.Krupa on 19.02.2018.
//  Copyright © 2018 Michał.Krupa. All rights reserved.
//

import UIKit 
import SpriteKit

protocol GameManagerDelegate {
    
}

class GameManager: NSObject {
    
    static let shared = GameManager(size: UIScreen.main.bounds.size, stageName: "Menu")
    
    private var stage:StageProtocol
    private var screenSize:CGSize
    
    var delegate:GameManagerDelegate? = nil
    
    init(size:CGSize, stageName:String) {
        screenSize = size
        stage = Level(size: size)
    }
    
    var scene: SKScene {
        get {
            return self.stage.gameScene
        }
    }
}

enum GameLevels:Int {
    
    case Menu = 0
    
}
