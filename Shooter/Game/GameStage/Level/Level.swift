//
//  NewLevel.swift
//  GameCube
//
//  Created by Michał.Krupa on 12.09.2018.
//  Copyright © 2018 Michał.Krupa. All rights reserved.
//

import SpriteKit

class Level: SKScene, StageProtocol {
    
    var lastUpdate: TimeInterval
    var hudScene: ScreenPad
    var map:GameMap
    var player:Player
    var vect:CGVector = CGVector(dx: 1, dy: 1)
    
    func commitAnimations() {
        
    }
    
    func updateState(atTime time: TimeInterval) {
        
    }
    
    public func set(){
        
    }

    override init(size:CGSize) {
        
        lastUpdate  = 0
        hudScene    = ScreenPad(size: size)
        map         = GameMap()
        player      = Player(inPosition: map.getStartPoint())
        
        super.init(size: size)
        
        scene?.isPaused     = false
        scene?.delegate     = self
        scene?.name         = "GameScene"
        camera              = hudScene
        
        map.addChild(player)
        scene?.addChild(map)
        scene?.addChild(camera!)
        scene?.physicsWorld.contactDelegate = self
    }
    
    var gameScene: SKScene {
        return scene!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension Level: SKSceneDelegate {
    
    func update(_ currentTime: TimeInterval, for scene: SKScene) {
        
        map.setOffset(byPlayerPosition: player.position, aiming:hudScene.aimInclination, aimDistance: CGFloat(player.maxAimingDistance))
        
        
        let time = 1.0/60.0
        guard lastUpdate + time < currentTime else { return }
        
        lastUpdate = currentTime
        
        player.receive(moveInclination: hudScene.moveInclination)
        player.receive(aimInclination: hudScene.aimInclination)
        player.getAimPad(force: hudScene.aimTouchForce)
        player.getMovePad(force: hudScene.moveTouchForce)
        player.update()
        map.updateEnemies()
        
        hudScene.setViewport(by: player.gunPosition, maxAimDistance: CGFloat(player.maxAimingDistance))
            
    }

}


extension Level: SKPhysicsContactDelegate {
    func didEnd(_ contact: SKPhysicsContact) {
//        print("end currentContact \(contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask)")
        let playerGroupBool = contact.bodyA.categoryBitMask == ObjectType.Player.rawValue || contact.bodyB.categoryBitMask == ObjectType.Player.rawValue
        let playerContact = playerGroupBool ? contact : nil
        if let _ = playerContact {
            player.remove(contact: playerContact!)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let currentContact = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
//        print("start currentContact \(currentContact)")
        let playerGroupBool = contact.bodyA.categoryBitMask == ObjectType.Player.rawValue || contact.bodyB.categoryBitMask == ObjectType.Player.rawValue
        let playerContact = playerGroupBool ? contact : nil
 
        if let contactOfPlayer = playerContact {
            player.set(contact: contactOfPlayer)
        }
        
        
        let bulletWallContact = ObjectType.Wall.rawValue | ObjectType.PlayerBullet.rawValue
        let bulletFloorContact = ObjectType.Floor.rawValue | ObjectType.PlayerBullet.rawValue
        
        if currentContact == bulletWallContact || currentContact == bulletFloorContact {
            let bullet = (contact.bodyA.categoryBitMask == ObjectType.PlayerBullet.rawValue) ? contact.bodyA.node : contact.bodyB.node
            map.removeChildren(in: [bullet!])
            return
        }
        
        
        if ObjectType.Enemy.rawValue | ObjectType.PlayerBullet.rawValue == currentContact {
            print("\(Date()) ENEMY SHOT!")
            let bullet = (contact.bodyA.categoryBitMask == ObjectType.PlayerBullet.rawValue) ? contact.bodyA.node : contact.bodyB.node
            
            
            
            if let enemy = ((contact.bodyA.categoryBitMask == ObjectType.Enemy.rawValue) ? contact.bodyA.node : contact.bodyB.node) as? Enemy {
               
                let point = map.convert((bullet?.position)!, to: enemy)
                print("bullet contact.contactPoint \(point)")
                enemy.addBulletHole(atPosition: point)
                map.removeChildren(in: [bullet!])
            }
            
            
            
        }
        
    }
}
