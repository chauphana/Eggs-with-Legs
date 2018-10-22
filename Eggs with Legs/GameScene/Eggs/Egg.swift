//
//  Egg.swift
//  Eggs with Legs
//
//  Created by 90309776 on 10/7/18.
//  Copyright © 2018 Egg Beater. All rights reserved.
//

import SpriteKit
import Foundation

/*
 The main parent class for all subclasses for Egg
 Contains all atributes that all eggs must have and functions that
 all eggs will be able to use.
 
 Most eggs created will be created through a subclass of this Egg class
 
 */

class Egg {
    
    var sprite:     SKSpriteNode
    
    var baseSpeed:  Double = GameData.eggData.basicEgg.baseSpeed
    var speed:      Double
    
    var baseHealth: Double = GameData.eggData.basicEgg.baseHealth
    var health:     Double
    var maxhealth:  Double
    
    var baseDamage: Int = GameData.eggData.basicEgg.baseDamage
    var damage:     Int
    
    var hasContactProjectile: Bool
    var animateType:    Int
    
    //ANIMATIION VARIABLES
    var animationState:       String
    var animateAction:        SKAction!
    var runAnimateAction:     SKAction!
    var deathAnimateAction:   SKAction!
    var crackedAnimateAction: SKAction!
    var kickingAnimateAction: SKAction!
    var crackedKickingAnimateAction: SKAction!
    
    
    var eggRunningTextures: [SKTexture]!
    var eggDeathTextures:   [SKTexture]!
    var eggCrackedTextures: [SKTexture]!
    var eggKickingTextures: [SKTexture]!
    var eggCrackedKickingTextures: [SKTexture]!
    
    var gameScene = GameScene()
    //var scene: GameScene
    
//
    
    init(sprite: SKSpriteNode) {
        self.sprite = sprite
        self.speed = self.baseSpeed * GameData.eggData.speedMultiplier
        self.health = self.baseHealth * GameData.eggData.healthMultiplier
        self.maxhealth = self.health
        self.damage = self.baseDamage * GameData.eggData.damageMultiplier
        self.animateType = 0
        self.hasContactProjectile = false
        //self.scene = scene
        //self.animationCount = 0
        
        //gameScene.addChild(self.sprite)
        self.animationState = "running"
        
        /*
         Gives every Egg type physics properties
        */
        self.sprite.physicsBody = SKPhysicsBody(texture: self.sprite.texture!, size: CGSize(width: self.sprite.size.width, height: self.sprite.size.height))
        self.sprite.physicsBody?.isDynamic          = true // 2
        self.sprite.physicsBody?.affectedByGravity  = false
        self.sprite.physicsBody?.allowsRotation = false
        self.sprite.physicsBody?.categoryBitMask    = GameScene.PhysicsCategory.egg // 3
        self.sprite.physicsBody?.contactTestBitMask = GameScene.PhysicsCategory.fence
                                                    //| GameScene.PhysicsCategory.projectile
        self.sprite.physicsBody?.collisionBitMask   = GameScene.PhysicsCategory.fence
                                                    | GameScene.PhysicsCategory.egg // 5
                                                    //| GameScene.PhysicsCategory.projectile
    }
    
    func move() {
        self.sprite.position.x += CGFloat(self.speed)
    }
    
    //animate and deathAnamation should be overriden by their subclasses when called
    //These are place holder functions so Swift stays happy
    func runAnimate() {
        //print("i dont have anyhting to animate")
        self.sprite.removeAllActions()
        self.animateAction = SKAction.repeatForever(self.runAnimateAction)
        self.sprite.run(self.animateAction, withKey: "run")
        self.animationState = "running"
    }
    
    func checkCrackedRunAnimate() {
        if self.health < self.maxhealth  - 1 && self.animationState != "cracked_running" {
            self.sprite.removeAllActions()
            self.animateAction = SKAction.repeatForever(self.crackedAnimateAction)
            self.sprite.run(self.animateAction, withKey: "cracked_run")
            self.animationState = "cracked_running"
        }
    }
    
    func checkDeathAnimate(index: Int) {
        if self.health <= 0.0 && self.animationState != "death" {
            //gameScene.eggCount += 1
            self.sprite.removeAllActions()
            self.animateAction = SKAction.repeat(self.deathAnimateAction, count: 1)
            self.sprite.run(SKAction.sequence([self.animateAction, SKAction.removeFromParent()]), withKey: "death")
            self.animationState = "death"
            if gameScene.eggArray.count > 0 {
                gameScene.eggArray.remove(at: index)
            }
        }
    }
    
    func kickAnimate(fenceSprite: Fence) {
        
        func decreaseFenceHealth() {
            fenceSprite.health -= self.damage
        }
        
        if self.animationState == "running" {
            self.sprite.removeAllActions()
            //self.animateAction = SKAction.repeatForever(self.kickingAnimateAction)
            self.animateAction = SKAction.repeatForever(SKAction.sequence([self.kickingAnimateAction, SKAction.run(decreaseFenceHealth), SKAction.wait(forDuration: 3)]))
            self.sprite.run(self.animateAction)
            self.animationState = "kicking"
            self.sprite.name = "basicegg"
        } else {
            self.sprite.removeAllActions()
            self.animateAction = SKAction.repeatForever(self.crackedKickingAnimateAction)
            self.sprite.run(self.animateAction)
            self.animationState = "cracked_kicking"
            self.sprite.name = "basicegg now"
        }
        
        
        
    }
    
    func crackedKickAnimate() {
        
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
}
