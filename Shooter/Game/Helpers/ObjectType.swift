//
//  ObjectType.swift
//  Game
//
//  Created by Michał.Krupa on 07/03/2019.
//  Copyright © 2019 Michał.Krupa. All rights reserved.
//

import Foundation

enum ObjectType: UInt32 {
    
    case Player         = 1
    case Floor          = 2
    case Wall           = 4
    case Ladder         = 8
    case PlayerBullet   = 16
    case Shell          = 32
    case Area           = 128
    case Aid            = 256
    case InvisibleBound = 512
    
    case Enemy          = 64
    case EnemyHead      = 1024
    case EnemyBody      = 2048
    case EnemyLegs      = 4096
}


