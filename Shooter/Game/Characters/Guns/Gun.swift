//
//  Gun.swift
//  Game
//
//  Created by Michał.Krupa on 08/03/2019.
//  Copyright © 2019 Michał.Krupa. All rights reserved.
//

import SpriteKit

protocol GunDelegate {
    func shoot(fromPosition position: CGPoint, angle:CGFloat, shell:SKTexture, bullet:SKTexture)
}

class GunMK4: GunProtocol {
    
    var aimDistance: CGFloat        = 350
    var spriteNode: SKSpriteNode    = SKSpriteNode(texture: SKTexture(imageNamed: "Gun1"), size: CGSize(width: 134, height: 34))
    var anchorPoint: CGPoint        = CGPoint(x: 0.114, y: 0.498)
    var position: CGPoint           = CGPoint(x: 20.6, y: -3.5)
    var name: String                = "MK4"
    var maxAmmo: Int                = 50
    var statusAmmo: Int             = 50
    var shellTexture: SKTexture     = SKTexture(image: UIImage(named: "ShellM4")!)
    var automatic: Bool             = true
    var isShooting: Bool            = false
    var shotFrames: [SKTexture]     = []
    var angle: CGFloat              = 0
    
    public var delegate:GunDelegate? = nil
    
    var size: CGSize {
        return spriteNode.size
    }
    
    init() {
        let atlas = SKTextureAtlas(named: "GunShotImages")
        for i in 1...atlas.textureNames.count {
            shotFrames.append(atlas.textureNamed("gun\(i)"))
        }
        spriteNode.anchorPoint  = anchorPoint
        spriteNode.position     = position
        spriteNode.zPosition    = 0.01
    }

    
    func shoot() {
        if !isShooting {
            isShooting = true
            let shoot = SKAction.customAction(withDuration: 0, actionBlock: {_,_ in
                self.delegate?.shoot(fromPosition: CGPoint(x: 0, y: 0), angle: self.angle, shell: self.shellTexture, bullet: self.shellTexture)
            })
            let finish = SKAction.customAction(withDuration: 0, actionBlock: {_,_ in
                self.isShooting = false
            })
            let animate = SKAction.animate(with: shotFrames, timePerFrame: 0.05, resize: false, restore: true)
            let sequence = SKAction.sequence([shoot, animate, finish])
            
            spriteNode.run(sequence, withKey: GunActionKeys.Shell.rawValue) 
        }
    }
    
    func stopShoot() {
        if isShooting {
            isShooting = false
            spriteNode.removeAction(forKey: GunActionKeys.Shoot.rawValue)
            spriteNode.removeAction(forKey: GunActionKeys.Shell.rawValue)
        }
    }
    
    func reload() {
        
    }
    
}

enum GunActionKeys: String {
    case Shoot = "ShotGun"
    case Shell = "ShotGunShells"
}

protocol GunProtocol {
    
    var aimDistance: CGFloat { get set  }
    var spriteNode:SKSpriteNode { get }
    var anchorPoint:CGPoint { get }
    var position:CGPoint { get }
    var size:CGSize { get }
    var name:String { get }
    var maxAmmo:Int { get }
    var statusAmmo: Int { get set }
    var shotFrames: [SKTexture] { get }
    var shellTexture:SKTexture { get }
    var automatic:Bool { get }
    var isShooting:Bool { get set }
    var angle:CGFloat { get set }
    var delegate:GunDelegate? { get set }
    
    func shoot()
    func stopShoot()
    func reload()
    
}

enum GunActions: Int {
    case ShootOne
    case ShootMultiple
    case ShootAlternative
    case Reload
}
