//
//  GameControllerViewController.swift
//  GameCube
//
//  Created by Michał.Krupa on 19.02.2018.
//  Copyright © 2018 Michał.Krupa. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = view as! SKView
        skView.isUserInteractionEnabled = true
        skView.isMultipleTouchEnabled = true
        skView.presentScene(GameManager.shared.scene)
        
    }
}

