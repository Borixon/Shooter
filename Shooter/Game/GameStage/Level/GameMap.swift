//
//  GameMap.swift
//  Game
//
//  Created by Michał.Krupa on 08/02/2019.
//  Copyright © 2019 Michał.Krupa. All rights reserved.
//

import SpriteKit
import GameKit
import AVKit

class GameMap: SKNode {

    var player: AVAudioPlayer? = nil
    var bg0:SKNode = SKNode()
    var bg1:SKNode = SKNode()
    var bg2:SKNode = SKNode()
    var bg3:SKNode = SKNode()
    var emmiter:SKReferenceNode = SKReferenceNode()
    var startPoint = SKNode()
    let mapReference: SKReferenceNode
    var enemies: [Enemy] = []
    
    override init() {
 
        mapReference =  SKReferenceNode(url: NSURL(fileURLWithPath: Bundle.main.path(forResource: "GameMap", ofType: "sks")!) as URL)
        
        super.init()
        
        if let stringPath = Bundle.main.path(forResource: "Rain2", ofType: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: stringPath))
                player?.numberOfLoops = -1
                player?.play()
            } catch {
                print("Error \(error)")
            }
        }
        
        if let bg = mapReference.children.first?.childNode(withName: "BG0") {
            bg0 = bg
        }
        if let bg = mapReference.children.first?.childNode(withName: "BG1") {
            bg1 = bg
        }
        if let bg = mapReference.children.first?.childNode(withName: "BG2") {
            bg2 = bg
        }
        if let bg = mapReference.children.first?.childNode(withName: "BG3") {
            bg3 = bg
        }
        if let emt = mapReference.children.first?.childNode(withName: "RainRef") as? SKReferenceNode {
            emmiter = emt
        } 
        if let start = mapReference.children.first?.childNode(withName: "StartPoint") {
            startPoint = start
        }
        
        initEnemies()
        
        emmiter.isPaused = false
        addChild(mapReference)
        
        
    }
    
    
    public func updateEnemies() {

    }
    
    public func getStartPoint() -> CGPoint {
        return startPoint.position
    }
    
    private func initEnemies() {
        for node in (mapReference.children.first?.children)! {
            if node.name == "EnemyStart" {
                let enemy = Enemy(inPosition: node.position)
                enemies.append(enemy)
                addChild(enemies.last!)
            }
        }
    }
    
    public func setOffset(byPlayerPosition pos:CGPoint, aiming:CGVector, aimDistance:CGFloat) {
        
        
        bg0.position.x = pos.x
        bg0.position.y = pos.y + (aimDistance * aiming.dy * 0.5)
        
        bg1.position.x = pos.x * 0.97// + aimDistance * aiming.dx * 0.07
        bg1.position.y = pos.y * 0.97 + aimDistance * aiming.dy * 0.45
        
        bg2.position.x = pos.x * 0.92// + aimDistance * aiming.dx * 0.15
        bg2.position.y = pos.y * 0.92 + aimDistance * aiming.dy * 0.28
        
        bg3.position.x = pos.x * 0.77// + aimDistance * aiming.dx * 0.25
        bg3.position.y = pos.y * 0.77 + aimDistance * aiming.dy * 0.2
        
        
        emmiter.position.x = pos.x
        emmiter.position.y = pos.y + 1000
    }
    
    public func playerShoot(_ gunPosition:CGPoint, angle:CGFloat) {
        addChild(Shell(angle: angle, position: gunPosition))
        addChild(Bullet(angle: angle, position: gunPosition))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension GameMap: GunDelegate {
    func shoot(fromPosition position: CGPoint, angle: CGFloat, shell: SKTexture, bullet: SKTexture) {
        
    }
}

extension GameMap: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
       
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}
