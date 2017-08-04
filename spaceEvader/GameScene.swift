//
//  GameScene.swift
//  spaceEvader
//
//  Created by iD Student on 8/2/17.
//  Copyright © 2017 iD Tech. All rights reserved.
//

import SpriteKit
import GameplayKit

struct BodyType {
    
    static let None: UInt32 = 0
    static let Meteor: UInt32 = 1
    static let Bullet: UInt32 = 2
    static let Hero: UInt32 = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    
    let hero = SKSpriteNode(imageNamed: "Spaceship")
    let heroSpeed: CGFloat = 100.0
    var meteorScore = 0
    
    var scoreLabel = SKLabelNode(fontNamed: "Arial")
    
    
    //creates a random float between 0.0 and 1.0
    
    func random() -> CGFloat {
        
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        
    }
    
    func addMeteor() {
        
        var meteor: Enemy
        
        meteor = Enemy(imageNamed: "MeteorLeft")
        
        
        meteor.size.height = 35
        meteor.size.width = 50
        
        let randomY = random() * ((size.height - meteor.size.height/2)-meteor.size.height/2) + meteor.size.height/2

        
        meteor.position = CGPoint(x: size.width + size.width/2, y: randomY)
        
        meteor.physicsBody = SKPhysicsBody(rectangleOf: meteor.size)
        meteor.physicsBody?.isDynamic = true
        meteor.physicsBody?.categoryBitMask = BodyType.Meteor
        meteor.physicsBody?.contactTestBitMask = BodyType.Bullet | BodyType.Hero
        meteor.physicsBody?.collisionBitMask = 0
        
        addChild(meteor)
        
      
        
        var moveMeteor: SKAction
        
        moveMeteor = SKAction.move(to: CGPoint(x: -meteor.size.width/2, y: randomY), duration: (5.0))
        
        meteor.run(SKAction.sequence([moveMeteor, SKAction.removeFromParent()]))
        
        //repeatedly runs addMeteor function every second.
        
    }

    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.black
        
        let xCoord = size.width * 0.5
        let yCoord = size.height * 0.5
        
        hero.size.height = 50
        hero.size.width = 50
        
        hero.position = CGPoint(x: xCoord, y: yCoord)

        
        hero.physicsBody = SKPhysicsBody(rectangleOf: hero.size)
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.categoryBitMask = BodyType.Hero
        hero.physicsBody?.contactTestBitMask = BodyType.Meteor
        hero.physicsBody?.collisionBitMask = 0
        
        scoreLabel.fontColor = UIColor.white
        
        scoreLabel.fontSize = 40
        
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height-50)
        
        addChild(scoreLabel)
        
        scoreLabel.text = "0"
        
        
        addChild(hero)
        
        
        //Gesture Recognizers
        
        let swipeUp: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addMeteor), SKAction.wait(forDuration: 1)])))
        
        physicsWorld.gravity = CGVector(dx:0,dy:0)
        
        physicsWorld.contactDelegate = self
    }
    
    
    //Gesture Actions
    func swipedUp(sender: UISwipeGestureRecognizer){
        
        var actionMove: SKAction
        
        if (hero.position.y + heroSpeed >= size.height){
            
            actionMove = SKAction.move(to: CGPoint(x: hero.position.x, y: size.height - hero.size.height/2), duration: 0.5)
        }
        else {
            
            actionMove = SKAction.move(to: CGPoint(x: hero.position.x, y: hero.position.y + heroSpeed), duration: 0.5)
        }
        
        hero.run(actionMove)
    }
    
    
    func swipedDown(sender: UISwipeGestureRecognizer){
        
        var actionMove: SKAction
        
        if (hero.position.y - heroSpeed <= 0){
            
            actionMove = SKAction.move(to: CGPoint(x: hero.position.x, y: hero.size.height/2), duration: 0.5)
        }
        else {
            actionMove = SKAction.move(to: CGPoint(x: hero.position.x, y: hero.position.y - heroSpeed), duration: 0.5)
        }
        
        hero.run(actionMove)
    }
    
    
    func swipedLeft(sender: UISwipeGestureRecognizer){
        
        var actionMove: SKAction
        
        if (hero.position.x - heroSpeed <= 0) {
            
            actionMove = SKAction.move(to: CGPoint(x: hero.size.width/2, y: hero.position.y), duration: 0.5)
        }
        else {
            
            actionMove = SKAction.move(to: CGPoint(x: hero.position.x - heroSpeed, y: hero.position.y), duration: 0.5)
        }
        
        hero.run(actionMove)
    }
    
    
    func swipedRight(sender: UISwipeGestureRecognizer){
        
        var actionMove: SKAction
        
        if (hero.position.x + heroSpeed >= size.width) {
            
            actionMove = SKAction.move(to: CGPoint(x: size.width - hero.size.width/2, y: hero.position.y), duration: 0.5)
        }
        else {
            
            actionMove = SKAction.move(to: CGPoint(x: hero.position.x + heroSpeed, y: hero.position.y), duration: 0.5)
        }
        
        hero.run(actionMove)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
      
        let bullet = SKSpriteNode ()
        
        bullet.color = UIColor.purple
        bullet.size = CGSize(width: 8, height: 8)
        bullet.position = CGPoint (x: hero.position.x, y: hero.position.y)
        
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = BodyType.Bullet
        bullet.physicsBody?.contactTestBitMask = BodyType.Meteor
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        
        addChild(bullet)
        
        let vector = CGVector(dx: -(hero.position.x - touchLocation.x), dy: -(hero.position.y - touchLocation.y))
        
        let projectileAction = SKAction.sequence([
            SKAction.repeat(SKAction.move(by: vector, duration: 0.5), count: 10),
            SKAction.wait(forDuration: 0.5),
            SKAction.removeFromParent()
            ])
        
        bullet.run(projectileAction)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let bodyA = contact.bodyA
        
        let bodyB = contact.bodyB
        
        
        
        let contactA = bodyA.categoryBitMask
        
        let contactB = bodyB.categoryBitMask
        
        
        switch contactA {
            
        case BodyType.Meteor:
            
            
            
            switch contactB {
                
                
                
            case BodyType.Meteor:
                
                break
                
                
                
            case BodyType.Bullet:
                
                if let bodyBNode = contact.bodyB.node as? SKSpriteNode, let bodyANode = contact.bodyA.node as? Enemy {
                    
                    bulletHitMeteor(bullet: bodyBNode, meteor: bodyANode)
                    
                }
                
                
                
            case BodyType.Hero:
                
                if let bodyBNode = contact.bodyB.node as? SKSpriteNode, let bodyANode = contact.bodyA.node as? Enemy {
                    
                    heroHitMeteor(player: bodyBNode, meteor: bodyANode)
                    
                }
                
                
                
            default:
                
                break
                
            }
            
            
            
        case BodyType.Bullet:
            
            
            
            switch contactB {
                
                
                
            case BodyType.Meteor:
                
                if let bodyANode = contact.bodyA.node as? SKSpriteNode, let bodyBNode = contact.bodyB.node as? Enemy {
                    
                   bulletHitMeteor(bullet: bodyANode, meteor: bodyBNode)
                    
                }
                
                
                
            case BodyType.Bullet:
                
                break
                
                
                
            case BodyType.Hero:
                
                break
                
                
                
            default:
                
                break
                
            }
            
            
            
        case BodyType.Hero:
            
            
            
            switch contactB {
                
                
                
            case BodyType.Meteor:
                
                if let bodyANode = contact.bodyA.node as? SKSpriteNode, let bodyBNode = contact.bodyB.node as? Enemy {
                    
                    heroHitMeteor(player: bodyANode, meteor: bodyBNode)
                    
                }           
                
                
                
            case BodyType.Bullet:
                
                break     
                
                
                
            case BodyType.Hero:
                
                break       
                
                
                
            default:
                
                break
                
            }
            
            
            
        default:
            
            break
            
        }
    }
    
    
    func bulletHitMeteor(bullet:SKSpriteNode, meteor: Enemy) {
        
        bullet.removeFromParent()
        
        meteor.removeFromParent()
        
        meteorScore+=1
        
        scoreLabel.text = "\(meteorScore)"
    }
    
    func heroHitMeteor (player: SKSpriteNode, meteor: Enemy){
            player.removeFromParent()
            meteor.removeFromParent()
        var gameOver = SKLabelNode (fontNamed: "Arail")
        gameOver.text = "Game Over"
        gameOver.fontSize = 30
        gameOver.position = CGPoint (x: size.width/2, y: size.height/2)
        addChild(gameOver)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func explodeMeteor(meteor: Enemy) {
        
        let explosions: [SKSpriteNode] = [SKSpriteNode(), SKSpriteNode(), SKSpriteNode(), SKSpriteNode(), SKSpriteNode()]
        
        for explosion in explosions {
            
            explosion.color = UIColor.orange
            explosion.size = CGSize(width: 3, height: 3)
            explosion.position = CGPoint(x: meteor.position.x, y: meteor.position.y)
            
            let randomExplosionX = (random() * (1000 + size.width)) - size.width
            
            let randomExplosionY = (random() * (1000 + size.height)) - size.width
            
            let moveExplosion: SKAction
            
            moveExplosion = SKAction.move(to: CGPoint(x: randomExplosionX, y: randomExplosionY), duration: 10.0)
            explosion.run(SKAction.sequence([moveExplosion, SKAction.removeFromParent()]))
            
            let moveExplosion: SKAction
            
            moveExplosion = SKAction.move(to: CGPoint(x: randomExplosionX, y: randomExplosionY), duration: 10.0)
            
            explosion.run(SKAction.sequence([moveExplosion, SKAction.removeFromParent()]))
            
            
            addChild(explosion)
        }
    }
    
}
