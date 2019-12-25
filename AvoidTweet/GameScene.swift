//
//  GameScene.swift
//  AvoidTweet
//
//  Created by Keigo Nakagawa on 2019/12/12.
//  Copyright © 2019 Keigo Nakagawa. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var twitter : SKSpriteNode?
    private var background : SKSpriteNode?
    private var spinnyNode : SKShapeNode?
    private var obstacle : SKSpriteNode?
    
    override func didMove(to view: SKView) {
        
        physicsWorld.gravity =  CGVector(dx: 0, dy: -0.5)
        physicsWorld.contactDelegate = self
        physicsBody?.isDynamic = false
        physicsBody?.allowsRotation = false
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.affectedByGravity = false
        

        drawBackground()
        drawTwitter()
        drawObstacle()
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print(contact)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let diff = frame.origin.y * -1 - twitter!.position.y
        let jump = diff < 150 ? diff : 150
        twitter?.run(SKAction.moveTo(y: twitter!.position.y + jump, duration: 0.5))
        
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
        
        twitter.physicsBody = SKPhysicsBody(texture: twitter.texture!, size: twitter.frame.size)
        twitter.physicsBody?.allowsRotation = false
        twitter.physicsBody?.categoryBitMask = 1
        twitter.physicsBody?.collisionBitMask = 1
        twitter.physicsBody?.contactTestBitMask = 1
        addChild(twitter)
    }
    
    private func drawObstacle() {
        let square = SKLabelNode(text: "ツイート！！！")
        square.position = CGPoint(x: size.width, y: frame.midY)
        square.fontColor = .red
        square.zPosition = 1
        square.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: square.frame.width, height: square.frame.height))
        square.physicsBody?.isDynamic = false
        square.physicsBody?.affectedByGravity = false
        square.physicsBody?.categoryBitMask = 1
        square.physicsBody?.collisionBitMask = 1

        square.run(
            SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.moveTo(x: -size.width, duration: 4.5),
                    SKAction.run({
                        square.position = CGPoint(x: self.size.width,
                                                  y: CGFloat.random(in: self.frame.origin.y + square.frame.height..<(self.frame.origin.y * -1) - square.frame.height))
                    })
                ])
            )
        )

        self.addChild(square)
    }
}

// ハマった点
// 1. 回転する -> isDynamicの設定, physicBody の設定順序
// 2. 画面から出る -> jumpの設定
// 3. 衝突判定 -> 下記の設定
//twitter.physicsBody?.categoryBitMask = 1
//twitter.physicsBody?.collisionBitMask = 1
//twitter.physicsBody?.contactTestBitMask = 1
