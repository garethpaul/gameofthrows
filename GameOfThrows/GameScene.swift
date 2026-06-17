//
//  GameScene.swift
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let verticalPipeGap: CGFloat = 150.0

    var bird: SKSpriteNode!
    var skyColor: SKColor!
    var pipeTextureUp: SKTexture!
    var pipeTextureDown: SKTexture!
    var movePipesAndRemove: SKAction!
    var moving: SKNode!
    var pipes: SKNode!
    var canRestart = false
    var scoreLabelNode: SKLabelNode!
    var score = 0
    
    let birdCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3

    func cancelBirdDeathRotation() {
        bird?.removeAction(forKey: "deathRotation")
    }

    func resetScenePresentation() {
        cancelBirdDeathRotation()
        removeAction(forKey: "spawnPipes")
        removeAction(forKey: "flash")
        removeAllChildren()
    }

    override func didMove(to view: SKView) {
        resetScenePresentation()

        canRestart = false

        // setup physics
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        physicsWorld.contactDelegate = self

        // setup background color
        skyColor = SKColor(red: 81.0/255.0, green: 192.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        backgroundColor = skyColor

        moving = SKNode()
        addChild(moving)
        pipes = SKNode()
        moving.addChild(pipes)

        // ground
        let groundTexture = SKTexture(imageNamed: "land")
        groundTexture.filteringMode = .nearest

        let moveGroundSprite = SKAction.moveBy(x: -groundTexture.size().width * 2.0, y: 0, duration: TimeInterval(0.02 * groundTexture.size().width * 2.0))
        let resetGroundSprite = SKAction.moveBy(x: groundTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveGroundSpritesForever = SKAction.repeatForever(SKAction.sequence([moveGroundSprite, resetGroundSprite]))

        for i in 0..<Int(2.0 + frame.size.width / (groundTexture.size().width * 2.0)) {
            let sprite = SKSpriteNode(texture: groundTexture)
            sprite.setScale(2.0)
            sprite.position = CGPoint(x: CGFloat(i) * sprite.size.width, y: sprite.size.height / 2.0)
            sprite.run(moveGroundSpritesForever)
            moving.addChild(sprite)
        }

        // skyline
        let skyTexture = SKTexture(imageNamed: "sky")
        skyTexture.filteringMode = .nearest

        let moveSkySprite = SKAction.moveBy(x: -skyTexture.size().width * 2.0, y: 0, duration: TimeInterval(0.1 * skyTexture.size().width * 2.0))
        let resetSkySprite = SKAction.moveBy(x: skyTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveSkySpritesForever = SKAction.repeatForever(SKAction.sequence([moveSkySprite, resetSkySprite]))

        for i in 0..<Int(2.0 + frame.size.width / (groundTexture.size().width * 2.0)) {
            let sprite = SKSpriteNode(texture: skyTexture)
            sprite.setScale(2.0)
            sprite.zPosition = -20
            sprite.position = CGPoint(x: CGFloat(i) * sprite.size.width, y: sprite.size.height / 2.0 + groundTexture.size().height * 2.0)
            sprite.run(moveSkySpritesForever)
            moving.addChild(sprite)
        }

        // create the pipes textures
        pipeTextureUp = SKTexture(imageNamed: "PipeUp")
        pipeTextureUp.filteringMode = .nearest
        pipeTextureDown = SKTexture(imageNamed: "PipeDown")
        pipeTextureDown.filteringMode = .nearest

        // create the pipes movement actions
        let distanceToMove = frame.size.width + 2.0 * pipeTextureUp.size().width
        let movePipes = SKAction.moveBy(x: -distanceToMove, y: 0.0, duration: TimeInterval(0.01 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        movePipesAndRemove = SKAction.sequence([movePipes, removePipes])

        // spawn the pipes
        let spawn = SKAction.run { [weak self] in self?.spawnPipes() }
        let delay = SKAction.wait(forDuration: 2.0)
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatForever(spawnThenDelay)
        run(spawnThenDelayForever, withKey: "spawnPipes")

        // setup our bird
        let birdTexture1 = SKTexture(imageNamed: "bird-01")
        birdTexture1.filteringMode = .nearest
        let birdTexture2 = SKTexture(imageNamed: "bird-02")
        birdTexture2.filteringMode = .nearest

        let anim = SKAction.animate(with: [birdTexture1, birdTexture2], timePerFrame: 0.2)
        let flap = SKAction.repeatForever(anim)

        bird = SKSpriteNode(texture: birdTexture1)
        bird.setScale(2.0)
        bird.position = CGPoint(x: frame.size.width * 0.35, y: frame.size.height * 0.6)
        bird.run(flap)

        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2.0)
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.allowsRotation = false

        bird.physicsBody?.categoryBitMask = birdCategory
        bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        bird.physicsBody?.contactTestBitMask = worldCategory | pipeCategory

        addChild(bird)

        // create the ground
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: groundTexture.size().height)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.size.width, height: groundTexture.size().height * 2.0))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = worldCategory
        addChild(ground)

        // Initialize label and create a label which holds the score
        score = 0
        scoreLabelNode = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        scoreLabelNode.position = CGPoint(x: frame.midX, y: 3 * frame.size.height / 4)
        scoreLabelNode.zPosition = 100
        scoreLabelNode.text = String(score)
        addChild(scoreLabelNode)
    }

    override func willMove(from view: SKView) {
        canRestart = false
        moving?.speed = 0
        cancelBirdDeathRotation()
        removeAction(forKey: "spawnPipes")
        removeAction(forKey: "flash")
        physicsWorld.contactDelegate = nil
    }
    
    func spawnPipes() {
        if !shouldSpawnPipes() {
            return
        }

        let pipePair = SKNode()
        pipePair.position = CGPoint(x: frame.size.width + pipeTextureUp.size().width * 2, y: 0)
        pipePair.zPosition = -10

        let height = max(UInt32(frame.size.height / 4), 1)
        let y = arc4random_uniform(height) + height

        let pipeDown = SKSpriteNode(texture: pipeTextureDown)
        pipeDown.setScale(2.0)
        pipeDown.position = CGPoint(x: 0.0, y: CGFloat(y) + pipeDown.size.height + verticalPipeGap)

        pipeDown.physicsBody = SKPhysicsBody(rectangleOf: pipeDown.size)
        pipeDown.physicsBody?.isDynamic = false
        pipeDown.physicsBody?.categoryBitMask = pipeCategory
        pipeDown.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(pipeDown)

        let pipeUp = SKSpriteNode(texture: pipeTextureUp)
        pipeUp.setScale(2.0)
        pipeUp.position = CGPoint(x: 0.0, y: CGFloat(y))

        pipeUp.physicsBody = SKPhysicsBody(rectangleOf: pipeUp.size)
        pipeUp.physicsBody?.isDynamic = false
        pipeUp.physicsBody?.categoryBitMask = pipeCategory
        pipeUp.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(pipeUp)

        let contactNode = SKNode()
        contactNode.position = CGPoint(x: pipeDown.size.width + bird.size.width / 2, y: frame.midY)
        contactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeUp.size.width, height: frame.size.height))
        contactNode.physicsBody?.isDynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(contactNode)
        pipePair.run(movePipesAndRemove)
        pipes.addChild(pipePair)
    }

    func shouldSpawnPipes() -> Bool {
        return isGameplayRunning() &&
            pipes != nil &&
            pipeTextureUp != nil &&
            pipeTextureDown != nil &&
            bird != nil &&
            movePipesAndRemove != nil
    }

    func isGameplayRunning() -> Bool {
        return moving != nil && moving.speed > 0
    }
    
    func resetScene() {
        guard let bird = bird,
            let pipes = pipes,
            let moving = moving,
            let scoreLabelNode = scoreLabelNode else {
            return
        }

        bird.removeAction(forKey: "deathRotation")

        // Move bird to original position and reset velocity
        bird.position = CGPoint(x: frame.size.width / 2.5, y: frame.midY)
        bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        bird.speed = 1.0
        bird.zRotation = 0.0
        
        // Remove all existing pipes
        pipes.removeAllChildren()
        
        // Reset _canRestart
        canRestart = false
        
        // Reset score
        score = 0
        scoreLabelNode.text = String(score)
        scoreLabelNode.setScale(1.0)
        
        // Restart animation
        moving.speed = 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameplayRunning() {
            applyBirdImpulse()
        } else if canRestart {
            resetScene()
        }
    }

    func applyBirdImpulse() {
        guard let bird = bird, let physicsBody = bird.physicsBody else {
            return
        }

        physicsBody.velocity = CGVector(dx: 0, dy: 0)
        physicsBody.applyImpulse(CGVector(dx: 0, dy: 30))
    }

    // TODO: Move to utilities somewhere. There's no reason this should be a member function
    func clamp(minimum: CGFloat, maximum: CGFloat, value: CGFloat) -> CGFloat {
        if value > maximum {
            return maximum
        } else if value < minimum {
            return minimum
        } else {
            return value
        }
    }

    func bodyMatchesCategory(_ body: SKPhysicsBody, category: UInt32) -> Bool {
        return (body.categoryBitMask & category) == category
    }

    func scoreContactNode(_ contact: SKPhysicsContact) -> SKNode? {
        let bodyAIsScore = bodyMatchesCategory(contact.bodyA, category: scoreCategory)
        let bodyBIsScore = bodyMatchesCategory(contact.bodyB, category: scoreCategory)
        let bodyAIsBird = bodyMatchesCategory(contact.bodyA, category: birdCategory)
        let bodyBIsBird = bodyMatchesCategory(contact.bodyB, category: birdCategory)

        if bodyAIsScore && bodyBIsBird {
            return contact.bodyA.node
        }

        if bodyBIsScore && bodyAIsBird {
            return contact.bodyB.node
        }

        return nil
    }

    func isBirdCollisionContact(_ contact: SKPhysicsContact) -> Bool {
        let bodyAIsBird = bodyMatchesCategory(contact.bodyA, category: birdCategory)
        let bodyBIsBird = bodyMatchesCategory(contact.bodyB, category: birdCategory)
        let bodyAIsObstacle = bodyMatchesCategory(contact.bodyA, category: worldCategory) ||
            bodyMatchesCategory(contact.bodyA, category: pipeCategory)
        let bodyBIsObstacle = bodyMatchesCategory(contact.bodyB, category: worldCategory) ||
            bodyMatchesCategory(contact.bodyB, category: pipeCategory)

        return (bodyAIsBird && bodyBIsObstacle) || (bodyBIsBird && bodyAIsObstacle)
    }
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        if !isGameplayRunning() {
            return
        }

        guard let bird = bird, let physicsBody = bird.physicsBody else {
            return
        }

        let verticalVelocity = physicsBody.velocity.dy
        bird.zRotation = clamp(
            minimum: -1,
            maximum: 0.5,
            value: verticalVelocity * (verticalVelocity < 0 ? 0.003 : 0.001)
        )
    }

    func didBegin(_ contact: SKPhysicsContact) {
        if !isGameplayRunning() {
            return
        }

        guard let bird = bird,
            let moving = moving,
            let scoreLabelNode = scoreLabelNode,
            let skyColor = skyColor else {
            return
        }

        if let scoringNode = scoreContactNode(contact) {
            // Bird has contact with score entity
            scoringNode.physicsBody = nil
            scoringNode.removeFromParent()
            score += 1
            scoreLabelNode.text = String(score)

            // Add a little visual feedback for the score increment
            scoreLabelNode.run(SKAction.sequence([
                SKAction.scale(to: 1.5, duration: 0.1),
                SKAction.scale(to: 1.0, duration: 0.1)
            ]))
            return
        }

        if !isBirdCollisionContact(contact) {
            return
        }

        moving.speed = 0

        bird.physicsBody?.collisionBitMask = worldCategory
        let deathRotation = SKAction.rotate(byAngle: .pi * bird.position.y * 0.01, duration: 1)
        let stopBird = SKAction.run { bird.speed = 0 }
        bird.run(SKAction.sequence([deathRotation, stopBird]), withKey: "deathRotation")


        // Flash background if contact is detected
        removeAction(forKey: "flash")
        run(SKAction.sequence([
            SKAction.repeat(SKAction.sequence([
                SKAction.run {
                    self.backgroundColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
                },
                SKAction.wait(forDuration: 0.05),
                SKAction.run {
                    self.backgroundColor = skyColor
                },
                SKAction.wait(forDuration: 0.05)
            ]), count: 4),
            SKAction.run {
                self.canRestart = true
            }
        ]), withKey: "flash")
    }
}
