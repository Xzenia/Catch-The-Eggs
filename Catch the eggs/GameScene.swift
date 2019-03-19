//
//  GameScene.swift
//  Catch the eggs
//
//  Created by student on 01/03/2019.
//  Copyright © 2019 dlsud. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    private var lastUpdateTime : TimeInterval = 0
    
    private var backgroundSprite = SKSpriteNode(imageNamed: "Background")
    
    private var currentEggDropSpawnTime : TimeInterval = 0
    
    private var eggDropSpawnRate : TimeInterval = 0.5
    
    private var chickenList = [SKSpriteNode]()
    
    private var eggMotherNode = SKNode()
    
    private var worldNode = SKNode()
    
    private var points = 0
    
    private var scoreLabel = SKLabelNode(fontNamed: "Splatch")
    
    private var timeLabel = SKLabelNode(fontNamed: "Splatch")
    
    private var pauseButton = SKSpriteNode(imageNamed: "Pause")
    
    private var restartButton = SKSpriteNode(imageNamed: "Restart")
    
    private var gameTimer = Timer()
    
    private var gameOverBackground = SKSpriteNode(imageNamed: "black background")
    
    private var gameOverText = SKLabelNode(fontNamed: "Splatch")
    
    private var gameOverPlayButton = SKSpriteNode(imageNamed:"Play Button")
    
    let chicken1 = SKSpriteNode(imageNamed: "Chicken")
    let chicken2 = SKSpriteNode(imageNamed: "Chicken")
    let chicken3 = SKSpriteNode(imageNamed: "Chicken")
    let chicken4 = SKSpriteNode(imageNamed: "Chicken")
    
    let cart = SKSpriteNode(imageNamed: "Cart")
    
    var gameIsPaused = false
    
    var gameTime = 30
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        setupUIElements()
        
        setupGameOverUI()
        
        setupChickens()
        
        setupCart()
        
        worldNode.addChild(eggMotherNode)
        
        addChild(worldNode)
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            self.timerManager()
        })
    
    }
    
    func setupUIElements(){
        backgroundSprite.position = CGPoint(x: size.width/2, y: size.height/2)
        backgroundSprite.xScale = 0.32
        backgroundSprite.yScale = 0.32
        addChild(backgroundSprite)
        
        scoreLabel.position = CGPoint(x: (size.width - size.width) + 20, y: size.height - 30)
        scoreLabel.fontColor = UIColor.black
        scoreLabel.fontSize = 16
        scoreLabel.zPosition = 5
        addChild(scoreLabel)
        
        timeLabel.position = CGPoint(x: size.width/2 , y: size.height - 30)
        timeLabel.fontColor = UIColor.yellow
        timeLabel.fontSize = 16
        timeLabel.zPosition = 5
        addChild(timeLabel)
        
        pauseButton.position = CGPoint(x: size.width-20, y: size.height - 20)
        pauseButton.xScale = 0.2
        pauseButton.yScale = 0.2
        pauseButton.zPosition = 5
        addChild(pauseButton)
        
        restartButton.position = CGPoint(x: size.width-20, y: size.height - 60)
        restartButton.xScale = 0.2
        restartButton.yScale = 0.2
        restartButton.zPosition = 5
        addChild(restartButton)
    }
    
    func setupGameOverUI(){
        gameOverBackground.position = CGPoint(x: size.width/2, y: size.height/2)
        gameOverBackground.zPosition = 10
        gameOverBackground.alpha = 0.75
        addChild(gameOverBackground)
        
        gameOverText.position = CGPoint(x: size.width/2, y: size.height - 50)
        gameOverText.fontSize = 16
        gameOverText.zPosition = 11
        addChild(gameOverText)
        
        gameOverPlayButton.position = CGPoint(x: size.width/2, y: size.height/2)
        gameOverPlayButton.zPosition = 12
        gameOverPlayButton.xScale = 0.75
        gameOverPlayButton.yScale = 0.75
        addChild(gameOverPlayButton)

        gameOverBackground.isHidden = true
        gameOverText.isHidden = true
        gameOverPlayButton.isHidden = true
    }
    
    func setupChickens(){
        chicken1.position = CGPoint(x: 50 * 1.5, y: 300)
        chicken2.position = CGPoint(x: 150 * 1.5, y: 300)
        chicken3.position = CGPoint(x: 250 * 1.5, y: 300)
        chicken4.position = CGPoint(x: 350 * 1.5, y: 300)
        
        chicken1.xScale = 0.4
        chicken1.yScale = 0.4
        chicken1.zPosition = 4
        
        chicken2.xScale = 0.4
        chicken2.yScale = 0.4
        chicken2.zPosition = 4
        
        chicken3.xScale = 0.4
        chicken3.yScale = 0.4
        chicken3.zPosition = 4
        
        chicken4.xScale = 0.4
        chicken4.yScale = 0.4
        chicken4.zPosition = 4
        
        worldNode.addChild(chicken1)
        worldNode.addChild(chicken2)
        worldNode.addChild(chicken3)
        worldNode.addChild(chicken4)
        
        chickenList.append(chicken1)
        chickenList.append(chicken2)
        chickenList.append(chicken3)
        chickenList.append(chicken4)
    }
    
    func setupCart(){
        cart.position = CGPoint(x:size.width/2, y:size.height/9)
        cart.xScale = 0.5
        cart.yScale = 0.5
        cart.zPosition = 5
        
        let cartTexture = SKTexture(imageNamed:"Cart")
        cart.physicsBody = SKPhysicsBody(texture: cartTexture, size: cart.size)
        cart.physicsBody?.categoryBitMask = PhysicsCategory.Cart
        cart.physicsBody?.contactTestBitMask = PhysicsCategory.Egg
        cart.physicsBody?.collisionBitMask = PhysicsCategory.Egg
        cart.physicsBody?.isDynamic = false
        cart.physicsBody?.affectedByGravity = false
        cart.name = "cart"
        
        worldNode.addChild(cart)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA.node!
        let secondBody = contact.bodyB.node!
        
        if ((firstBody.name == "cart") && (secondBody.name == "egg")){
            eggMotherNode.removeChildren(in: [secondBody])
            points += 1
        }
    }
    
    override func update(_ currentTime: TimeInterval) {

        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }

        let dt = currentTime - self.lastUpdateTime
        self.lastUpdateTime = currentTime
        
        currentEggDropSpawnTime += dt
        if currentEggDropSpawnTime > eggDropSpawnRate && !gameIsPaused {
            currentEggDropSpawnTime = 0
            spawnEgg()
        }

        scoreLabel.text = "\(points)"
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if pauseButton.contains(touch.location(in: self)){
                if (!gameIsPaused){
                    physicsWorld.speed = 0
                    pauseButton.texture = SKTexture(imageNamed: "Play")
                    gameIsPaused = true
                    
                } else {
                    physicsWorld.speed = 1
                    pauseButton.texture = SKTexture(imageNamed: "Pause")
                    gameIsPaused = false
                }
            }
            
            if restartButton.contains(touch.location(in: self)){
                if (!gameIsPaused){
                    restartGame()
                }
            }
            
            if gameOverPlayButton.contains(touch.location(in: self)){
                gameIsPaused = false
                restartGame()
                
                gameOverBackground.isHidden = true
                gameOverText.isHidden = true
                gameOverPlayButton.isHidden = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if (!gameIsPaused){
                cart.position.x = location.x
            }

        }
    }
    
    func timerManager(){
        if (!gameIsPaused){
            gameTime -= 1
            timeLabel.text = "\(gameTime)"
            if (gameTime <= 0){
                gameIsPaused = true
                gameOverText.text = "GAME OVER! YOU CAUGHT \(self.points) EGGS!"
                gameOverBackground.isHidden = false
                gameOverText.isHidden = false
                gameOverPlayButton.isHidden = false
            }
        }
    }
    
    func restartGame(){
        points = 0
        gameTime = 30
        eggMotherNode.removeAllChildren()
        cart.position = CGPoint(x:size.width/2, y:size.height/9)
    }
    
    func spawnEgg(){
        let egg = SKSpriteNode(imageNamed: "egg")
        let eggTexture = SKTexture(imageNamed: "egg")
        let randomIndex = Int(arc4random_uniform(UInt32(chickenList.count)))
        
        egg.physicsBody = SKPhysicsBody(texture: eggTexture, size: egg.size)
        egg.physicsBody?.categoryBitMask = PhysicsCategory.Egg
        egg.physicsBody?.collisionBitMask = PhysicsCategory.Cart
        egg.physicsBody?.contactTestBitMask = PhysicsCategory.Cart
        egg.physicsBody?.affectedByGravity = true
        
        egg.zPosition = 1
        egg.position = chickenList[randomIndex].position
        egg.xScale = 0.3
        egg.yScale = 0.3
        egg.name = "egg"
        
        eggMotherNode.addChild(egg)
    }
}

struct PhysicsCategory{
    static let Egg : UInt32 = 0x1 << 0
    static let Cart: UInt32 = 0x1 << 1
}

