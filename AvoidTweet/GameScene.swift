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
    private var backgroundMore : SKSpriteNode?
    private var tweet1 : SKLabelNode?
    private var tweet2 : SKLabelNode?
    private var tweet3 : SKLabelNode?
    private var terminate : SKLabelNode?
    private var restart : SKSpriteNode?

    private var terminated: Bool = false
    
    override func didMove(to view: SKView) {
        
        physicsWorld.gravity =  CGVector(dx: 0, dy: -0.5)
        physicsWorld.contactDelegate = self
        physicsBody?.isDynamic = false
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        
        drawBackground()
        drawTwitter()
   
        tweet1 = SKLabelNode(text: "ツイート！！！")
        tweet2 = SKLabelNode(text: "なんでやねん！！！")
        tweet3 = SKLabelNode(text: "ラーメン食いたい🍜！！！")
        drawObstacle(tweet: tweet1!, duration: 3.5)
        drawObstacle(tweet: tweet2!, duration: 4.5)
        drawObstacle(tweet: tweet3!, duration: 5.5)
    }

    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        terminated = true
        self.scene?.isPaused = true
        drawTerminate()
        drawRestart()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchDown(atPoint: t.location(in: self))
            let targets = self.nodes(at: t.location(in: self))
            for node in targets {
                if node.name == "restart" {
                    self.reset()
                }
            }
        }
        
        if terminated {
            return
        }
        let diff = frame.origin.y * -1 - twitter!.position.y
        let jump = diff < 150 ? diff : 150
        twitter?.run(SKAction.moveTo(y: twitter!.position.y + jump, duration: 0.5))
        
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
        
        backgroundMore = SKSpriteNode(imageNamed: "background")
        guard let backgroundMore = backgroundMore else { return }
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
    
    private func drawObstacle(tweet: SKLabelNode, duration: TimeInterval) {
        tweet.position = CGPoint(x: size.width, y: CGFloat.random(in: self.frame.origin.y + tweet.frame.height..<(self.frame.origin.y * -1) - tweet.frame.height))
        tweet.fontColor = .black
        tweet.fontSize = 40
        tweet.zPosition = 1
        tweet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: tweet.frame.width, height: tweet.frame.height))
        tweet.physicsBody?.isDynamic = false
        tweet.physicsBody?.affectedByGravity = false
        tweet.physicsBody?.categoryBitMask = 1
        tweet.physicsBody?.collisionBitMask = 1

        tweet.run(
            SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.moveTo(x: -size.width, duration: duration),
                    SKAction.run({
                        tweet.position = CGPoint(x: self.size.width,
                                                  y: CGFloat.random(in: self.frame.origin.y + tweet.frame.height..<(self.frame.origin.y * -1) - tweet.frame.height))
                    })
                ])
            )
        )

        self.addChild(tweet)
    }
    
    private func drawTerminate() {
        if let terminate = terminate {
            terminate.isHidden = false
            return
        }
        terminate = SKLabelNode(text: "本日はここまで")
        terminate?.position = CGPoint(x: 0.5, y: 0.5)
        terminate?.fontColor = .red
        terminate?.fontSize = 80
        terminate?.zPosition = 2
        
        self.addChild(terminate!)
    }
    
    private func drawRestart() {
        if let restart = restart {
            restart.isHidden = false
            return
        }
        restart = SKSpriteNode(imageNamed: "restart")
        guard let restart = restart else { return }
        
        restart.zPosition = 2
        let y = frame.origin.y * -1
        restart.position = CGPoint(x: 0.5, y: y - 100)
        restart.name = "restart"
        addChild(restart)
    }
    
    private func reset() {
        twitter?.position = CGPoint(x: self.frame.midX - frame.width/4, y: self.frame.midY)
//        tweet1?.position = CGPoint(x: size.width, y: (tweet1?.frame.origin.y)!)
//        tweet2?.position = CGPoint(x: size.width, y: (tweet2?.frame.origin.y)!)
//        tweet3?.position = CGPoint(x: size.width, y: (tweet3?.frame.origin.y)!)
        removeChildren(in: [
            tweet1!,
            tweet2!,
            tweet3!
        ])
        tweet1 = SKLabelNode(text: "ツイート！！！")
        tweet2 = SKLabelNode(text: "なんでやねん！！！")
        tweet3 = SKLabelNode(text: "ラーメン食いたい🍜！！！")
        drawObstacle(tweet: tweet1!, duration: 3.5)
        drawObstacle(tweet: tweet2!, duration: 4.5)
        drawObstacle(tweet: tweet3!, duration: 5.5)
        restart?.isHidden = true
        terminate?.isHidden = true
        terminated = false
        self.scene?.isPaused = false
    }
}

// ハマった点
// 1. 回転する -> isDynamicの設定, physicBody の設定順序
// 2. 画面から出る -> jumpの設定
// 3. 衝突判定 -> 下記の設定
//twitter.physicsBody?.categoryBitMask = 1
//twitter.physicsBody?.collisionBitMask = 1
//twitter.physicsBody?.contactTestBitMask = 1
