//
//  GameScene.swift
//  AvoidTweet
//
//  Created by Keigo Nakagawa on 2019/12/12.
//  Copyright © 2019 Keigo Nakagawa. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var twitter : SKSpriteNode?
    private var background : SKSpriteNode?
    private var spinnyNode : SKShapeNode?
    private var obstacle : SKSpriteNode?
    
    override func didMove(to view: SKView) {
        
        physicsWorld.gravity =  CGVector(dx: 0, dy: -0.5)
        physicsBody?.isDynamic = false
        physicsBody?.allowsRotation = false
//        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        drawBackground()
        drawTwitter()
        drawObstacle()

        let wall = CGRect(x: frame.origin.x,
                          y: frame.origin.y + twitter!.frame.height/2,
                          width: frame.width,
                          height: frame.height)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: wall)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
        
//        let touch:UITouch = touches.anyObject() as! UITouch
//        let positionInScene = touch.location(in: self)
//        let touchedNode = twitter(positionInScene)
//
//        if let name = touchedNode.name
//        {
//            if name == "pineapple"
//            {
//                print("Touched")
//            }
//        }
        
        twitter?.run(SKAction.moveTo(y: twitter!.position.y + 150, duration: 0.5))
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    private func drawBackground() {
        background = SKSpriteNode(imageNamed: "background")
        guard let background = background else { return }
        background.size = size
        background.position = CGPoint(x: 0, y: 0)
        background.scene?.scaleMode = .aspectFit
        
        let backgroundMore = SKSpriteNode(imageNamed: "background")
        backgroundMore.size = size
        backgroundMore.position = CGPoint(x: size.width, y: 0)
        backgroundMore.scene?.scaleMode = .aspectFit
        
        background.run(
            SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.moveTo(x: -size.width, duration: 3.0),
                    SKAction.moveTo(x: 0, duration: 0),
                ])
            )
        )
        
        backgroundMore.run(
            SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.moveTo(x: 0, duration: 3.0),
                    SKAction.moveTo(x: size.width, duration: 0),
                ])
            )
        )
        
        addChild(background)
        addChild(backgroundMore)
    }
    
    private func drawTwitter() {
        let f1 = SKTexture.init(imageNamed: "twitterbird1")
        let f2 = SKTexture.init(imageNamed: "twitterbird2")
        let frames: [SKTexture] = [f1, f2]
        
        twitter = SKSpriteNode(imageNamed: "twitterbird1")
        guard let twitter = twitter else { return }
        
        twitter.zPosition = 1
        twitter.position = CGPoint(x: self.frame.midX - frame.width/4, y: self.frame.midY)
        
        let animation = SKAction.animate(with: frames, timePerFrame: 0.1)
        twitter.run(SKAction.repeatForever(animation))
        
        twitter.physicsBody?.isDynamic = true
        twitter.physicsBody?.allowsRotation = false
        twitter.physicsBody = SKPhysicsBody(rectangleOf: twitter.frame.size)
        addChild(twitter)
    }
    
    private func drawObstacle() {
       obstacle = SKSpriteNode(texture: SKTexture, color: <#T##UIColor#>, size: <#T##CGSize#>)
    }
}
